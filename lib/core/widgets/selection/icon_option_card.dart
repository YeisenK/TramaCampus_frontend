import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

// Visual selection card for iconCards variant (e.g. diet).
// Shows icon, label, and optional subtitle in a compact card.
class IconOptionCard extends StatelessWidget {
  const IconOptionCard({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.subtitle,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final String? subtitle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = selected
        ? cs.primary.withValues(alpha: 0.12)
        : cs.surfaceContainerHigh;
    final borderColor = selected ? cs.primary : cs.outlineVariant;
    final textColor = selected ? cs.primary : cs.onSurface;
    final iconColor = selected ? cs.primary : cs.onSurfaceVariant;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
          vertical: AppSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(width: AppSpacing.space3),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodyMd(textColor)),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: selected
                  ? Icon(
                      Icons.check_circle,
                      size: 18,
                      color: cs.primary,
                      key: const ValueKey('check'),
                    )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
          ],
        ),
      ),
    );
  }
}
