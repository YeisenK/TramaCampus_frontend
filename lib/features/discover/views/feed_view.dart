import 'package:flutter/material.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/feed_card.dart';
import '../../../core/widgets/group_feed_card.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/group.dart';
import '../../../data/models/student.dart';
import '../../../data/repositories/app_state_repository.dart';

enum FeedFilter { all, people, groups }

class DiscoverFeedView extends StatelessWidget {
  const DiscoverFeedView({
    super.key,
    required this.students,
    required this.saved,
    required this.onTap,
    required this.onSave,
    required this.filter,
    required this.onFilterChanged,
  });

  final List<Student> students;
  final Set<String> saved;
  final ValueChanged<Student> onTap;
  final ValueChanged<String> onSave;
  final FeedFilter filter;
  final ValueChanged<FeedFilter> onFilterChanged;

  List<Group> _discoverableGroups(AppStateRepository appState) {
    final all = [...MockData.mockGroups, ...appState.userCreatedGroups];
    return all.where((g) => g.isDiscoverable).toList();
  }

  /// Interleave people and groups so the feed alternates naturally.
  /// Drops a group every `groupEvery` slots until groups run out.
  List<_FeedItem> _build(List<Student> people, List<Group> groups) {
    if (filter == FeedFilter.people) {
      return people.map(_FeedItem.person).toList();
    }
    if (filter == FeedFilter.groups) {
      return groups.map(_FeedItem.group).toList();
    }
    final items = <_FeedItem>[];
    int gi = 0;
    int pi = 0;
    const groupEvery = 3;
    int slot = 0;
    while (pi < people.length || gi < groups.length) {
      final wantGroup = (slot % groupEvery == 1) && gi < groups.length;
      if (wantGroup) {
        items.add(_FeedItem.group(groups[gi]));
        gi++;
      } else if (pi < people.length) {
        items.add(_FeedItem.person(people[pi]));
        pi++;
      } else if (gi < groups.length) {
        items.add(_FeedItem.group(groups[gi]));
        gi++;
      }
      slot++;
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppStateRepository.instance,
      builder: (context, _) => _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final groups = _discoverableGroups(AppStateRepository.instance);
    final items = _build(students, groups);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space4,
            AppSpacing.space3,
            AppSpacing.space4,
            AppSpacing.space2,
          ),
          sliver: SliverToBoxAdapter(
            child: _FilterRow(
              selected: filter,
              onChanged: onFilterChanged,
              peopleCount: students.length,
              groupCount: groups.length,
            ),
          ),
        ),
        if (items.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: Icons.explore_outlined,
              title: 'Sin resultados',
              subtitle: 'Cambia la modalidad o el filtro',
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.space4,
              AppSpacing.space2,
              AppSpacing.space4,
              120,
            ),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.space4),
              itemBuilder: (context, i) {
                final item = items[i];
                if (item.student != null) {
                  final s = item.student!;
                  return RepaintBoundary(
                    child: FeedCard(
                      student: s,
                      onTap: () => onTap(s),
                      onSave: () => onSave(s.id),
                      isSaved: saved.contains(s.id),
                    ),
                  );
                }
                final g = item.group!;
                return RepaintBoundary(
                  child: GroupFeedCard(
                    group: g,
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRouter.groupDetail,
                      arguments: g,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _FeedItem {
  _FeedItem.person(this.student) : group = null;
  _FeedItem.group(this.group) : student = null;
  final Student? student;
  final Group? group;
}

// ---------- Filter row ----------

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.selected,
    required this.onChanged,
    required this.peopleCount,
    required this.groupCount,
  });

  final FeedFilter selected;
  final ValueChanged<FeedFilter> onChanged;
  final int peopleCount;
  final int groupCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _FilterPill(
            label: 'Todo',
            count: peopleCount + groupCount,
            isActive: selected == FeedFilter.all,
            onTap: () => onChanged(FeedFilter.all),
          ),
          const SizedBox(width: AppSpacing.space2),
          _FilterPill(
            label: 'Personas',
            count: peopleCount,
            isActive: selected == FeedFilter.people,
            onTap: () => onChanged(FeedFilter.people),
          ),
          const SizedBox(width: AppSpacing.space2),
          _FilterPill(
            label: 'Grupos',
            count: groupCount,
            isActive: selected == FeedFilter.groups,
            onTap: () => onChanged(FeedFilter.groups),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space3,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: isActive ? cs.onSurface : cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.labelSm(
                isActive ? cs.surface : cs.onSurface,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 6),
            Text(
              '$count',
              style: AppTextStyles.labelSm(
                isActive
                    ? cs.surface.withValues(alpha: 0.7)
                    : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

