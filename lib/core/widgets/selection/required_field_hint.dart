import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

// Shows a "n/min mínimo · n/max" counter above a selection field.
// Color transitions: error when below min, success when met, muted otherwise.
class RequiredFieldHint extends StatelessWidget {
  const RequiredFieldHint({
    super.key,
    required this.current,
    this.min,
    this.max,
  });

  final int current;
  final int? min;
  final int? max;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final belowMin = min != null && current < min!;
    final color = belowMin
        ? cs.error
        : (min != null && current >= min!)
        ? cs.primary
        : cs.onSurfaceVariant;

    final parts = <String>[];
    if (min != null) parts.add('$current/$min mínimo');
    if (max != null) parts.add('máx. $max');

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space2),
      child: Row(
        children: [
          Icon(
            belowMin ? Icons.info_outline : Icons.check_circle_outline,
            size: 14,
            color: color,
          ),
          const SizedBox(width: AppSpacing.space1),
          Text(parts.join(' · '), style: AppTextStyles.labelSm(color)),
        ],
      ),
    );
  }
}
