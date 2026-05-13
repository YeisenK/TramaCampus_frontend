import 'package:sqflite/sqflite.dart';

import '../../core/database/database_service.dart';
import '../../core/database/schema.dart';

/// Identifier of a "logged-in" demo user. Persisted across launches in
/// the `meta` table so the splash screen can skip the login flow when a
/// previous session exists.
class DemoSession {
  const DemoSession({required this.email, required this.userId});

  final String email;
  final int userId;
}

/// Tiny session store for the demo. Not auth — just a way for the
/// Discover screen to learn what `user_id` to send to the matching API.
class DemoSessionRepository {
  DemoSessionRepository._();
  static final DemoSessionRepository instance = DemoSessionRepository._();

  static const _kEmail = 'demo_session.email';
  static const _kUserId = 'demo_session.user_id';

  DemoSession? _cached;
  DemoSession? get cached => _cached;

  Future<DemoSession?> load() async {
    if (_cached != null) return _cached;
    final db = await DatabaseService.instance.database;
    final rows = await db.query(
      Tables.meta,
      where: '${MetaColumns.key} IN (?, ?)',
      whereArgs: const [_kEmail, _kUserId],
    );
    String? email;
    int? userId;
    for (final row in rows) {
      final key = row[MetaColumns.key] as String;
      final value = row[MetaColumns.value] as String;
      if (key == _kEmail) email = value;
      if (key == _kUserId) userId = int.tryParse(value);
    }
    if (email == null || userId == null) return null;
    _cached = DemoSession(email: email, userId: userId);
    return _cached;
  }

  Future<DemoSession> save(String email) async {
    final trimmed = email.trim().toLowerCase();
    final userId = userIdFromEmail(trimmed);
    final db = await DatabaseService.instance.database;
    await db.insert(
      Tables.meta,
      {MetaColumns.key: _kEmail, MetaColumns.value: trimmed},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.insert(
      Tables.meta,
      {MetaColumns.key: _kUserId, MetaColumns.value: userId.toString()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _cached = DemoSession(email: trimmed, userId: userId);
    return _cached!;
  }

  Future<void> clear() async {
    final db = await DatabaseService.instance.database;
    await db.delete(
      Tables.meta,
      where: '${MetaColumns.key} IN (?, ?)',
      whereArgs: const [_kEmail, _kUserId],
    );
    _cached = null;
  }
}

/// Stable `u32` derived from a string via FNV-1a 32-bit. Folded into
/// the 900_000..999_999 range to avoid colliding with the backend's
/// seeded ids (1..N).
int userIdFromEmail(String email) {
  const int fnvOffset = 0x811c9dc5;
  const int fnvPrime = 0x01000193;
  int hash = fnvOffset;
  for (final c in email.codeUnits) {
    hash ^= c;
    hash = (hash * fnvPrime) & 0xFFFFFFFF;
  }
  return 900000 + (hash % 100000);
}
