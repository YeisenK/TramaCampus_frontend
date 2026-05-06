import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/group.dart';
import '../../../data/repositories/app_state_repository.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key, required this.group, this.onTap});

  final Group group;
  final VoidCallback? onTap;

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
                  if (group.verified) ...[
                    _VerifiedLine(cs: cs),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    group.name,
                    style: AppTextStyles.titleMd(cs.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    group.tagline,
                    style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space2),
            _RightCol(group: group, cs: cs),
          ],
        ),
      ),
    );
  }
}

class _RightCol extends StatelessWidget {
  const _RightCol({required this.group, required this.cs});
  final Group group;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateRepository.instance;
    final isMember = appState.isMember(group.id);
    final isFollowing = appState.isFollowing(group.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isMember)
          _Pill(label: 'Miembro', cs: cs, filled: true)
        else if (isFollowing)
          _Pill(label: 'Siguiendo', cs: cs, filled: false)
        else
          _CtaButton(group: group, cs: cs),
        const SizedBox(height: 4),
        Text(
          '${group.memberCount} miembros',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: cs.onSurfaceVariant.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.cs, required this.filled});
  final String label;
  final ColorScheme cs;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: filled
            ? cs.primaryContainer.withValues(alpha: 0.5)
            : cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: filled ? cs.primary : cs.onSurfaceVariant,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.group, required this.cs});
  final Group group;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final (label, icon) = switch (group.access) {
      GroupAccess.open => ('Seguir', Icons.add),
      GroupAccess.request => ('Solicitar', Icons.how_to_reg_outlined),
      GroupAccess.invite => ('Privado', Icons.lock_outline),
    };
    return GestureDetector(
      onTap: group.access == GroupAccess.invite
          ? null
          : () {
              if (group.access == GroupAccess.open) {
                AppStateRepository.instance.followGroup(group.id);
              } else {
                AppStateRepository.instance.followGroup(group.id);
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(
          color: group.access == GroupAccess.invite
              ? cs.surfaceContainerHigh
              : cs.primary,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 10,
              color: group.access == GroupAccess.invite
                  ? cs.onSurfaceVariant
                  : cs.onPrimary,
            ),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: group.access == GroupAccess.invite
                    ? cs.onSurfaceVariant
                    : cs.onPrimary,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerifiedLine extends StatelessWidget {
  const _VerifiedLine({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 1, color: cs.primary),
        const SizedBox(width: 6),
        Text(
          'OFICIAL',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: cs.primary,
            letterSpacing: 0.6,
          ),
        ),
      ],
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
