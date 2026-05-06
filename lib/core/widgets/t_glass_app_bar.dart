import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Sticky glass app bar matching the Trama Campus 2 reference.
/// 56px content height, 20px backdrop blur, glass background,
/// 1px inset border using outlineGhost.
class TGlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TGlassAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.showBack = false,
    this.bottom,
  });

  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBack;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassBg =
        isDark ? AppColors.darkGlassBg : AppColors.lightGlassBg;
    final ghostBorder =
        isDark ? AppColors.darkOutlineGhost : AppColors.lightOutlineGhost;

    final leading_ = showBack
        ? _GlassPillButton(
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: cs.onSurface,
            ),
            onTap: () => Navigator.of(context).pop(),
          )
        : leading;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppColors.glassBlurSigma,
          sigmaY: AppColors.glassBlurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: glassBg,
            border: Border(
              bottom: BorderSide(color: ghostBorder, width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: kToolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space4,
                ),
                child: Row(
                  children: [
                    if (leading_ != null) ...[
                      leading_,
                      const SizedBox(width: AppSpacing.space3),
                    ],
                    Expanded(
                      child: titleWidget ??
                          (title != null
                              ? Text(
                                  title!,
                                  style: AppTextStyles.headlineSm(cs.onSurface),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const SizedBox.shrink()),
                    ),
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassPillButton extends StatelessWidget {
  const _GlassPillButton({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
