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

  bool _loaded = false;

  Profile get profile => _profile ?? MockData.currentProfile;
  Set<String> get followedGroupIds => Set.unmodifiable(_followedGroupIds);
  Set<String> get memberGroupIds => Set.unmodifiable(_memberGroupIds);
  List<Group> get userCreatedGroups => List.unmodifiable(_userCreatedGroups);

  List<ConversationMessage> directMessages(String studentId) =>
      List.unmodifiable(_directMessages[studentId] ?? const []);

  List<GroupMessage> groupMessages(String groupId) =>
      List.unmodifiable(_groupMessages[groupId] ?? const []);

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

  Future<void> _loadFollowedGroups(Database db) async {
    final rows = await db.query(Tables.followedGroups);
    if (rows.isEmpty) {
      final now = DateTime.now().toIso8601String();
      for (final id in MockData.myGroupIds) {
        await db.insert(Tables.followedGroups, {
          FollowedGroupColumns.groupId: id,
          FollowedGroupColumns.followedAt: now,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
        _followedGroupIds.add(id);
      }
    } else {
      for (final row in rows) {
        _followedGroupIds.add(row[FollowedGroupColumns.groupId] as String);
      }
    }
  }

  Future<void> _loadMemberGroups(Database db) async {
    final rows = await db.query(Tables.memberGroups);
    if (rows.isEmpty) {
      final now = DateTime.now().toIso8601String();
      for (final id in MockData.myGroupIds) {
        await db.insert(Tables.memberGroups, {
          MemberGroupColumns.groupId: id,
          MemberGroupColumns.joinedAt: now,
          MemberGroupColumns.role: 'member',
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
        _memberGroupIds.add(id);
      }
    } else {
      for (final row in rows) {
        _memberGroupIds.add(row[MemberGroupColumns.groupId] as String);
      }
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
    final db = await DatabaseService.instance.database;
    await db.insert(Tables.directMessages, {
      DirectMessageColumns.id: msg.id,
      DirectMessageColumns.studentId: studentId,
      DirectMessageColumns.payload: msg.toJsonString(),
      DirectMessageColumns.sentAt: DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    notifyListeners();
  }

  Future<void> sendGroupMessage(String groupId, GroupMessage msg) async {
    _groupMessages.putIfAbsent(groupId, () => []).add(msg);
    final db = await DatabaseService.instance.database;
    await db.insert(Tables.groupMessages, {
      GroupMessageColumns.id: msg.id,
      GroupMessageColumns.groupId: groupId,
      GroupMessageColumns.payload: msg.toJsonString(),
      GroupMessageColumns.sentAt: DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    notifyListeners();
  }
}
