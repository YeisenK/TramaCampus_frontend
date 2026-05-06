import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

/// 4×36 px modal grab bar prepended to all bottom sheets.
class TGrabBar extends StatelessWidget {
  const TGrabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(
          top: AppSpacing.space3,
          bottom: AppSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );
  }
}
