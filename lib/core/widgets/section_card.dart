import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Rounded card container used across settings and utility screens.
/// Mirrors the _SettingsSection pattern from settings_main_screen.dart.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.title,
    required this.children,
  });

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.space2, bottom: AppSpacing.space2),
            child: Text(title!, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
          ),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final isLast = entry.key == children.length - 1;
              return Column(
                children: [
                  entry.value,
                  if (!isLast)
                    Divider(
                      indent: 56,
                      height: 0,
                      color: cs.outlineVariant.withValues(alpha: 0.5),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
