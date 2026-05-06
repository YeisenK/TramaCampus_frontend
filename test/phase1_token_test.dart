import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trama_campus_frontend/core/theme/app_colors.dart';

void main() {
  group('Phase 1 — Brand color tokens', () {
    test('light primary is refined coral #D94E2F', () {
      expect(AppColors.lightPrimary, const Color(0xFFD94E2F));
      expect(AppColors.primary, const Color(0xFFD94E2F));
    });

    test('light primaryContainer is #E87358', () {
      expect(AppColors.lightPrimaryContainer, const Color(0xFFE87358));
    });

    test('light primaryFixedDim is pressed coral #C04020', () {
      expect(AppColors.lightPrimaryFixedDim, const Color(0xFFC04020));
    });

    test('CTA gradient uses correct coral endpoints (light)', () {
      expect(AppColors.ctaGradientStart, const Color(0xFFD94E2F));
      expect(AppColors.ctaGradientEnd, const Color(0xFFE87358));
    });

    test('dark primary is #E87358 (lighter in dark mode)', () {
      expect(AppColors.darkPrimary, const Color(0xFFE87358));
      expect(AppColors.primaryDark, const Color(0xFFE87358));
    });

    test('dark primaryContainer is #8C3A2A', () {
      expect(AppColors.darkPrimaryContainer, const Color(0xFF8C3A2A));
    });

    test('dark primaryFixedDim reverts to strong coral #D94E2F', () {
      expect(AppColors.darkPrimaryFixedDim, const Color(0xFFD94E2F));
    });

    test('dark onPrimary is near-black #1F0A05', () {
      expect(AppColors.darkOnPrimary, const Color(0xFF1F0A05));
    });

    test('FAB shadow light uses brand coral tint', () {
      final fabShadow = AppColors.shadowFabLight.first;
      // Color should contain the new primary hue (#D94E2F), not the old (#E85A12)
      expect(fabShadow.color.red, closeTo(0xD9, 2));   // 217
      expect(fabShadow.color.green, closeTo(0x4E, 2)); // 78
      expect(fabShadow.color.blue, closeTo(0x2F, 2));  // 47
    });

    test('FAB shadow dark uses brand coral tint', () {
      final fabShadow = AppColors.shadowFabDark.first;
      expect(fabShadow.color.red, closeTo(0xE8, 2));   // 232
      expect(fabShadow.color.green, closeTo(0x73, 2)); // 115
      expect(fabShadow.color.blue, closeTo(0x58, 2));  // 88
    });

    test('glass blur sigma is 20', () {
      expect(AppColors.glassBlurSigma, 20.0);
    });

    test('glass saturation boost is 1.2', () {
      expect(AppColors.glassSaturationBoost, 1.2);
    });

    test('surface tonal stack unchanged (light)', () {
      expect(AppColors.lightSurface, const Color(0xFFEBEBEC));
      expect(AppColors.lightSurfaceDim, const Color(0xFFDEDEE0));
      expect(AppColors.lightSurfaceContainerLowest, const Color(0xFFF3F3F4));
      expect(AppColors.lightSurfaceContainerLow, const Color(0xFFE8E8EA));
      expect(AppColors.lightSurfaceContainer, const Color(0xFFE2E2E4));
      expect(AppColors.lightSurfaceContainerHigh, const Color(0xFFD9D9DB));
    });

    test('surface tonal stack unchanged (dark)', () {
      expect(AppColors.darkSurface, const Color(0xFF18191B));
      expect(AppColors.darkSurfaceDim, const Color(0xFF131416));
      expect(AppColors.darkSurfaceContainerLowest, const Color(0xFF1E1F22));
      expect(AppColors.darkSurfaceContainerLow, const Color(0xFF222328));
      expect(AppColors.darkSurfaceContainer, const Color(0xFF2A2B2F));
      expect(AppColors.darkSurfaceContainerHigh, const Color(0xFF313237));
    });

    test('no old brand color constants remain in AppColors', () {
      // Old primary was 0xFFE85A12 — ensure it is gone from all exported constants
      const oldLight = Color(0xFFE85A12);
      const oldDark = Color(0xFFFF8A3D);
      const oldDim = Color(0xFFF26B1A);

      expect(AppColors.primary, isNot(oldLight));
      expect(AppColors.lightPrimary, isNot(oldLight));
      expect(AppColors.ctaGradientStart, isNot(oldLight));
      expect(AppColors.darkPrimary, isNot(oldDark));
      expect(AppColors.primaryDark, isNot(oldDark));
      expect(AppColors.lightPrimaryFixedDim, isNot(oldDim));
      expect(AppColors.darkPrimaryFixedDim, isNot(oldDim));
    });
  });
}
