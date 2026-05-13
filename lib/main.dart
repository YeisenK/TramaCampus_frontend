import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app.dart';
import 'core/services/preferences_service.dart';
import 'data/repositories/app_state_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/demo_session_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Theme preference — fast prefs read, needed before first frame to avoid flash.
  try {
    themeNotifier.value = await PreferencesService.instance.getThemeMode();
  } catch (e) {
    debugPrint('[Prefs] init error: $e');
  }

  // Limit image cache to 60 MB — enough for feed + marketplace without bloat.
  PaintingBinding.instance.imageCache.maximumSizeBytes = 60 << 20;

  // Auth session — splash uses this to decide first route.
  await AuthRepository.instance.load();

  // Runtime mutable state (profile, follow sets, messages, created groups).
  await AppStateRepository.instance.load();

  // Legacy demo session (email → user_id) kept for the dormant API
  // matching path; safe no-op if no row exists.
  await DemoSessionRepository.instance.load();

  runApp(const TramaApp());

  // Lock orientation after first frame — avoids blocking runApp.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
