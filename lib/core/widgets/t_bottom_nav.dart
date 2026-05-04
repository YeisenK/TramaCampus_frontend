import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class TBottomNav extends StatelessWidget {
  const TBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      label: 'Descubrir',
    ),
    _NavItem(
      icon: Icons.group_outlined,
      activeIcon: Icons.group,
      label: 'Match',
    ),
    _NavItem(
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront,
      label: 'Market',
    ),
    _NavItem(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'Chats',
    ),
    _NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Perfil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                children: List.generate(_items.length, (i) {
                  final item = _items[i];
                  final isActive = i == currentIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              isActive ? item.activeIcon : item.icon,
                              key: ValueKey(isActive),
                              size: 24,
                              color: isActive
                                  ? cs.primary
                                  : cs.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.space1),
                          Text(
                            item.label,
                            style: AppTextStyles.labelSm(
                              isActive ? cs.primary : cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
