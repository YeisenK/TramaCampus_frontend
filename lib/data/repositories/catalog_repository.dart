import 'dart:convert';

import 'package:flutter/services.dart';

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
  static final BundledCatalogRepository instance =
      BundledCatalogRepository._();

  final _cache = <String, Catalog>{};

  // Derived catalogs (generated from backend).
  static const _derivedCatalogs = {
    'skill', 'hobby', 'research_interest', 'sport', 'music_genre',
    'personality_trait', 'goal', 'campus', 'academic',
  };

  // Frontend-authored catalogs.
  static const _frontendCatalogs = {
    'diet', 'modality', 'available_days', 'language',
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

    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    // Academic catalog uses {areas, items[area]} instead of {sets, items[sets]}.
    final catalog = catalogName == 'academic'
        ? _parseAcademicCatalog(json)
        : Catalog.fromJson(json);
    _cache[catalogName] = catalog;
    return catalog;
  }

  // Normalizes academic catalog's area-based grouping into standard sets/items.
  // Item IDs (program codes like BADM) are preserved verbatim — the backend
  // stores them as career_id and expects the original uppercase codes.
  static Catalog _parseAcademicCatalog(Map<String, dynamic> json) {
    final sets = (json['areas'] as List<dynamic>)
        .map((a) => CatalogSet(
              id: (a['id'] as String).toLowerCase(),
              label: a['label'] as String,
            ))
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

  RelevanceData? _relevanceCache;

  Future<RelevanceData> loadRelevance() async {
    if (_relevanceCache != null) return _relevanceCache!;
    try {
      final raw = await rootBundle
          .loadString('assets/catalogs/_derived/relevance.json');
      _relevanceCache = RelevanceData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      _relevanceCache = RelevanceData.empty();
    }
    return _relevanceCache!;
  }

  void clearCache() {
    _cache.clear();
    _relevanceCache = null;
  }
}
