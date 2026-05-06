import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/constants/active_campuses.dart';
import '../models/catalog/campus_info.dart';
import '../models/catalog/catalog.dart';
import '../models/catalog/catalog_item.dart';
import '../models/catalog/catalog_set.dart';
import '../models/catalog/relevance_data.dart';

// Abstract interface — v1: BundledCatalogRepository (reads from rootBundle).
// v2: swap in RemoteCatalogRepository with GET /v1/catalogs/{name}?version=…
abstract class CatalogRepository {
  Future<Catalog> load(String catalogName);
}

// In-memory memoized loader. Reads slimmed JSON from assets/catalogs/.
class BundledCatalogRepository implements CatalogRepository {
  BundledCatalogRepository._();
  static final BundledCatalogRepository instance = BundledCatalogRepository._();

  final _cache = <String, Catalog>{};

  // Derived catalogs (generated from backend).
  static const _derivedCatalogs = {
    'skill',
    'hobby',
    'research_interest',
    'sport',
    'music_genre',
    'personality_trait',
    'goal',
    'campus',
    'academic',
  };

  // Frontend-authored catalogs.
  static const _frontendCatalogs = {
    'diet',
    'modality',
    'available_days',
    'language',
    'affiliation_type',
    'gender',
  };

  @override
  Future<Catalog> load(String catalogName) async {
    if (_cache.containsKey(catalogName)) return _cache[catalogName]!;

    final String assetPath;
    if (_derivedCatalogs.contains(catalogName)) {
      assetPath = 'assets/catalogs/_derived/$catalogName.json';
    } else if (_frontendCatalogs.contains(catalogName)) {
      assetPath = 'assets/catalogs/_frontend/$catalogName.json';
    } else {
      throw ArgumentError('Unknown catalog: $catalogName');
    }

    final Catalog catalog;
    if (catalogName == 'academic') {
      final rawJson = await _loadAcademicRaw();
      catalog = _parseAcademicCatalog(rawJson);
    } else {
      final raw = await rootBundle.loadString(assetPath);
      final json = jsonDecode(raw) as Map<String, dynamic>;
      catalog = Catalog.fromJson(json);
    }
    _cache[catalogName] = catalog;
    return catalog;
  }

  // ── Academic catalog helpers ──────────────────────────────────────────────

  Map<String, dynamic>? _academicRaw;

  Future<Map<String, dynamic>> _loadAcademicRaw() async {
    if (_academicRaw != null) return _academicRaw!;
    final raw = await rootBundle.loadString(
      'assets/catalogs/_derived/academic.json',
    );
    _academicRaw = jsonDecode(raw) as Map<String, dynamic>;
    return _academicRaw!;
  }

  // Normalizes academic catalog's area-based grouping into standard sets/items.
  // Item IDs (program codes like BADM) are preserved verbatim — the backend
  // stores them as career_id and expects the original uppercase codes.
  static Catalog _parseAcademicCatalog(Map<String, dynamic> json) {
    final sets = (json['areas'] as List<dynamic>)
        .map(
          (a) => CatalogSet(
            id: (a['id'] as String).toLowerCase(),
            label: a['label'] as String,
          ),
        )
        .toList();

    final items = (json['items'] as List<dynamic>).map((raw) {
      final areaId = ((raw['area'] as String?) ?? '').toLowerCase();
      return CatalogItem(
        id: raw['id'] as String,
        label: raw['label'] as String,
        sets: areaId.isNotEmpty ? [areaId] : const [],
      );
    }).toList();

    return Catalog(
      name: json['catalog'] as String,
      version: json['version'] as String,
      sets: sets,
      items: items,
    );
  }

  /// Returns CatalogItems for programs offered at [campusId], filtered to
  /// undergraduate only (B* / I* prefix). Uses the `campuses` array in
  /// academic.json which holds per-campus program IDs.
  Future<List<CatalogItem>> programsForCampus(String campusId) async {
    final raw = await _loadAcademicRaw();
    final campuses = raw['campuses'] as List<dynamic>;
    final entry =
        campuses.firstWhere(
              (c) => (c as Map<String, dynamic>)['id'] == campusId,
              orElse: () => null,
            )
            as Map<String, dynamic>?;
    if (entry == null) return const [];

    final allowedIds = (entry['programs'] as List<dynamic>)
        .cast<String>()
        .where(isUndergradProgramId)
        .toSet();

    final catalog = await load('academic');
    return catalog.items.where((i) => allowedIds.contains(i.id)).toList();
  }

  // ── Campus helpers ────────────────────────────────────────────────────────

  Map<String, CampusInfo>? _campusInfoCache;

  Future<Map<String, CampusInfo>> _loadCampusInfoCache() async {
    if (_campusInfoCache != null) return _campusInfoCache!;
    final raw = await rootBundle.loadString(
      'assets/catalogs/_derived/campus.json',
    );
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final items = (json['items'] as List<dynamic>)
        .map((e) => CampusInfo.fromJson(e as Map<String, dynamic>))
        .toList();
    _campusInfoCache = {for (final c in items) c.id: c};
    return _campusInfoCache!;
  }

  /// Returns the 6 active Anáhuac campuses, in JSON order.
  Future<List<CampusInfo>> activeCampuses() async {
    final all = await _loadCampusInfoCache();
    return all.values.where((c) => kActiveCampusIds.contains(c.id)).toList();
  }

  /// Looks up a single campus by code (e.g. "UAMN"). Returns null if unknown.
  Future<CampusInfo?> campusInfo(String campusId) async {
    final all = await _loadCampusInfoCache();
    return all[campusId];
  }

  // ── Relevance ─────────────────────────────────────────────────────────────

  RelevanceData? _relevanceCache;

  Future<RelevanceData> loadRelevance() async {
    if (_relevanceCache != null) return _relevanceCache!;
    try {
      final raw = await rootBundle.loadString(
        'assets/catalogs/_derived/relevance.json',
      );
      _relevanceCache = RelevanceData.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      _relevanceCache = RelevanceData.empty();
    }
    return _relevanceCache!;
  }

  void clearCache() {
    _cache.clear();
    _relevanceCache = null;
    _academicRaw = null;
    _campusInfoCache = null;
  }
}
