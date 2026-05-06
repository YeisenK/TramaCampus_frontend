import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// 36×36 glass pill that toggles ThemeMode.
/// Designed to be overlaid at top-right via a [Positioned] widget.
/// Requires a [ThemeModeNotifier] ancestor; or wire [onToggle] manually.
class TThemeToggle extends StatelessWidget {
  const TThemeToggle({super.key, required this.isDark, required this.onToggle});

  final bool isDark;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final glassBg = isDark ? AppColors.darkGlassBg : AppColors.lightGlassBg;
    final iconColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;

    return GestureDetector(
      onTap: onToggle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppColors.glassBlurSigma,
            sigmaY: AppColors.glassBlurSigma,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: glassBg,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                size: 18,
                color: iconColor,
                key: ValueKey(isDark),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
