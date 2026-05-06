import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Paints the subtle dot-and-line network texture used on hero zones.
/// Matches the reference design's CSS `.network-texture` pattern
/// (3 radial dot layers: 48/72/64 px + SVG connecting lines at 4% opacity).
class NetworkTexture extends StatelessWidget {
  const NetworkTexture({
    super.key,
    this.opacity = 0.04,
    this.child,
  });

  final double opacity;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (child != null) child!,
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: opacity,
              child: CustomPaint(
                painter: _NetworkTexturePainter(color: color),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NetworkTexturePainter extends CustomPainter {
  const _NetworkTexturePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4;

    // Three dot grid layers with different spacing (matches 48/72/64 px CSS bg-size)
    _paintDots(canvas, size, paint, spacingX: 48, spacingY: 48, anchorX: 0.2, anchorY: 0.3);
    _paintDots(canvas, size, paint, spacingX: 72, spacingY: 72, anchorX: 0.7, anchorY: 0.6);
    _paintDots(canvas, size, paint, spacingX: 64, spacingY: 64, anchorX: 0.4, anchorY: 0.8);

    // Connecting lines (triangular motif, 120px tile)
    _paintLines(canvas, size, linePaint);
  }

  void _paintDots(
    Canvas canvas,
    Size size,
    Paint paint, {
    required double spacingX,
    required double spacingY,
    required double anchorX,
    required double anchorY,
  }) {
    final startX = (anchorX * spacingX) % spacingX;
    final startY = (anchorY * spacingY) % spacingY;

    for (double x = startX - spacingX; x < size.width + spacingX; x += spacingX) {
      for (double y = startY - spacingY; y < size.height + spacingY; y += spacingY) {
        canvas.drawCircle(Offset(x, y), 0.8, paint);
      }
    }
  }

  void _paintLines(Canvas canvas, Size size, Paint paint) {
    const tileW = 120.0;
    const tileH = 120.0;

    // Triangle vertices within 120×120 tile (normalized from SVG: 24,36 → 84,72 → 48,96)
    const pts = [
      Offset(24, 36),
      Offset(84, 72),
      Offset(48, 96),
    ];

    for (double ox = 0; ox < size.width + tileW; ox += tileW) {
      for (double oy = 0; oy < size.height + tileH; oy += tileH) {
        // Clip to canvas
        canvas.save();
        canvas.translate(ox - tileW, oy - tileH);
        final path = Path()
          ..moveTo(pts[0].dx, pts[0].dy)
          ..lineTo(pts[1].dx, pts[1].dy)
          ..lineTo(pts[2].dx, pts[2].dy)
          ..lineTo(pts[0].dx, pts[0].dy);
        canvas.drawPath(path, paint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(_NetworkTexturePainter old) => old.color != color;
}
