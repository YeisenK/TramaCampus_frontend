import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/recommended_student.dart';

/// Thin client over the demo matching HTTP API. Reads its config from
/// compile-time `--dart-define` flags so we can flip between localhost
/// and the tunneled deployment without code changes.
///
/// Flags:
///   TRAMA_API_BASE          default: http://localhost:8080
///   TRAMA_API_TIMEOUT_MS    default: 10000
class MatchingApiClient {
  MatchingApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = String.fromEnvironment(
    'TRAMA_API_BASE',
    defaultValue: 'http://localhost:8080',
  );

  static const int _timeoutMs = int.fromEnvironment(
    'TRAMA_API_TIMEOUT_MS',
    defaultValue: 10000,
  );

  Duration get _timeout => Duration(milliseconds: _timeoutMs);

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Future<MatchResultsDto> ingestAndMatch(Map<String, dynamic> payload) async {
    final res = await _client
        .post(
          _uri('/v1/match/ingest'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        )
        .timeout(_timeout);
    return _decode(res);
  }

  Future<MatchResultsDto> getMatches(int userId) async {
    final res = await _client.get(_uri('/v1/match/$userId')).timeout(_timeout);
    return _decode(res);
  }

  Future<bool> ping() async {
    try {
      final res = await _client
          .get(_uri('/healthz'))
          .timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  MatchResultsDto _decode(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw MatchingApiException(
        statusCode: res.statusCode,
        body: res.body,
      );
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return MatchResultsDto.fromJson(json);
  }

  void close() => _client.close();
}

class MatchingApiException implements Exception {
  const MatchingApiException({required this.statusCode, required this.body});
  final int statusCode;
  final String body;

  @override
  String toString() => 'MatchingApiException($statusCode): $body';
}
