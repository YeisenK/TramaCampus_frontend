import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class TAvatar extends StatelessWidget {
  const TAvatar({
    super.key,
    required this.initials,
    required this.hue,
    this.photoUrl,
    this.size = 48,
    this.borderWidth = 0,
  });

  final String initials;
  final double hue;
  final String? photoUrl;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    Widget avatar = _buildCircle();

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

  ImageProvider? _imageProvider() {
    if (photoUrl == null) return null;
    if (photoUrl!.startsWith('assets/')) return AssetImage(photoUrl!);
    return NetworkImage(photoUrl!);
  }

  Widget _buildCircle() {
    final provider = _imageProvider();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: provider != null
            ? Image(
                image: provider,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => _gradientCircle(),
              )
            : _gradientCircle(),
      ),
    );
  }

  Widget _gradientCircle() {
    final fontSize = size * 0.36;
    return Container(
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
  }
}
