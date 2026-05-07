import '../../../core/constants/app_info.dart';
import '../../../core/database/database_service.dart';

class ConsentRecord {
  const ConsentRecord({
    required this.docsVersion,
    required this.acceptedPrimary,
    required this.acceptedSecondary,
    required this.acceptedAge,
    required this.timestamp,
  });

  final String docsVersion;
  final bool acceptedPrimary;
  final bool acceptedSecondary;
  final bool acceptedAge;
  final DateTime timestamp;

  Map<String, dynamic> toMap() => {
        'docs_version': docsVersion,
        'accepted_primary': acceptedPrimary ? 1 : 0,
        'accepted_secondary': acceptedSecondary ? 1 : 0,
        'accepted_age': acceptedAge ? 1 : 0,
        'timestamp': timestamp.toIso8601String(),
      };
}

class ConsentRepository {
  ConsentRepository._();
  static final instance = ConsentRepository._();

  Future<bool> hasValidConsent() async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query(
      'consent_records',
      where: 'docs_version = ?',
      whereArgs: [AppInfo.legalDocsVersion],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<void> saveConsent(ConsentRecord record) async {
    final db = await DatabaseService.instance.database;
    await db.insert('consent_records', record.toMap());
  }
}
