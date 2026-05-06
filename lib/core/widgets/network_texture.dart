import 'package:flutter/material.dart';

/// Paints the subtle dot-and-line network texture used on hero zones.
/// Matches the reference design's CSS `.network-texture` pattern
/// (3 radial dot layers: 48/72/64 px + SVG connecting lines at 4% opacity).
class NetworkTexture extends StatelessWidget {
  const NetworkTexture({super.key, this.opacity = 0.04, this.child});

  final double opacity;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // Apply alpha inside the painter color — avoids Opacity's saveLayer cost.
    final color = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: opacity);
    return Stack(
      fit: StackFit.passthrough,
      children: [
        ?child,
        Positioned.fill(
          child: IgnorePointer(
            // RepaintBoundary isolates texture repaints from parent animations.
            child: RepaintBoundary(
              child: CustomPaint(painter: _NetworkTexturePainter(color: color)),
            ),
          ),
        ),
      ],
    );
  }
}

class _NetworkTexturePainter extends CustomPainter {
  _NetworkTexturePainter({required this.color})
    : _linePaint = Paint()
        ..color = color.withValues(alpha: color.a * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.4,
      _fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

  final Color color;
  final Paint _fillPaint;
  final Paint _linePaint;

  // Triangle path is constant per tile — build once, reuse.
  static final Path _tilePath = Path()
    ..moveTo(24, 36)
    ..lineTo(84, 72)
    ..lineTo(48, 96)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    // Three dot grid layers (48/72/64 px spacing)
    _paintDots(
      canvas,
      size,
      spacingX: 48,
      spacingY: 48,
      anchorX: 0.2,
      anchorY: 0.3,
    );
    _paintDots(
      canvas,
      size,
      spacingX: 72,
      spacingY: 72,
      anchorX: 0.7,
      anchorY: 0.6,
    );
    _paintDots(
      canvas,
      size,
      spacingX: 64,
      spacingY: 64,
      anchorX: 0.4,
      anchorY: 0.8,
    );
    _paintLines(canvas, size);
  }

  void _paintDots(
    Canvas canvas,
    Size size, {
    required double spacingX,
    required double spacingY,
    required double anchorX,
    required double anchorY,
  }) {
    final startX = (anchorX * spacingX) % spacingX;
    final startY = (anchorY * spacingY) % spacingY;
    for (
      double x = startX - spacingX;
      x < size.width + spacingX;
      x += spacingX
    ) {
      for (
        double y = startY - spacingY;
        y < size.height + spacingY;
        y += spacingY
      ) {
        canvas.drawCircle(Offset(x, y), 0.8, _fillPaint);
      }
    }
  }

  void _paintLines(Canvas canvas, Size size) {
    const tileW = 120.0;
    const tileH = 120.0;
    for (double ox = 0; ox < size.width + tileW; ox += tileW) {
      for (double oy = 0; oy < size.height + tileH; oy += tileH) {
        canvas.save();
        canvas.translate(ox - tileW, oy - tileH);
        canvas.drawPath(_tilePath, _linePaint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(_NetworkTexturePainter old) => old.color != color;
}
