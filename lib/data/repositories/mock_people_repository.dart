import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/mock_person.dart';

/// Loads and caches the bundled `assets/data/mock_people.json`. First
/// access is async; subsequent ones are synchronous via [cached].
class MockPeopleRepository {
  MockPeopleRepository._();
  static final MockPeopleRepository instance = MockPeopleRepository._();

  List<MockPerson>? _cached;
  List<MockPerson>? get cached => _cached;

  static const _assetPath = 'assets/data/mock_people.json';

  Future<List<MockPerson>> load() async {
    if (_cached != null) return _cached!;
    final raw = await rootBundle.loadString(_assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = json['people'] as List<dynamic>;
    _cached = list
        .map((e) => MockPerson.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cached!;
  }
}
