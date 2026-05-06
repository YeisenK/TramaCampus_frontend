import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

enum DiscoverVariant { feed, grid, stories }

extension DiscoverVariantLabel on DiscoverVariant {
  String get label => switch (this) {
        DiscoverVariant.feed => 'Feed',
        DiscoverVariant.grid => 'Grid',
        DiscoverVariant.stories => 'Stories',
      };

  IconData get icon => switch (this) {
        DiscoverVariant.feed => Icons.view_agenda_outlined,
        DiscoverVariant.grid => Icons.grid_view_outlined,
        DiscoverVariant.stories => Icons.smart_display_outlined,
      };
}

/// Small segmented picker for discover layout variants (feed / grid / stories).
class DiscoverVariantSwitch extends StatelessWidget {
  const DiscoverVariantSwitch({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final DiscoverVariant selected;
  final ValueChanged<DiscoverVariant> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      child: Row(
        children: DiscoverVariant.values.map((v) {
          final isActive = v == selected;
          return GestureDetector(
            onTap: () => onChanged(v),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.only(right: AppSpacing.space2),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space3,
                vertical: AppSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? cs.onSurface
                    : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    v.icon,
                    size: 14,
                    color: isActive ? cs.surface : cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.space1),
                  Text(
                    v.label,
                    style: AppTextStyles.labelSm(
                      isActive ? cs.surface : cs.onSurfaceVariant,
                    ).copyWith(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
