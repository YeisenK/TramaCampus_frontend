import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'migrations.dart';

const int kDatabaseVersion = 5;

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    assert(
      kMigrations.last.version == kDatabaseVersion,
      'kDatabaseVersion must match the last migration version',
    );
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'trama_campus.db');

    return openDatabase(
      path,
      version: kDatabaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    for (final migration in kMigrations) {
      for (final sql in migration.up) {
        batch.execute(sql);
      }
    }
    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    for (final migration in kMigrations) {
      if (migration.version > oldVersion && migration.version <= newVersion) {
        for (final sql in migration.up) {
          batch.execute(sql);
        }
      }
    }
    await batch.commit(noResult: true);
  }

  /// Closes the database. Useful for testing.
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
