import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class SelectionPreviewBar extends StatelessWidget {
  const SelectionPreviewBar({
    super.key,
    required this.selectedLabels,
    required this.onRemove,
    this.min,
    this.max,
  });

  final Map<String, String> selectedLabels; // id → label
  final void Function(String id) onRemove;
  final int? min;
  final int? max;

  @override
  Widget build(BuildContext context) {
    if (selectedLabels.isEmpty) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    final count = selectedLabels.length;
    final atMin = min != null && count <= min!;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space4,
        AppSpacing.space3,
        AppSpacing.space4,
        AppSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '$count seleccionado${count == 1 ? '' : 's'}',
                style: AppTextStyles.labelSm(cs.onSurfaceVariant),
              ),
              if (max != null) ...[
                Text(
                  ' / $max',
                  style: AppTextStyles.labelSm(cs.outline),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: selectedLabels.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.space2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space2, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                          color: cs.primary.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(e.value, style: AppTextStyles.labelSm(cs.primary)),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: atMin ? null : () => onRemove(e.key),
                          child: Icon(
                            Icons.close,
                            size: 12,
                            color: atMin ? cs.outline : cs.primary,
                          ),
                        ),
                      ],
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
