import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_service.dart';
import '../database/schema.dart';

class PreferencesService {
  PreferencesService._();
  static final PreferencesService instance = PreferencesService._();

  static const String _keyThemeMode = 'theme_mode';

  Future<ThemeMode> getThemeMode() async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query(
      Tables.meta,
      where: '${MetaColumns.key} = ?',
      whereArgs: [_keyThemeMode],
      limit: 1,
    );
    if (rows.isEmpty) return ThemeMode.system;
    return _themeModeFromString(rows.first[MetaColumns.value] as String);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final db = await DatabaseService.instance.database;
    await db.insert(
      Tables.meta,
      {MetaColumns.key: _keyThemeMode, MetaColumns.value: mode.name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ThemeMode _themeModeFromString(String value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
