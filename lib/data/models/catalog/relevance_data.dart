class SetAreaMeta {
  const SetAreaMeta({required this.academic, required this.weight});
  final List<String> academic;
  final double weight;

  factory SetAreaMeta.fromJson(Map<String, dynamic> j) => SetAreaMeta(
        academic: (j['academic'] as List<dynamic>).cast<String>(),
        weight: (j['weight'] as num).toDouble(),
      );
}

class RelevanceData {
  const RelevanceData({
    required this.setToAreas,
    required this.popularity,
    required this.campusTrends,
    required this.modalityAffinity,
    required this.coOccurrence,
  });

  // set_id → { academic: [area_ids], weight }
  final Map<String, SetAreaMeta> setToAreas;
  // domain → { item_id → 0–1 }
  final Map<String, Map<String, double>> popularity;
  // campus_id → domain → { item_id → 0–1 }
  final Map<String, Map<String, Map<String, double>>> campusTrends;
  // bucket_name → domain → [item_ids]
  final Map<String, Map<String, List<String>>> modalityAffinity;
  // domain → seed_item_id → [suggested_item_ids]
  final Map<String, Map<String, List<String>>> coOccurrence;

  factory RelevanceData.fromJson(Map<String, dynamic> j) {
    Map<String, Map<String, double>> parsePopularity(dynamic raw) {
      final out = <String, Map<String, double>>{};
      (raw as Map<String, dynamic>? ?? {}).forEach((domain, items) {
        final m = <String, double>{};
        (items as Map<String, dynamic>? ?? {}).forEach((id, v) {
          m[id] = (v as num).toDouble();
        });
        out[domain] = m;
      });
      return out;
    }

    final setToAreas = <String, SetAreaMeta>{};
    (j['set_to_areas'] as Map<String, dynamic>? ?? {}).forEach((k, v) {
      setToAreas[k] = SetAreaMeta.fromJson(v as Map<String, dynamic>);
    });

    final campusTrends = <String, Map<String, Map<String, double>>>{};
    (j['campus_trends'] as Map<String, dynamic>? ?? {}).forEach((campus, domains) {
      campusTrends[campus] = parsePopularity(domains);
    });

    final modalityAffinity = <String, Map<String, List<String>>>{};
    (j['modality_affinity'] as Map<String, dynamic>? ?? {}).forEach((bucket, domains) {
      final m = <String, List<String>>{};
      (domains as Map<String, dynamic>? ?? {}).forEach((domain, ids) {
        m[domain] = (ids as List<dynamic>).cast<String>();
      });
      modalityAffinity[bucket] = m;
    });

    final coOccurrence = <String, Map<String, List<String>>>{};
    (j['co_occurrence'] as Map<String, dynamic>? ?? {}).forEach((domain, seeds) {
      final m = <String, List<String>>{};
      (seeds as Map<String, dynamic>? ?? {}).forEach((seed, suggs) {
        m[seed] = (suggs as List<dynamic>).cast<String>();
      });
      coOccurrence[domain] = m;
    });

    return RelevanceData(
      setToAreas: setToAreas,
      popularity: parsePopularity(j['popularity']),
      campusTrends: campusTrends,
      modalityAffinity: modalityAffinity,
      coOccurrence: coOccurrence,
    );
  }

  factory RelevanceData.empty() => const RelevanceData(
        setToAreas: {},
        popularity: {},
        campusTrends: {},
        modalityAffinity: {},
        coOccurrence: {},
      );

  double areaMatchScoreFor(List<String> itemSets, String areaId) {
    var best = 0.0;
    for (final setId in itemSets) {
      final meta = setToAreas[setId];
      if (meta == null) continue;
      if (meta.academic.contains(areaId) && meta.weight > best) {
        best = meta.weight;
      }
    }
    return best;
  }
}
