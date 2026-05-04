import 'package:sqflite/sqflite.dart';
import '../../core/database/database_service.dart';
import '../../core/database/schema.dart';
import '../models/local_profile_photo.dart';

abstract class ProfilePhotoRepository {
  Future<List<LocalProfilePhoto>> getForStudent(String studentId);
  Future<LocalProfilePhoto?> getPrimary(String studentId);
  Future<String> insert(LocalProfilePhoto photo);
  Future<void> setPrimary(String studentId, String photoId);
  Future<void> delete(String photoId);
  Future<void> reorder(String studentId, List<String> orderedIds);
}

class LocalProfilePhotoRepository implements ProfilePhotoRepository {
  Future<Database> get _db => DatabaseService.instance.database;

  @override
  Future<List<LocalProfilePhoto>> getForStudent(String studentId) async {
    final db = await _db;
    final rows = await db.query(
      Tables.profilePhotos,
      where: '${ProfilePhotoColumns.studentId} = ?',
      whereArgs: [studentId],
      orderBy: '${ProfilePhotoColumns.position} ASC',
    );
    return rows.map(LocalProfilePhoto.fromMap).toList();
  }

  @override
  Future<LocalProfilePhoto?> getPrimary(String studentId) async {
    final db = await _db;
    final rows = await db.query(
      Tables.profilePhotos,
      where: '${ProfilePhotoColumns.studentId} = ? AND ${ProfilePhotoColumns.isPrimary} = 1',
      whereArgs: [studentId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return LocalProfilePhoto.fromMap(rows.first);
  }

  @override
  Future<String> insert(LocalProfilePhoto photo) async {
    final db = await _db;
    await db.insert(Tables.profilePhotos, photo.toMap());
    return photo.id;
  }

  @override
  Future<void> setPrimary(String studentId, String photoId) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.update(
        Tables.profilePhotos,
        {ProfilePhotoColumns.isPrimary: 0},
        where: '${ProfilePhotoColumns.studentId} = ?',
        whereArgs: [studentId],
      );
      await txn.update(
        Tables.profilePhotos,
        {ProfilePhotoColumns.isPrimary: 1},
        where: '${ProfilePhotoColumns.id} = ?',
        whereArgs: [photoId],
      );
    });
  }

  @override
  Future<void> delete(String photoId) async {
    final db = await _db;
    await db.delete(
      Tables.profilePhotos,
      where: '${ProfilePhotoColumns.id} = ?',
      whereArgs: [photoId],
    );
  }

  @override
  Future<void> reorder(String studentId, List<String> orderedIds) async {
    final db = await _db;
    await db.transaction((txn) async {
      for (int i = 0; i < orderedIds.length; i++) {
        await txn.update(
          Tables.profilePhotos,
          {ProfilePhotoColumns.position: i},
          where: '${ProfilePhotoColumns.id} = ?',
          whereArgs: [orderedIds[i]],
        );
      }
    });
  }
}
