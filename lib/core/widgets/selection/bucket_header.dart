import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

enum BucketType {
  recommended,
  popularInMajor,
  popularOnCampus,
  exploreMore,
  otherAreas,
}

class BucketHeader extends StatelessWidget {
  const BucketHeader({super.key, required this.type, this.areaLabel});

  final BucketType type;
  final String? areaLabel;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (label, microcopy, color) = switch (type) {
      BucketType.recommended => (
        'Recomendado para ti',
        areaLabel != null ? 'Basado en $areaLabel' : 'Basado en tu perfil',
        cs.primary,
      ),
      BucketType.popularInMajor => (
        'Popular en tu carrera',
        areaLabel != null
            ? 'Elegido por estudiantes de $areaLabel'
            : 'Popular entre estudiantes similares',
        cs.tertiary,
      ),
      BucketType.popularOnCampus => (
        'Popular en tu campus',
        'Trending entre tus compañeros',
        cs.secondary,
      ),
      BucketType.exploreMore => (
        'Explorar más',
        'Otras opciones para ti',
        cs.onSurfaceVariant,
      ),
      BucketType.otherAreas => (
        'Otras áreas',
        'Áreas menos relacionadas con tu carrera',
        cs.outline,
      ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.titleMd(color)),
          const SizedBox(height: 2),
          Text(microcopy, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}
