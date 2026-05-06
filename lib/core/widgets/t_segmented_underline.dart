import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Underline-style tab bar (2px primary border under active tab, ghost divider
/// under inactive). Used in marketplace tabs, group detail, etc.
class TSegmentedUnderline extends StatelessWidget {
  const TSegmentedUnderline({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: List.generate(tabs.length, (i) {
        final isActive = i == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive
                        ? cs.primary
                        : cs.outlineVariant.withValues(alpha: 0.4),
                    width: isActive ? 2.0 : 1.0,
                  ),
                ),
              ),
              child: Text(
                tabs[i],
                textAlign: TextAlign.center,
                style: isActive
                    ? AppTextStyles.titleMd(cs.primary)
                    : AppTextStyles.titleMd(cs.onSurfaceVariant),
              ),
            ),
          ),
        );
      }),
    );
  }
}
