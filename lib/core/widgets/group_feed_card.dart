import 'package:flutter/material.dart';
import '../../data/models/group.dart';
import '../../data/repositories/app_state_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class GroupFeedCard extends StatelessWidget {
  const GroupFeedCard({super.key, required this.group, required this.onTap});

  final Group group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: cs.onSurface.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Hero(group: group),
            _Body(group: group),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.group});
  final Group group;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.lg),
      ),
      child: SizedBox(
        height: 180,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      HSLColor.fromAHSL(1.0, group.hue, 0.55, 0.50).toColor(),
                      HSLColor.fromAHSL(
                        1.0,
                        (group.hue + 35) % 360,
                        0.60,
                        0.30,
                      ).toColor(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x55000000)],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
            ),
            Center(
              child: Icon(
                _kindIcon(group.kind),
                size: 64,
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
            Positioned(top: 16, left: 16, child: _KindPill(kind: group.kind)),
            if (group.verified)
              const Positioned(top: 14, right: 14, child: _VerifiedPill()),
            Positioned(
              left: 20,
              right: 20,
              bottom: 16,
              child: Text(
                group.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KindPill extends StatelessWidget {
  const _KindPill({required this.kind});
  final GroupKind kind;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkGlassBg : AppColors.lightGlassBg;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        kind.label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: cs.onSurface,
          letterSpacing: 0.3,
          height: 1,
        ),
      ),
    );
  }
}

class _VerifiedPill extends StatelessWidget {
  const _VerifiedPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: const Text(
        'OFICIAL',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.group});
  final Group group;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.tagline,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: cs.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 14,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${group.memberCount} miembros · ${group.leader}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _StateCta(group: group),
            ],
          ),
          if (group.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                group.description.length > 130
                    ? '${group.description.substring(0, 130)}…'
                    : group.description,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                  letterSpacing: -0.07,
                  height: 1.5,
                ),
              ),
            ),
          ],
          if (group.nextAction.isNotEmpty &&
              group.nextAction != 'Sin acción pendiente') ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.event_outlined, size: 14, color: cs.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    group.nextAction,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: cs.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StateCta extends StatelessWidget {
  const _StateCta({required this.group});
  final Group group;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final appState = AppStateRepository.instance;
    final isMember = appState.isMember(group.id);
    final isFollowing = appState.isFollowing(group.id);

    if (isMember) {
      return _Pill(
        label: 'Miembro',
        bg: cs.primary.withValues(alpha: 0.12),
        fg: cs.primary,
      );
    }
    if (isFollowing) {
      return _Pill(
        label: 'Siguiendo',
        bg: cs.surfaceContainerHigh,
        fg: cs.onSurfaceVariant,
      );
    }
    final (label, icon) = switch (group.access) {
      GroupAccess.open => ('Seguir', Icons.add),
      GroupAccess.request => ('Solicitar', Icons.how_to_reg_outlined),
      GroupAccess.invite => ('Privado', Icons.lock_outline),
    };
    final disabled = group.access == GroupAccess.invite;
    return GestureDetector(
      onTap: disabled ? null : () => appState.followGroup(group.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: disabled ? cs.surfaceContainerHigh : cs.primary,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 12,
              color: disabled ? cs.onSurfaceVariant : cs.onPrimary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: disabled ? cs.onSurfaceVariant : cs.onPrimary,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

IconData _kindIcon(GroupKind kind) => switch (kind) {
  GroupKind.project => Icons.code_outlined,
  GroupKind.study => Icons.menu_book_outlined,
  GroupKind.club => Icons.groups_outlined,
  GroupKind.sport => Icons.sports_outlined,
  GroupKind.official => Icons.campaign_outlined,
};
