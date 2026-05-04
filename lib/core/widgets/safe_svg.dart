import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SafeSvg extends StatelessWidget {
  const SafeSvg({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.colorFilter,
  });

  final String assetName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
      colorFilter: colorFilter,
      placeholderBuilder: (_) => SizedBox(width: width, height: height),
    );
  }
}
