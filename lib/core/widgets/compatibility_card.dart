import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 't_chip.dart';

class CompatibilityRow {
  const CompatibilityRow({
    required this.icon,
    required this.label,
    required this.title,
    this.detail,
    this.chips,
    this.isStrong = false,
  });

  final IconData icon;
  final String label;
  final String title;
  final String? detail;
  final List<String>? chips;
  final bool isStrong;
}

class CompatibilityCard extends StatelessWidget {
  const CompatibilityCard({
    super.key,
    required this.score,
    required this.rows,
  });

  final int score;
  final List<CompatibilityRow> rows;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: cs.onSurface.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Compatibilidad', style: AppTextStyles.titleMd(cs.onSurface)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space3, vertical: AppSpacing.space1),
                decoration: BoxDecoration(
                  gradient: AppColors.ctaGradient(),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '$score%',
                  style: AppTextStyles.titleMd(Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space4),
          ...rows.map((row) => _CompatibilityRowWidget(row: row)),
        ],
      ),
    );
  }
}

class _CompatibilityRowWidget extends StatelessWidget {
  const _CompatibilityRowWidget({required this.row});

  final CompatibilityRow row;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: row.isStrong ? AppColors.ctaGradient() : null,
              color: row.isStrong ? null : cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            alignment: Alignment.center,
            child: Icon(
              row.icon,
              size: 18,
              color: row.isStrong ? Colors.white : cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.label, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text(row.title, style: AppTextStyles.titleMd(cs.onSurface)),
                if (row.detail != null) ...[
                  const SizedBox(height: 2),
                  Text(row.detail!, style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
                ],
                if (row.chips != null && row.chips!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.space2),
                  Wrap(
                    spacing: AppSpacing.space2,
                    runSpacing: AppSpacing.space2,
                    children: row.chips!.map((c) => TChip(label: c, selected: true)).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
