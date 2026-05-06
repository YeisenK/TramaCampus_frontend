import '../models/modality_bucket.dart';

// Pure functions — no state. Central authority for 3-bucket → 13-mode expansion.
// Per json-integration.md §2 and plan §7.
abstract final class ModalityResolver {
  // Resolve the final backend modes[] from selected buckets + per-mode overrides.
  // overrides: explicit enable/disable per backend mode id set by the user in
  //   edit-profile "Avanzado" panel. They take precedence over bucket defaults.
  static List<String> expand({
    required List<ModalityBucketId> buckets,
    required List<String> overrides,
  }) {
    if (overrides.isNotEmpty) {
      // Overrides are already the exact backend mode list the user configured.
      return List.unmodifiable(overrides);
    }
    final modes = <String>{};
    for (final bucket in buckets) {
      modes.addAll(kBucketDefaultModes[bucket] ?? []);
    }
    return List.unmodifiable(modes.toList());
  }

  // Derive the ui_modality analytics string from the first selected bucket.
  static String uiModality(List<ModalityBucketId> buckets) {
    if (buckets.isEmpty) return '';
    return buckets.first.name;
  }

  // Determine which bucket a granular backend mode belongs to.
  static ModalityBucketId? bucketOf(String mode) {
    for (final entry in kBucketDefaultModes.entries) {
      if (entry.value.contains(mode)) return entry.key;
    }
    return null;
  }

  // All 13 valid backend mode identifiers.
  static const List<String> allModes = [
    'study', 'research', 'competition',
    'social', 'networking', 'gaming', 'language',
    'creative', 'volunteer', 'wellness', 'lifestyle', 'startup',
    'eros',
  ];

  static bool isValidMode(String mode) => allModes.contains(mode);
}
