import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_spacing.dart';

enum TChipSize {
  regular, // 13px Inter 500, 9px padding (default)
  small,   // 11px Inter 500, 6px padding (filter rows)
}

class TChip extends StatelessWidget {
  const TChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.size = TChipSize.regular,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final TChipSize size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bgColor = selected
        ? cs.primary.withValues(alpha: 0.15)
        : cs.surfaceContainerHigh;
    final textColor = selected ? cs.primary : cs.onSurfaceVariant;
    final borderColor = selected ? cs.primary : Colors.transparent;

    final (fontSize, hPad, vPad) = switch (size) {
      TChipSize.regular => (13.0, AppSpacing.space3, 7.0),
      TChipSize.small => (11.0, 6.0, 4.0),
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
            color: textColor,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}
