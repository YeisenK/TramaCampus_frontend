import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/group.dart';
import '../../data/repositories/app_state_repository.dart';
import 'create_group_sheet.dart';
import 'widgets/group_card.dart';

class GroupsDiscoverScreen extends StatefulWidget {
  const GroupsDiscoverScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<GroupsDiscoverScreen> createState() => _GroupsDiscoverScreenState();
}

class _GroupsDiscoverScreenState extends State<GroupsDiscoverScreen> {
  GroupKind? _filter;

  List<Group> get _visibleGroups {
    final appState = AppStateRepository.instance;
    return [
      ...MockData.mockGroups,
      ...appState.userCreatedGroups,
    ].where((g) => g.isDiscoverable || appState.isMember(g.id)).toList();
  }

  List<Group> get _filtered {
    final all = _visibleGroups;
    if (_filter == null) return all;
    return all.where((g) => g.kind == _filter).toList();
  }

  List<Group> get _featured => _visibleGroups.where((g) => g.featured).toList();

  void _showCreate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => const CreateGroupSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppStateRepository.instance,
      builder: (context, _) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.space5,
                  AppSpacing.space4,
                  AppSpacing.space4,
                  AppSpacing.space3,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GRUPOS',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: cs.primary,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Descubrir',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                              letterSpacing: -0.025 * 30,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _showCreate,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: AppColors.ctaGradient(),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_featured.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.space5,
                      0,
                      AppSpacing.space5,
                      AppSpacing.space3,
                    ),
                    child: Text(
                      'Destacados',
                      style: AppTextStyles.titleMd(cs.onSurface),
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space5,
                      ),
                      itemCount: _featured.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.space3),
                      itemBuilder: (context, i) =>
                          _FeaturedGroupCard(group: _featured[i]),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space5),
                ],
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.space5,
                0,
                AppSpacing.space5,
                AppSpacing.space3,
              ),
              child: _FilterRow(
                selected: _filter,
                onChanged: (k) => setState(() => _filter = k),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.space5,
              0,
              AppSpacing.space5,
              100,
            ),
            sliver: SliverList.separated(
              itemCount: _filtered.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.space3),
              itemBuilder: (context, i) => GroupCard(
                group: _filtered[i],
                onTap: () => Navigator.of(
                  context,
                ).pushNamed(AppRouter.groupDetail, arguments: _filtered[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedGroupCard extends StatelessWidget {
  const _FeaturedGroupCard({required this.group});
  final Group group;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).pushNamed(AppRouter.groupDetail, arguments: group),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: SizedBox(
          width: 200,
          height: 160,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
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
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                      ],
                      stops: const [0.3, 1.0],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.space3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _kindIcon(group.kind),
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 11,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${group.memberCount}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.selected, required this.onChanged});
  final GroupKind? selected;
  final ValueChanged<GroupKind?> onChanged;

  static const _filters = [
    (null, 'Todos'),
    (GroupKind.study, 'Estudio'),
    (GroupKind.project, 'Proyectos'),
    (GroupKind.club, 'Clubes'),
    (GroupKind.sport, 'Deporte'),
    (GroupKind.official, 'Oficiales'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _filters.map((entry) {
          final (kind, label) = entry;
          final isActive = selected == kind;
          return GestureDetector(
            onTap: () => onChanged(kind),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: AppSpacing.space2),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space3,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isActive ? cs.onSurface : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isActive ? cs.surface : cs.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
