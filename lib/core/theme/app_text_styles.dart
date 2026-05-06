import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  // Cached base styles — only color varies per call, so we compute once and copyWith.
  static final _display = GoogleFonts.manrope(
    fontSize: 44,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02 * 44,
    height: 1.1,
  );
  static final _headlineLg = GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.015 * 32,
    height: 1.2,
  );
  static final _headlineMd = GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01 * 28,
    height: 1.25,
  );
  static final _headlineSm = GoogleFonts.manrope(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.005 * 22,
    height: 1.3,
  );
  static final _titleMd = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
  );
  static final _bodyLg = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );
  static final _bodyMd = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  static final _bodySm = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );
  static final _labelSm = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    height: 1.3,
  );

  static TextStyle display(Color color) => _display.copyWith(color: color);
  static TextStyle headlineLg(Color color) =>
      _headlineLg.copyWith(color: color);
  static TextStyle headlineMd(Color color) =>
      _headlineMd.copyWith(color: color);
  static TextStyle headlineSm(Color color) =>
      _headlineSm.copyWith(color: color);
  static TextStyle titleMd(Color color) => _titleMd.copyWith(color: color);
  static TextStyle bodyLg(Color color) => _bodyLg.copyWith(color: color);
  static TextStyle bodyMd(Color color) => _bodyMd.copyWith(color: color);
  static TextStyle bodySm(Color color) => _bodySm.copyWith(color: color);
  static TextStyle labelSm(Color color) => _labelSm.copyWith(color: color);
}
