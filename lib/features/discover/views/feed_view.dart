import 'package:flutter/material.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/feed_card.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/group.dart';
import '../../../data/models/student.dart';
import '../../../data/repositories/app_state_repository.dart';

class DiscoverFeedView extends StatelessWidget {
  const DiscoverFeedView({
    super.key,
    required this.students,
    required this.saved,
    required this.onTap,
    required this.onSave,
  });

  final List<Student> students;
  final Set<String> saved;
  final ValueChanged<Student> onTap;
  final ValueChanged<String> onSave;

  List<Group> _featuredGroups() {
    final appState = AppStateRepository.instance;
    final all = [...MockData.mockGroups, ...appState.userCreatedGroups];
    return all
        .where((g) => g.featured && g.isDiscoverable)
        .take(6)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final featuredGroups = _featuredGroups();
    if (students.isEmpty) {
      return const EmptyState(
        icon: Icons.explore_outlined,
        title: 'Sin resultados',
        subtitle: 'Prueba con otra modalidad',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space4,
        AppSpacing.space4,
        AppSpacing.space4,
        120,
      ),
      itemCount: students.length + (featuredGroups.isNotEmpty ? 1 : 0),
      separatorBuilder: (_, i) => const SizedBox(height: AppSpacing.space4),
      itemBuilder: (context, i) {
        if (i == 0 && featuredGroups.isNotEmpty) {
          return _ComunidadRail(groups: featuredGroups);
        }
        final s = students[featuredGroups.isNotEmpty ? i - 1 : i];
        return RepaintBoundary(
          child: FeedCard(
            student: s,
            onTap: () => onTap(s),
            onSave: () => onSave(s.id),
            isSaved: saved.contains(s.id),
          ),
        );
      },
    );
  }
}

class _ComunidadRail extends StatelessWidget {
  const _ComunidadRail({required this.groups});
  final List<Group> groups;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'Comunidad activa',
                style: AppTextStyles.titleMd(cs.onSurface),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRouter.groupsDiscover),
              child: Text(
                'Ver grupos',
                style: AppTextStyles.labelSm(cs.primary).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space3),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: groups.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppSpacing.space2),
            itemBuilder: (context, i) => _GroupChip(group: groups[i]),
          ),
        ),
      ],
    );
  }
}

class _GroupChip extends StatelessWidget {
  const _GroupChip({required this.group});
  final Group group;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateRepository.instance;
    final isMember = appState.isMember(group.id);
    final isFollowing = appState.isFollowing(group.id);
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(AppRouter.groupDetail, arguments: group),
      child: Container(
        width: 148,
        padding: const EdgeInsets.all(AppSpacing.space3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HSLColor.fromAHSL(1.0, group.hue, 0.55, 0.50).toColor(),
              HSLColor.fromAHSL(
                1.0,
                (group.hue + 40) % 360,
                0.65,
                0.30,
              ).toColor(),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(_kindIcon(group.kind), color: Colors.white, size: 16),
                if (isMember)
                  _Badge(label: 'Miembro')
                else if (!isFollowing && group.access != GroupAccess.invite)
                  GestureDetector(
                    onTap: () => appState.followGroup(group.id),
                    child: _Badge(label: 'Seguir', filled: true),
                  ),
              ],
            ),
            Text(
              group.name,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _kindIcon(GroupKind kind) => switch (kind) {
    GroupKind.project => Icons.code_outlined,
    GroupKind.study => Icons.menu_book_outlined,
    GroupKind.club => Icons.groups_outlined,
    GroupKind.sport => Icons.sports_outlined,
    GroupKind.official => Icons.campaign_outlined,
  };
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.filled = false});
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: filled
            ? Colors.white
            : Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: filled ? Colors.black87 : Colors.white,
        ),
      ),
    );
  }
}
