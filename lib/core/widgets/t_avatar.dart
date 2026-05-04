import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class TAvatar extends StatelessWidget {
  const TAvatar({
    super.key,
    required this.initials,
    required this.hue,
    this.size = 48,
    this.borderWidth = 0,
  });

  final String initials;
  final double hue;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final fontSize = size * 0.36;
    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.avatarGradient(hue),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.manrope(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1,
        ),
      ),
    );

    if (borderWidth > 0) {
      avatar = Container(
        padding: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.ctaGradient(),
        ),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(AppSpacing.space1),
          child: avatar,
        ),
      );
    }

    return avatar;
  }
}
