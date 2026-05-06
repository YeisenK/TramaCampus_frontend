import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

// Visual personality trait card for traitCards variant.
// Displays an icon + label + optional microcopy with a selected-state highlight.
class TraitCard extends StatelessWidget {
  const TraitCard({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.microcopy,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final String? microcopy;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = selected
        ? cs.primary.withValues(alpha: 0.12)
        : cs.surfaceContainerHigh;
    final borderColor = selected ? cs.primary : Colors.transparent;
    final textColor = selected ? cs.primary : cs.onSurface;
    final iconColor = selected ? cs.primary : cs.onSurfaceVariant;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) Icon(icon, size: 22, color: iconColor),
            const SizedBox(height: AppSpacing.space2),
            Text(
              label,
              style: AppTextStyles.titleMd(textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (microcopy != null) ...[
              const SizedBox(height: 2),
              Text(
                microcopy!,
                style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
