import 'package:sqflite/sqflite.dart';

import '../models/profile/profile_draft.dart';
import '../../core/database/database_service.dart';
import '../../core/database/schema.dart';

// Persists onboarding progress across app backgrounding / kills.
// After each step, call save(draft). On resume, call load() to restore.
class OnboardingDraftRepository {
  OnboardingDraftRepository._();
  static final OnboardingDraftRepository instance =
      OnboardingDraftRepository._();

  ProfileDraft? _draft;

  Future<ProfileDraft> load() async {
    if (_draft != null) return _draft!;
    final db = await DatabaseService.instance.database;
    final rows = await db.query(Tables.profileDraft, limit: 1);
    if (rows.isNotEmpty) {
      _draft = ProfileDraft.fromJsonString(
        rows.first[ProfileDraftColumns.payload] as String,
      );
    } else {
      _draft = ProfileDraft();
    }
    return _draft!;
  }

  Future<void> save(ProfileDraft draft) async {
    _draft = draft;
    final db = await DatabaseService.instance.database;
    await db.insert(Tables.profileDraft, {
      ProfileDraftColumns.id: 1,
      ProfileDraftColumns.step: draft.lastCompletedStep ?? '',
      ProfileDraftColumns.payload: draft.toJsonString(),
      ProfileDraftColumns.updatedAt: DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clear() async {
    _draft = null;
    final db = await DatabaseService.instance.database;
    await db.delete(Tables.profileDraft);
  }

  bool get hasDraft => _draft != null && _draft!.lastCompletedStep != null;
}
