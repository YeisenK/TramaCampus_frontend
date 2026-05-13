import 'package:sqflite/sqflite.dart';

import '../models/profile/profile.dart';
import '../../core/database/database_service.dart';
import '../../core/database/schema.dart';

abstract class ProfileRepository {
  Future<Profile?> load();
  Future<void> save(Profile profile);
}

// v1: reads/writes the SQLite `profile` table. Returns null when no
// user-created profile exists — callers decide whether to fall back
// to a mock or send the user to onboarding.
class MockProfileRepository implements ProfileRepository {
  MockProfileRepository._();
  static final MockProfileRepository instance = MockProfileRepository._();

  Profile? _cached;
  bool _loaded = false;

  bool get hasPersistedProfile => _cached != null;

  @override
  Future<Profile?> load() async {
    if (_loaded) return _cached;
    final db = await DatabaseService.instance.database;
    final rows = await db.query(Tables.profile, limit: 1);
    if (rows.isNotEmpty) {
      _cached = Profile.fromJsonString(
        rows.first[ProfileColumns.payload] as String,
      );
    }
    _loaded = true;
    return _cached;
  }

  @override
  Future<void> save(Profile profile) async {
    _cached = profile;
    _loaded = true;
    final db = await DatabaseService.instance.database;
    await db.insert(Tables.profile, {
      ProfileColumns.id: 1,
      ProfileColumns.payload: profile.toJsonString(),
      ProfileColumns.updatedAt: DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Used by logout — wipe in-memory cache so the next user starts fresh.
  /// Does NOT delete the SQLite row (that's done explicitly via clear()).
  void clearCache() {
    _cached = null;
    _loaded = false;
  }

  Future<void> clear() async {
    final db = await DatabaseService.instance.database;
    await db.delete(Tables.profile);
    clearCache();
  }
}
