import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class LegalCallout extends StatelessWidget {
  const LegalCallout({
    super.key,
    required this.text,
    this.icon,
    this.isPrimary = false,
  });

  final String text;
  final IconData? icon;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = isPrimary
        ? cs.primaryContainer.withValues(alpha: 0.35)
        : cs.surfaceContainerHigh;
    final iconColor = isPrimary ? cs.primary : cs.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isPrimary
              ? cs.primary.withValues(alpha: 0.2)
              : cs.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: AppSpacing.space3),
          ],
          Expanded(
            child: Text(text, style: AppTextStyles.bodyMd(cs.onSurface)),
          ),
        ],
      ),
    );
  }
}
