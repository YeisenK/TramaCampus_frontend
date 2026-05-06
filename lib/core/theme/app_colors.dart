import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFFD94E2F);
  static const primaryDark = Color(0xFFE87358);
  static const ctaGradientStart = Color(0xFFD94E2F);
  static const ctaGradientEnd = Color(0xFFE87358);

  // Light mode
  static const lightPrimary = Color(0xFFD94E2F);
  static const lightPrimaryContainer = Color(0xFFE87358);
  static const lightPrimaryFixedDim = Color(0xFFC04020);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFEBEBEC);
  static const lightSurfaceDim = Color(0xFFDEDEE0);
  static const lightSurfaceBright = Color(0xFFEFEFF0);
  static const lightSurfaceContainerLowest = Color(0xFFF3F3F4);
  static const lightSurfaceContainerLow = Color(0xFFE8E8EA);
  static const lightSurfaceContainer = Color(0xFFE2E2E4);
  static const lightSurfaceContainerHigh = Color(0xFFD9D9DB);
  static const lightOnSurface = Color(0xFF2A2B2D);
  static const lightOnSurfaceVariant = Color(0xFF65666A);
  static const lightSecondaryContainer = Color(0xFFD5D5D8);
  static const lightOutlineVariant = Color(0xFFA8A9AC);
  static const lightOutlineGhost = Color(0x1F505258); // rgba(80,82,88,0.12)
  static const lightGlassBg = Color(0xB8EBEBEC); // rgba(235,235,236,0.72)

  // Dark mode
  static const darkPrimary = Color(0xFFE87358);
  static const darkPrimaryContainer = Color(0xFF8C3A2A);
  static const darkPrimaryFixedDim = Color(0xFFD94E2F);
  static const darkOnPrimary = Color(0xFF1F0A05);
  static const darkSurface = Color(0xFF18191B);
  static const darkSurfaceDim = Color(0xFF131416);
  static const darkSurfaceBright = Color(0xFF3A3B40);
  static const darkSurfaceContainerLowest = Color(0xFF1E1F22);
  static const darkSurfaceContainerLow = Color(0xFF222328);
  static const darkSurfaceContainer = Color(0xFF2A2B2F);
  static const darkSurfaceContainerHigh = Color(0xFF313237);
  static const darkOnSurface = Color(0xFFE6E6E8);
  static const darkOnSurfaceVariant = Color(0xFF9D9EA3);
  static const darkSecondaryContainer = Color(0xFF2A2B2F);
  static const darkOutlineVariant = Color(0xFF4A4B50);
  static const darkOutlineGhost = Color(0x1AB4B6BC); // rgba(180,182,188,0.10)
  static const darkGlassBg = Color(0xAD18191B); // rgba(24,25,27,0.68)

  // Shadows — ambient (modals/FABs)
  static const List<BoxShadow> shadowAmbientLight = [
    BoxShadow(
      color: Color(0x1214161C), // rgba(20,22,28,0.07)
      blurRadius: 48,
      offset: Offset(0, 24),
    ),
    BoxShadow(
      color: Color(0x0A14161C), // rgba(20,22,28,0.04)
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0A14161C), // rgba(20,22,28,0.04)
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowAmbientDark = [
    BoxShadow(
      color: Color(0x80000000), // rgba(0,0,0,0.50)
      blurRadius: 56,
      offset: Offset(0, 24),
    ),
    BoxShadow(
      color: Color(0x52000000), // rgba(0,0,0,0.32)
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x66000000), // rgba(0,0,0,0.40)
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowFabLight = [
    BoxShadow(
      color: Color(0x3DD94E2F), // rgba(217,78,47,0.24)
      blurRadius: 36,
      offset: Offset(0, 14),
    ),
    BoxShadow(
      color: Color(0x0F14161C), // rgba(20,22,28,0.06)
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowFabDark = [
    BoxShadow(
      color: Color(0x47E87358), // rgba(232,115,88,0.28)
      blurRadius: 36,
      offset: Offset(0, 14),
    ),
    BoxShadow(
      color: Color(0x66000000), // rgba(0,0,0,0.40)
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static LinearGradient ctaGradient({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [ctaGradientStart, ctaGradientEnd],
    );
  }

  static LinearGradient ctaGradientDark({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [darkPrimary, darkPrimaryFixedDim],
    );
  }

  // Glass surface blur sigma — 12 gives visually equivalent glass at ~64% raster cost vs 20
  static const double glassBlurSigma = 12.0;
  // Saturation boost for glass overlays (saturate(1.2) per reference)
  static const double glassSaturationBoost = 1.2;

  static Color gradientFromHue(double hue, {bool isStart = true}) {
    if (isStart) {
      return HSLColor.fromAHSL(1.0, hue, 0.45, 0.72).toColor();
    } else {
      return HSLColor.fromAHSL(1.0, (hue + 30) % 360, 0.55, 0.42).toColor();
    }
  }

  static LinearGradient avatarGradient(double hue) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        gradientFromHue(hue, isStart: true),
        gradientFromHue(hue, isStart: false),
      ],
    );
  }
}
