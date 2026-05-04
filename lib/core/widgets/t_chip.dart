import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class TChip extends StatelessWidget {
  const TChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bgColor = selected ? cs.primary.withValues(alpha: 0.15) : cs.surfaceContainerHigh;
    final textColor = selected ? cs.primary : cs.onSurfaceVariant;
    final borderColor = selected ? cs.primary : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space3,
          vertical: AppSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSm(textColor),
        ),
      ),
    );
  }
}
