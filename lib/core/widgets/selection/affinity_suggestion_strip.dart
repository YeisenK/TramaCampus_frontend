import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../../data/models/catalog/catalog_item.dart';

class AffinitySuggestionStrip extends StatelessWidget {
  const AffinitySuggestionStrip({
    super.key,
    required this.suggestions,
    required this.onSelect,
  });

  final List<CatalogItem> suggestions;
  final void Function(String id) onSelect;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tal vez también te interese:',
            style: AppTextStyles.labelSm(cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.space2),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: suggestions.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.space2),
                  child: GestureDetector(
                    onTap: () => onSelect(item.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space3,
                        vertical: AppSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: cs.primary.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 12, color: cs.primary),
                          const SizedBox(width: 4),
                          Text(item.label, style: AppTextStyles.labelSm(cs.primary)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
