import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class PhotoPlaceholder extends StatelessWidget {
  const PhotoPlaceholder({
    super.key,
    required this.initials,
    required this.hue,
    this.borderRadius = AppRadius.lg,
  });

  final String initials;
  final double hue;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.avatarGradient(hue),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.manrope(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: Colors.white.withValues(alpha: 0.9),
          height: 1,
        ),
      ),
    );
  }
}
