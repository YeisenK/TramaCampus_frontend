class CatalogSubset {
  const CatalogSubset({required this.id, required this.label});

  final String id;
  final String label;

  factory CatalogSubset.fromJson(Map<String, dynamic> json) => CatalogSubset(
        id: json['id'] as String,
        label: json['label'] as String,
      );
}

class CatalogSet {
  const CatalogSet({
    required this.id,
    required this.label,
    this.subsets = const [],
  });

  final String id;
  final String label;
  final List<CatalogSubset> subsets;

  factory CatalogSet.fromJson(Map<String, dynamic> json) => CatalogSet(
        id: json['id'] as String,
        label: json['label'] as String,
        subsets: (json['subsets'] as List<dynamic>?)
                ?.map((e) => CatalogSubset.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}
