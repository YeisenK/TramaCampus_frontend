import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/group.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.group,
    this.onTap,
    this.isJoined = false,
  });

  final Group group;
  final VoidCallback? onTap;
  final bool isJoined;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GroupIcon(group: group),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.name,
                          style: AppTextStyles.titleMd(cs.onSurface),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (group.verified) ...[
                        const SizedBox(width: AppSpacing.space1),
                        Icon(Icons.verified, size: 14, color: cs.primary),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    group.tagline,
                    style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  Row(
                    children: [
                      _KindPill(kind: group.kind, cs: cs),
                      const SizedBox(width: AppSpacing.space2),
                      Icon(
                        Icons.people_outline,
                        size: 12,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${group.memberCount}',
                        style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space2),
            Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

class _GroupIcon extends StatelessWidget {
  const _GroupIcon({required this.group});
  final Group group;

  @override
  Widget build(BuildContext context) {
    final isVerified = group.verified;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: isVerified
            ? AppColors.ctaGradient()
            : LinearGradient(
                colors: [
                  HSLColor.fromAHSL(1.0, group.hue, 0.50, 0.60).toColor(),
                  HSLColor.fromAHSL(
                    1.0,
                    (group.hue + 30) % 360,
                    0.60,
                    0.40,
                  ).toColor(),
                ],
              ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      alignment: Alignment.center,
      child: Icon(_kindIcon, color: Colors.white, size: 22),
    );
  }

  IconData get _kindIcon => switch (group.kind) {
    GroupKind.project => Icons.code_outlined,
    GroupKind.study => Icons.menu_book_outlined,
    GroupKind.club => Icons.groups_outlined,
    GroupKind.sport => Icons.sports_outlined,
    GroupKind.official => Icons.campaign_outlined,
  };
}

class _KindPill extends StatelessWidget {
  const _KindPill({required this.kind, required this.cs});
  final GroupKind kind;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        kind.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}
