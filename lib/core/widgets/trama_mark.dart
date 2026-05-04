import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class TramaMark extends StatelessWidget {
  const TramaMark({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.ctaGradient(),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      alignment: Alignment.center,
      child: Text(
        'TC',
        style: GoogleFonts.manrope(
          fontSize: size * 0.36,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -0.5,
          height: 1,
        ),
      ),
    );
  }
}
