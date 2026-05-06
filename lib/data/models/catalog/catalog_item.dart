class CatalogItem {
  const CatalogItem({
    required this.id,
    required this.label,
    this.sets = const [],
    this.subsets = const [],
    this.extra = const {},
  });

  final String id;
  final String label;
  final List<String> sets;
  final List<String> subsets;
  // Catalog-specific extra fields (e.g. area for academics, city for campus).
  final Map<String, dynamic> extra;

  factory CatalogItem.fromJson(Map<String, dynamic> json) => CatalogItem(
        id: json['id'] as String,
        label: json['label'] as String,
        sets: (json['sets'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        subsets: (json['subsets'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        extra: Map<String, dynamic>.from(json)
          ..remove('id')
          ..remove('label')
          ..remove('sets')
          ..remove('subsets'),
      );
}
