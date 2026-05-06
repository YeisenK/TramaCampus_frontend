import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/database/database_service.dart';
import '../../core/database/schema.dart';
import '../mock/mock_data.dart';
import '../models/conversation_message.dart';
import '../models/group.dart';
import '../models/group_message.dart';
import '../models/profile/profile.dart';
import 'profile_repository.dart';

class AppStateRepository extends ChangeNotifier {
  AppStateRepository._();
  static final AppStateRepository instance = AppStateRepository._();

  Profile? _profile;
  final Set<String> _followedGroupIds = {};
  final Set<String> _memberGroupIds = {};
  final List<Group> _userCreatedGroups = [];
  final Map<String, List<ConversationMessage>> _directMessages = {};
  final Map<String, List<GroupMessage>> _groupMessages = {};
  final Map<String, DateTime> _directLastAt = {};
  final Map<String, DateTime> _groupLastAt = {};

  bool _loaded = false;

  Profile get profile => _profile ?? MockData.currentProfile;
  Set<String> get followedGroupIds => Set.unmodifiable(_followedGroupIds);
  Set<String> get memberGroupIds => Set.unmodifiable(_memberGroupIds);
  List<Group> get userCreatedGroups => List.unmodifiable(_userCreatedGroups);

  List<ConversationMessage> directMessages(String studentId) =>
      List.unmodifiable(_directMessages[studentId] ?? const []);

  List<GroupMessage> groupMessages(String groupId) =>
      List.unmodifiable(_groupMessages[groupId] ?? const []);

  Iterable<String> get activeDirectStudentIds => _directMessages.entries
      .where((e) => e.value.isNotEmpty)
      .map((e) => e.key);

  DateTime? directLastAt(String studentId) => _directLastAt[studentId];
  DateTime? groupLastAt(String groupId) => _groupLastAt[groupId];

  bool isFollowing(String groupId) => _followedGroupIds.contains(groupId);
  bool isMember(String groupId) => _memberGroupIds.contains(groupId);

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;

    _profile = await MockProfileRepository.instance.load();

    final db = await DatabaseService.instance.database;

    await _loadFollowedGroups(db);
    await _loadMemberGroups(db);
    await _loadUserGroups(db);
    await _loadDirectMessages(db);
    await _loadGroupMessages(db);
  }

  static const _kSeedMemberFlag = 'demo_member_seed_v1';
  static const _kSeedFollowFlag = 'demo_follow_seed_v2';

  Future<String?> _metaGet(Database db, String key) async {
    final rows = await db.query(
      Tables.meta,
      where: '${MetaColumns.key} = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first[MetaColumns.value] as String?;
  }

  Future<void> _metaSet(Database db, String key, String value) async {
    await db.insert(
      Tables.meta,
      {MetaColumns.key: key, MetaColumns.value: value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _loadFollowedGroups(Database db) async {
    final rows = await db.query(Tables.followedGroups);
    for (final row in rows) {
      _followedGroupIds.add(row[FollowedGroupColumns.groupId] as String);
    }
    // Demo seed — runs once per flag version. Idempotent: only inserts
    // ids that aren't already present.
    if (await _metaGet(db, _kSeedFollowFlag) == null) {
      final now = DateTime.now().toIso8601String();
      final seed = {...MockData.myGroupIds, ...MockData.myFollowedGroupIds};
      for (final id in seed) {
        if (_followedGroupIds.add(id)) {
          await db.insert(Tables.followedGroups, {
            FollowedGroupColumns.groupId: id,
            FollowedGroupColumns.followedAt: now,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }
      await _metaSet(db, _kSeedFollowFlag, '1');
    }
  }

  Future<void> _loadMemberGroups(Database db) async {
    final rows = await db.query(Tables.memberGroups);
    for (final row in rows) {
      _memberGroupIds.add(row[MemberGroupColumns.groupId] as String);
    }
    if (await _metaGet(db, _kSeedMemberFlag) == null) {
      final now = DateTime.now().toIso8601String();
      for (final id in MockData.myGroupIds) {
        if (_memberGroupIds.add(id)) {
          await db.insert(Tables.memberGroups, {
            MemberGroupColumns.groupId: id,
            MemberGroupColumns.joinedAt: now,
            MemberGroupColumns.role: 'member',
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }
      await _metaSet(db, _kSeedMemberFlag, '1');
    }
  }

  Future<void> _loadUserGroups(Database db) async {
    final rows = await db.query(
      Tables.userGroups,
      orderBy: '${UserGroupColumns.createdAt} ASC',
    );
    for (final row in rows) {
      _userCreatedGroups.add(
        Group.fromJsonString(row[UserGroupColumns.payload] as String),
      );
    }
  }

  Future<void> _loadDirectMessages(Database db) async {
    final rows = await db.query(
      Tables.directMessages,
      orderBy: '${DirectMessageColumns.sentAt} ASC',
    );
    for (final row in rows) {
      final studentId = row[DirectMessageColumns.studentId] as String;
      final msg = ConversationMessage.fromJsonString(
        row[DirectMessageColumns.payload] as String,
      );
      _directMessages.putIfAbsent(studentId, () => []).add(msg);
      _directLastAt[studentId] = DateTime.parse(
        row[DirectMessageColumns.sentAt] as String,
      );
    }
  }

  Future<void> _loadGroupMessages(Database db) async {
    final rows = await db.query(
      Tables.groupMessages,
      orderBy: '${GroupMessageColumns.sentAt} ASC',
    );
    for (final row in rows) {
      final groupId = row[GroupMessageColumns.groupId] as String;
      final msg = GroupMessage.fromJsonString(
        row[GroupMessageColumns.payload] as String,
      );
      _groupMessages.putIfAbsent(groupId, () => []).add(msg);
      _groupLastAt[groupId] = DateTime.parse(
        row[GroupMessageColumns.sentAt] as String,
      );
    }
  }

  // --- Profile ---

  Future<void> updateProfile(Profile p) async {
    _profile = p;
    await MockProfileRepository.instance.save(p);
    notifyListeners();
  }

  // --- Group follow / membership ---

  Future<void> followGroup(String id) async {
    if (_followedGroupIds.contains(id)) return;
    _followedGroupIds.add(id);
    final db = await DatabaseService.instance.database;
    await db.insert(Tables.followedGroups, {
      FollowedGroupColumns.groupId: id,
      FollowedGroupColumns.followedAt: DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    notifyListeners();
  }

  Future<void> unfollowGroup(String id) async {
    if (!_followedGroupIds.remove(id)) return;
    final db = await DatabaseService.instance.database;
    await db.delete(
      Tables.followedGroups,
      where: '${FollowedGroupColumns.groupId} = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<void> joinGroup(String id) async {
    final db = await DatabaseService.instance.database;
    final now = DateTime.now().toIso8601String();
    if (!_memberGroupIds.contains(id)) {
      _memberGroupIds.add(id);
      await db.insert(Tables.memberGroups, {
        MemberGroupColumns.groupId: id,
        MemberGroupColumns.joinedAt: now,
        MemberGroupColumns.role: 'member',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    // Auto-follow when joining.
    if (!_followedGroupIds.contains(id)) {
      _followedGroupIds.add(id);
      await db.insert(Tables.followedGroups, {
        FollowedGroupColumns.groupId: id,
        FollowedGroupColumns.followedAt: now,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    notifyListeners();
  }

  Future<void> leaveGroup(String id) async {
    final removed = _memberGroupIds.remove(id);
    final unfollowed = _followedGroupIds.remove(id);
    if (!removed && !unfollowed) return;
    final db = await DatabaseService.instance.database;
    if (removed) {
      await db.delete(
        Tables.memberGroups,
        where: '${MemberGroupColumns.groupId} = ?',
        whereArgs: [id],
      );
    }
    if (unfollowed) {
      await db.delete(
        Tables.followedGroups,
        where: '${FollowedGroupColumns.groupId} = ?',
        whereArgs: [id],
      );
    }
    notifyListeners();
  }

  // --- Create group ---

  Future<Group> createGroup(Group group) async {
    _userCreatedGroups.add(group);
    await joinGroup(group.id);
    final db = await DatabaseService.instance.database;
    await db.insert(Tables.userGroups, {
      UserGroupColumns.id: group.id,
      UserGroupColumns.payload: group.toJsonString(),
      UserGroupColumns.createdAt: DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
    return group;
  }

  // --- Messages ---

  Future<void> sendDirectMessage(
    String studentId,
    ConversationMessage msg,
  ) async {
    _directMessages.putIfAbsent(studentId, () => []).add(msg);
    final now = DateTime.now();
    _directLastAt[studentId] = now;
    final db = await DatabaseService.instance.database;
    await db.insert(Tables.directMessages, {
      DirectMessageColumns.id: msg.id,
      DirectMessageColumns.studentId: studentId,
      DirectMessageColumns.payload: msg.toJsonString(),
      DirectMessageColumns.sentAt: now.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    notifyListeners();
  }

  Future<void> sendGroupMessage(String groupId, GroupMessage msg) async {
    _groupMessages.putIfAbsent(groupId, () => []).add(msg);
    final now = DateTime.now();
    _groupLastAt[groupId] = now;
    final db = await DatabaseService.instance.database;
    await db.insert(Tables.groupMessages, {
      GroupMessageColumns.id: msg.id,
      GroupMessageColumns.groupId: groupId,
      GroupMessageColumns.payload: msg.toJsonString(),
      GroupMessageColumns.sentAt: now.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    notifyListeners();
  }
}
