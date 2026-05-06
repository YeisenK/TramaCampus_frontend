import '../models/catalog/catalog_item.dart';
import '../models/catalog/catalog_set.dart';
import '../models/catalog/relevance_data.dart';
import '../models/modality_bucket.dart';

enum RankReason {
  major,
  popularSimilar,
  campusTrend,
  goalCompat,
  modalityCompat,
  neutral,
}

class RankedItem<T> {
  const RankedItem({
    required this.item,
    required this.score,
    required this.reason,
  });
  final T item;
  final double score;
  final RankReason reason;
}

class RankedCatalogSet {
  const RankedCatalogSet({required this.set, required this.score});
  final CatalogSet set;
  final double score;

  String get id => set.id;
  String get label => set.label;
}

class SelectionBuckets {
  const SelectionBuckets({
    required this.recommended,
    required this.popularInMajor,
    required this.popularOnCampus,
    required this.exploreMore,
    required this.otherAreas,
  });
  final List<RankedItem<CatalogItem>> recommended;
  final List<RankedItem<CatalogItem>> popularInMajor;
  final List<RankedItem<CatalogItem>> popularOnCampus;
  final List<RankedItem<CatalogItem>> exploreMore;
  final List<RankedItem<CatalogItem>> otherAreas;

  bool get isEmpty =>
      recommended.isEmpty &&
      popularInMajor.isEmpty &&
      popularOnCampus.isEmpty &&
      exploreMore.isEmpty &&
      otherAreas.isEmpty;
}

class SelectionContext {
  const SelectionContext({
    this.academicAreaId,
    this.campusId,
    this.buckets = const [],
    this.currentSelections = const {},
  });
  final String? academicAreaId;
  final String? campusId;
  final List<ModalityBucketId> buckets;
  // domain → selected item IDs (used for goal compat scoring)
  final Map<String, Set<String>> currentSelections;
}

abstract final class SelectionRelevanceEngine {
  static List<RankedItem<CatalogItem>> rankItems({
    required String catalogName,
    required List<CatalogItem> items,
    required SelectionContext context,
    required RelevanceData relevance,
  }) {
    final areaId = context.academicAreaId;
    final campusId = context.campusId;
    final goalIds = context.currentSelections['goal'] ?? {};

    // Build reverse co-occurrence: items referenced by selected goals → compat hit
    final goalCompatIds = <String>{};
    if (goalIds.isNotEmpty) {
      final goalOcc = relevance.coOccurrence['goal'] ?? {};
      for (final g in goalIds) {
        goalCompatIds.addAll(goalOcc[g] ?? []);
      }
    }

    // Modality affinity item set for this domain
    final modalityIds = <String>{};
    for (final bucket in context.buckets) {
      final bMap = relevance.modalityAffinity[bucket.name] ?? {};
      modalityIds.addAll((bMap[catalogName] ?? []).cast<String>());
    }

    final campusDomainMap = campusId != null
        ? (relevance.campusTrends[campusId]?[catalogName] ?? <String, double>{})
        : <String, double>{};
    final popularityMap = relevance.popularity[catalogName] ?? {};

    final ranked = items.map((item) {
      var score = 0.0;
      var reason = RankReason.neutral;

      // 1. Major area match (weight 1.0)
      if (areaId != null) {
        final areaScore = relevance.areaMatchScoreFor(item.sets, areaId);
        if (areaScore > 0) {
          score += areaScore;
          reason = RankReason.major;
        }
      }

      // 2. Popularity among similar students (weight 0.3, neutral 0.5 when missing)
      final pop = popularityMap[item.id] ?? 0.5;
      score += pop * 0.3;
      if (reason == RankReason.neutral && pop > 0.7) {
        reason = RankReason.popularSimilar;
      }

      // 3. Campus trend (weight 0.2)
      final campusTrend = campusDomainMap[item.id] ?? 0.0;
      if (campusTrend > 0) {
        score += campusTrend * 0.2;
        if (reason == RankReason.neutral) reason = RankReason.campusTrend;
      }

      // 4. Goal compat (weight 0.2)
      if (goalCompatIds.contains(item.id)) {
        score += 0.2;
        if (reason == RankReason.neutral) reason = RankReason.goalCompat;
      }

      // 5. Modality compat (weight 0.2)
      if (modalityIds.contains(item.id)) {
        score += 0.2;
        if (reason == RankReason.neutral) reason = RankReason.modalityCompat;
      }

      return RankedItem(item: item, score: score, reason: reason);
    }).toList();

    ranked.sort((a, b) {
      final cmp = b.score.compareTo(a.score);
      if (cmp != 0) return cmp;
      return a.item.label.compareTo(b.item.label);
    });

    return ranked;
  }

  static SelectionBuckets bucketize(
    List<RankedItem<CatalogItem>> ranked,
    SelectionContext ctx,
  ) {
    final recommended = <RankedItem<CatalogItem>>[];
    final popularInMajor = <RankedItem<CatalogItem>>[];
    final popularOnCampus = <RankedItem<CatalogItem>>[];
    final exploreMore = <RankedItem<CatalogItem>>[];
    final otherAreas = <RankedItem<CatalogItem>>[];

    for (final ri in ranked) {
      if (ri.score >= 0.6) {
        recommended.add(ri);
      } else if (ri.reason == RankReason.popularSimilar && ri.score >= 0.3) {
        popularInMajor.add(ri);
      } else if (ri.reason == RankReason.campusTrend && ri.score >= 0.3) {
        popularOnCampus.add(ri);
      } else if (ri.score > 0.15) {
        exploreMore.add(ri);
      } else {
        otherAreas.add(ri);
      }
    }

    return SelectionBuckets(
      recommended: recommended,
      popularInMajor: popularInMajor,
      popularOnCampus: popularOnCampus,
      exploreMore: exploreMore,
      otherAreas: otherAreas,
    );
  }

  static List<RankedCatalogSet> rankSets({
    required List<CatalogSet> sets,
    required SelectionContext context,
    required RelevanceData relevance,
  }) {
    final areaId = context.academicAreaId;
    final ranked = sets.map((set) {
      double score = 0;
      if (areaId != null) {
        final meta = relevance.setToAreas[set.id];
        if (meta != null && meta.academic.contains(areaId)) {
          score = meta.weight;
        }
      }
      return RankedCatalogSet(set: set, score: score);
    }).toList();

    ranked.sort((a, b) {
      final cmp = b.score.compareTo(a.score);
      if (cmp != 0) return cmp;
      return a.set.label.compareTo(b.set.label);
    });
    return ranked;
  }

  static List<CatalogItem> suggestFromSeed({
    required String catalogName,
    required String seedItemId,
    required List<CatalogItem> items,
    required Set<String> alreadySelected,
    required RelevanceData relevance,
    int limit = 5,
  }) {
    final seeds = relevance.coOccurrence[catalogName] ?? {};
    final suggIds = seeds[seedItemId] ?? [];
    if (suggIds.isEmpty) return [];

    final itemMap = {for (final i in items) i.id: i};
    final result = <CatalogItem>[];
    for (final id in suggIds) {
      if (alreadySelected.contains(id)) continue;
      final item = itemMap[id];
      if (item != null) result.add(item);
      if (result.length >= limit) break;
    }
    return result;
  }
}
