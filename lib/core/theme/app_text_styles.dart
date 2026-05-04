import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle display(Color color) => GoogleFonts.manrope(
    fontSize: 44,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02 * 44,
    color: color,
    height: 1.1,
  );

  static TextStyle headlineLg(Color color) => GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.015 * 32,
    color: color,
    height: 1.2,
  );

  static TextStyle headlineMd(Color color) => GoogleFonts.manrope(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01 * 28,
    color: color,
    height: 1.25,
  );

  static TextStyle headlineSm(Color color) => GoogleFonts.manrope(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.005 * 22,
    color: color,
    height: 1.3,
  );

  static TextStyle titleMd(Color color) => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: color,
    height: 1.4,
  );

  static TextStyle bodyLg(Color color) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: color,
    height: 1.5,
  );

  static TextStyle bodyMd(Color color) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.5,
  );

  static TextStyle bodySm(Color color) => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.45,
  );

  static TextStyle labelSm(Color color) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    color: color,
    height: 1.3,
  );
}
