import 'package:flutter/material.dart';
import 'safe_svg.dart';

enum TramaMarkVariant {
  /// Icon-only hexagon mark (default — all non-splash placements).
  markOnly,

  /// Horizontal icon + wordmark lockup.
  lockup,
}

class TramaMark extends StatelessWidget {
  const TramaMark({
    super.key,
    this.size = 48,
    this.variant = TramaMarkVariant.markOnly,
  });

  final double size;
  final TramaMarkVariant variant;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case TramaMarkVariant.markOnly:
        // SVG is 200×220 — maintain aspect ratio off the given size.
        final height = size * (220 / 200);
        return SafeSvg(
          assetName: 'assets/svg/trama-mark.svg',
          width: size,
          height: height,
        );
      case TramaMarkVariant.lockup:
        // SVG is 200×48 — scale height off the given size.
        final height = size * (48 / 200);
        return SafeSvg(
          assetName: 'assets/svg/logo.svg',
          width: size,
          height: height,
        );
    }
  }
}
