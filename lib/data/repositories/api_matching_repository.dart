import 'dart:async';

import '../models/profile/profile.dart';
import '../models/recommended_student.dart';
import '../services/api/matching_api_client.dart';
import '../services/api/profile_to_student_payload.dart';

/// Repository that talks to the demo matching HTTP API. Caches the last
/// successful result so the Discover feed can render synchronously after
/// the first round-trip; `refresh()` re-ingests when the profile changes.
class ApiMatchingRepository {
  ApiMatchingRepository({MatchingApiClient? client, int? userId})
    : _client = client ?? MatchingApiClient(),
      _userId = userId ?? _demoUserIdFromDefine();

  final MatchingApiClient _client;
  final int _userId;

  MatchResultsDto? _cached;
  int get userId => _userId;
  MatchResultsDto? get cached => _cached;

  static const int _defaultDemoId = 999001;

  static int _demoUserIdFromDefine() {
    const raw = String.fromEnvironment('TRAMA_DEMO_USER_ID');
    if (raw.isEmpty) return _defaultDemoId;
    return int.tryParse(raw) ?? _defaultDemoId;
  }

  /// Re-ingest the profile and pull fresh matches.
  Future<MatchResultsDto> refresh(Profile profile) async {
    final payload = profileToIngestPayload(profile, userId: _userId);
    _cached = await _client.ingestAndMatch(payload);
    return _cached!;
  }

  /// Pull matches without re-ingesting. Use after `refresh` succeeded
  /// at least once.
  Future<MatchResultsDto> fetch() async {
    _cached = await _client.getMatches(_userId);
    return _cached!;
  }

  Future<bool> ping() => _client.ping();
}
