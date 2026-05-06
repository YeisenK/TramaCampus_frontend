import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../../data/services/selection_relevance_engine.dart';

class RelevanceChip extends StatelessWidget {
  const RelevanceChip({
    super.key,
    required this.label,
    required this.selected,
    this.reason = RankReason.neutral,
    this.onTap,
  });

  final String label;
  final bool selected;
  final RankReason reason;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bgColor = selected
        ? cs.primary.withValues(alpha: 0.15)
        : cs.surfaceContainerHigh;
    final textColor = selected ? cs.primary : cs.onSurfaceVariant;
    final borderColor = selected ? cs.primary : Colors.transparent;

    final badge = _badge(reason);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space3,
          vertical: AppSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null) ...[badge, const SizedBox(width: 4)],
            Text(label, style: AppTextStyles.labelSm(textColor)),
          ],
        ),
      ),
    );
  }

  Widget? _badge(RankReason r) {
    switch (r) {
      case RankReason.major:
        return const Icon(
          Icons.school_outlined,
          size: 12,
          color: Colors.blueAccent,
        );
      case RankReason.campusTrend:
        return const Icon(
          Icons.local_fire_department_outlined,
          size: 12,
          color: Colors.deepOrange,
        );
      default:
        return null;
    }
  }
}
