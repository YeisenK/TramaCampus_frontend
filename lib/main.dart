import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'core/database/database_service.dart';
import 'core/services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    await DatabaseService.instance.database;
    themeNotifier.value = await PreferencesService.instance.getThemeMode();
  } catch (e) {
    debugPrint('[DB] init error: $e');
  }

  runApp(const TramaApp());
}
