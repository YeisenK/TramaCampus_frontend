import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.space5),
            Text(title, style: AppTextStyles.titleMd(cs.onSurface), textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.space2),
            Text(subtitle, style: AppTextStyles.bodyMd(cs.onSurfaceVariant), textAlign: TextAlign.center),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.space6),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
