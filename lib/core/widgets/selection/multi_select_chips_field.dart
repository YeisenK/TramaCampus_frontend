import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../t_chip.dart';
import 'required_field_hint.dart';
import '../../../data/models/catalog/catalog.dart';
import '../../../data/models/catalog/catalog_item.dart';

// Inline multi-select using TChip wraps.
// Supports flat or grouped-by-set display.
// For large catalogs (>40 items) prefer CatalogPickerSheet instead.
class MultiSelectChipsField extends StatelessWidget {
  const MultiSelectChipsField({
    super.key,
    required this.catalog,
    required this.selected,
    required this.onToggle,
    this.min,
    this.max,
    this.grouped = true,
    this.label,
  });

  final Catalog catalog;
  final Set<String> selected;
  final void Function(String id) onToggle;
  final int? min;
  final int? max;
  final bool grouped;
  final String? label;

  bool _canSelect(String id) =>
      selected.contains(id) || max == null || selected.length < max!;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.space2),
        ],
        if (min != null || max != null)
          RequiredFieldHint(current: selected.length, min: min, max: max),
        if (grouped && catalog.sets.isNotEmpty)
          ..._buildGrouped(context)
        else
          _buildFlat(catalog.items),
      ],
    );
  }

  List<Widget> _buildGrouped(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final grouped = catalog.groupedBySet();
    return grouped.entries.map((entry) {
      final set = entry.key;
      final items = entry.value;
      if (items.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.space4,
              bottom: AppSpacing.space2,
            ),
            child: Text(
              set.label,
              style: AppTextStyles.labelSm(cs.onSurfaceVariant),
            ),
          ),
          _buildFlat(items),
        ],
      );
    }).toList();
  }

  Widget _buildFlat(List<CatalogItem> items) => Wrap(
        spacing: AppSpacing.space2,
        runSpacing: AppSpacing.space2,
        children: items
            .map((item) => TChip(
                  label: item.label,
                  selected: selected.contains(item.id),
                  onTap: _canSelect(item.id)
                      ? () => onToggle(item.id)
                      : selected.contains(item.id)
                          ? () => onToggle(item.id)
                          : null,
                ))
            .toList(),
      );
}
