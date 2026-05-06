import 'package:sqflite/sqflite.dart';

import '../models/profile/profile.dart';
import '../mock/mock_data.dart';
import '../../core/database/database_service.dart';
import '../../core/database/schema.dart';

abstract class ProfileRepository {
  Future<Profile?> load();
  Future<void> save(Profile profile);
}

// v1: reads mock current-user; writes to SQLite profile table.
// v2: swap for ApiProfileRepository that calls PUT /v1/profile.
class MockProfileRepository implements ProfileRepository {
  MockProfileRepository._();
  static final MockProfileRepository instance = MockProfileRepository._();

  Profile? _cached;

  @override
  Future<Profile?> load() async {
    if (_cached != null) return _cached;
    // Try SQLite first (persisted edits from a previous session).
    final db = await DatabaseService.instance.database;
    final rows = await db.query(Tables.profile, limit: 1);
    if (rows.isNotEmpty) {
      _cached = Profile.fromJsonString(
        rows.first[ProfileColumns.payload] as String,
      );
      return _cached;
    }
    // Fall back to mock data.
    _cached = MockData.currentProfile;
    return _cached;
  }

  @override
  Future<void> save(Profile profile) async {
    _cached = profile;
    final db = await DatabaseService.instance.database;
    await db.insert(Tables.profile, {
      ProfileColumns.id: 1,
      ProfileColumns.payload: profile.toJsonString(),
      ProfileColumns.updatedAt: DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
