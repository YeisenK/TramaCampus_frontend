import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFFE85A12);
  static const primaryDark = Color(0xFFFF8A3D);
  static const ctaGradientStart = Color(0xFFE85A12);
  static const ctaGradientEnd = Color(0xFFFF8A3D);

  // Light mode
  static const lightPrimary = Color(0xFFE85A12);
  static const lightPrimaryContainer = Color(0xFFFF8A4C);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFF5F6F7);
  static const lightSurfaceDim = Color(0xFFE6E8EA);
  static const lightSurfaceBright = Color(0xFFFAFAFA);
  static const lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const lightSurfaceContainerLow = Color(0xFFEFF1F2);
  static const lightSurfaceContainer = Color(0xFFE6E8EA);
  static const lightSurfaceContainerHigh = Color(0xFFE0E3E4);
  static const lightOnSurface = Color(0xFF2C2F30);
  static const lightOnSurfaceVariant = Color(0xFF595C5D);
  static const lightSecondaryContainer = Color(0xFFD7E4EC);
  static const lightOutlineVariant = Color(0xFFABADAE);

  // Dark mode
  static const darkPrimary = Color(0xFFFF8A3D);
  static const darkPrimaryContainer = Color(0xFF8C3A0A);
  static const darkOnPrimary = Color(0xFF1F0A00);
  static const darkSurface = Color(0xFF111314);
  static const darkSurfaceDim = Color(0xFF0C0E0F);
  static const darkSurfaceBright = Color(0xFF2C3133);
  static const darkSurfaceContainerLowest = Color(0xFF0A0C0D);
  static const darkSurfaceContainerLow = Color(0xFF181B1C);
  static const darkSurfaceContainer = Color(0xFF1E2123);
  static const darkSurfaceContainerHigh = Color(0xFF252A2C);
  static const darkOnSurface = Color(0xFFE2E5E6);
  static const darkOnSurfaceVariant = Color(0xFF9EA3A5);
  static const darkSecondaryContainer = Color(0xFF1A2C38);
  static const darkOutlineVariant = Color(0xFF3A3F41);

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
