import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_avatar.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/chat_preview.dart';
import '../../data/models/group.dart';
import '../../data/repositories/app_state_repository.dart';
import '../../data/repositories/student_repository.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key, this.embedded = false});
  final bool embedded;

  static final _repo = StudentRepository();

  List<Group> _followedGroups() {
    final appState = AppStateRepository.instance;
    final ids = {...appState.followedGroupIds, ...appState.memberGroupIds};
    final all = [...MockData.mockGroups, ...appState.userCreatedGroups];
    return all.where((g) => ids.contains(g.id)).toList();
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
    final chats = MockData.chats;
    final followedGroups = _followedGroups();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !embedded,
        title: Text('Mensajes', style: AppTextStyles.titleMd(cs.onSurface)),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _GroupsBand(groups: followedGroups),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.space5,
                AppSpacing.space4,
                AppSpacing.space5,
                AppSpacing.space2,
              ),
              child: Text(
                'Conversaciones',
                style: AppTextStyles.titleMd(cs.onSurface),
              ),
            ),
          ),
          SliverList.separated(
            itemCount: chats.length,
            separatorBuilder: (context, idx) => Divider(
              indent: 72,
              height: 0,
              color: cs.outlineVariant.withValues(alpha: 0.5),
            ),
            itemBuilder: (context, i) {
              final chat = chats[i];
              final student = _repo.getById(chat.studentId);
              if (student == null) return const SizedBox.shrink();
              return _ChatRow(
                chat: chat,
                photoUrl: student.photoUrl,
                onTap: () => Navigator.of(
                  context,
                ).pushNamed(AppRouter.conversation, arguments: student),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _GroupsBand extends StatelessWidget {
  const _GroupsBand({required this.groups});
  final List<Group> groups;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.space3),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'Grupos que sigues',
                    style: AppTextStyles.titleMd(cs.onSurface),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppRouter.groupsDiscover),
                  child: Text(
                    'Descubrir',
                    style: AppTextStyles.labelSm(cs.primary).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space5,
              ),
              itemCount: groups.length + 1,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSpacing.space3),
              itemBuilder: (context, i) {
                if (i == groups.length) {
                  return _DiscoverGroupsCard(
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed(AppRouter.groupsDiscover),
                  );
                }
                return _GroupMiniCard(group: groups[i]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupMiniCard extends StatelessWidget {
  const _GroupMiniCard({required this.group});
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
          height: 140,
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      HSLColor.fromAHSL(1.0, group.hue, 0.55, 0.50).toColor(),
                      HSLColor.fromAHSL(
                        1.0,
                        (group.hue + 30) % 360,
                        0.65,
                        0.30,
                      ).toColor(),
                    ],
                  ),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0x66000000)],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.space3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _kindIcon(group.kind),
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          group.nextAction,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

class _DiscoverGroupsCard extends StatelessWidget {
  const _DiscoverGroupsCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.ctaGradient(),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              'Descubrir',
              style: AppTextStyles.bodySm(cs.onSurface).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'grupos',
              style: AppTextStyles.bodySm(cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({required this.chat, required this.onTap, this.photoUrl});
  final ChatPreview chat;
  final VoidCallback onTap;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasUnread = chat.unreadCount > 0;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space2,
      ),
      leading: TAvatar(
        initials: chat.initials,
        hue: chat.hue,
        photoUrl: photoUrl,
        size: 52,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.studentName,
              style: AppTextStyles.titleMd(cs.onSurface),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            chat.time,
            style: AppTextStyles.labelSm(
              hasUnread ? cs.primary : cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              chat.lastMessage,
              style:
                  AppTextStyles.bodyMd(
                    hasUnread ? cs.onSurface : cs.onSurfaceVariant,
                  ).copyWith(
                    fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasUnread) ...[
            const SizedBox(width: AppSpacing.space2),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${chat.unreadCount}',
                style: AppTextStyles.labelSm(
                  Colors.white,
                ).copyWith(fontSize: 11),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
