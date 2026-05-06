import 'catalog_item.dart';
import 'catalog_set.dart';

class Catalog {
  const Catalog({
    required this.name,
    required this.version,
    this.sets = const [],
    required this.items,
  });

  final String name;
  final String version;
  final List<CatalogSet> sets;
  final List<CatalogItem> items;

  factory Catalog.fromJson(Map<String, dynamic> json) => Catalog(
        name: json['catalog'] as String,
        version: json['version'] as String,
        sets: (json['sets'] as List<dynamic>?)
                ?.map((e) => CatalogSet.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        items: (json['items'] as List<dynamic>)
            .map((e) => CatalogItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  CatalogItem? byId(String id) {
    final lower = id.trim().toLowerCase();
    for (final item in items) {
      if (item.id.toLowerCase() == lower) return item;
    }
    return null;
  }

  Map<CatalogSet, List<CatalogItem>> groupedBySet() {
    final map = <CatalogSet, List<CatalogItem>>{};
    for (final set in sets) {
      map[set] = items.where((i) => i.sets.contains(set.id)).toList();
    }
    // Ungrouped items go into a catch-all entry.
    final grouped = map.values.expand((l) => l).toSet();
    final ungrouped = items.where((i) => !grouped.contains(i)).toList();
    if (ungrouped.isNotEmpty) {
      map[const CatalogSet(id: '__other__', label: 'Otros')] = ungrouped;
    }
    return map;
  }

  List<CatalogItem> search(String query) {
    if (query.trim().isEmpty) return items;
    final q = query.trim().toLowerCase();
    return items
        .where((i) =>
            i.label.toLowerCase().contains(q) || i.id.contains(q))
        .toList();
  }
}
