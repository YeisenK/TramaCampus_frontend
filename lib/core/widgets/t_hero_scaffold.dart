import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Reusable 320–360px hero photo header used by profile and detail screens.
/// Provides: gradient placeholder, gradient scrim overlay, glass back button,
/// and a bottom slot for name/title text.
class THeroScaffold extends StatelessWidget {
  const THeroScaffold({
    super.key,
    this.photoUrl,
    this.gradientColors,
    required this.name,
    this.subtitle,
    this.height = 320,
    this.showBack = true,
    this.trailing,
    required this.body,
  });

  /// Remote or asset URL for the hero photo. If null, uses [gradientColors].
  final String? photoUrl;

  /// Avatar gradient used when [photoUrl] is null.
  final List<Color>? gradientColors;

  final String name;
  final String? subtitle;
  final double height;
  final bool showBack;

  /// Optional trailing widget overlaid at top-right (e.g. TThemeToggle).
  final Widget? trailing;

  /// Scrollable body rendered below the hero.
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HeroHeader(
            photoUrl: photoUrl,
            gradientColors: gradientColors ?? [cs.surfaceContainerHigh, cs.surfaceContainer],
            name: name,
            subtitle: subtitle,
            height: height,
            showBack: showBack,
            trailing: trailing,
          )),
          SliverToBoxAdapter(child: body),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.photoUrl,
    required this.gradientColors,
    required this.name,
    this.subtitle,
    required this.height,
    required this.showBack,
    this.trailing,
  });

  final String? photoUrl;
  final List<Color> gradientColors;
  final String name;
  final String? subtitle;
  final double height;
  final bool showBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Photo or gradient placeholder
          if (photoUrl != null)
            Image.network(photoUrl!, fit: BoxFit.cover)
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
              ),
            ),

          // Bottom scrim: transparent → surface
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: height * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    cs.surface.withValues(alpha: 0.55),
                    cs.surface,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Name / subtitle block at bottom
          Positioned(
            left: AppSpacing.space6,
            right: AppSpacing.space6,
            bottom: AppSpacing.space6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name, style: AppTextStyles.headlineMd(cs.onSurface)),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.space1),
                  Text(subtitle!, style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
                ],
              ],
            ),
          ),

          // Back button top-left
          if (showBack)
            Positioned(
              top: MediaQuery.of(context).padding.top + AppSpacing.space3,
              left: AppSpacing.space4,
              child: _GlassBackButton(),
            ),

          // Trailing top-right
          if (trailing != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + AppSpacing.space3,
              right: AppSpacing.space4,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}

class _GlassBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassBg = isDark ? AppColors.darkGlassBg : AppColors.lightGlassBg;
    final iconColor = isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;

    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppColors.glassBlurSigma / 2,
            sigmaY: AppColors.glassBlurSigma / 2,
          ),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: glassBg,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
