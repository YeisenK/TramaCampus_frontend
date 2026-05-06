import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_avatar.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/group.dart';
import '../../data/models/student.dart';
import '../../data/repositories/app_state_repository.dart';
import '../../data/repositories/student_repository.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key, this.embedded = false});
  final bool embedded;

  static const _repo = StudentRepository();

  Group? _findGroup(String id, AppStateRepository appState) {
    for (final g in MockData.mockGroups) {
      if (g.id == id) return g;
    }
    for (final g in appState.userCreatedGroups) {
      if (g.id == id) return g;
    }
    return null;
  }

  /// Rail = public groups the user follows but is NOT a member of.
  List<Group> _followOnlyGroups(AppStateRepository appState) {
    final ids = appState.followedGroupIds.difference(appState.memberGroupIds);
    return ids
        .map((id) => _findGroup(id, appState))
        .whereType<Group>()
        .toList();
  }

  /// Conversations list = demo 1:1 chats + member groups, mixed.
  /// Persisted activity overrides the demo preview where present;
  /// items without persisted activity keep their natural mock order.
  List<_ConversationItem> _conversations(AppStateRepository appState) {
    final items = <_ConversationItem>[];

    // 1:1 chats — every demo chat shows up; new ones bubble up via persisted state.
    final seenStudentIds = <String>{};
    for (var i = 0; i < MockData.chats.length; i++) {
      final preview = MockData.chats[i];
      final student = _repo.getById(preview.studentId);
      if (student == null) continue;
      seenStudentIds.add(preview.studentId);

      final persisted = appState.directMessages(preview.studentId);
      final lastAt = appState.directLastAt(preview.studentId);
      final useDemo = persisted.isEmpty;

      items.add(
        _ConversationItem.direct(
          student: student,
          lastText: useDemo ? preview.lastMessage : persisted.last.text,
          time: useDemo ? preview.time : persisted.last.time,
          unreadCount: useDemo ? preview.unreadCount : 0,
          sortKey: lastAt,
          fallbackOrder: i,
        ),
      );
    }
    // Other students the user has chatted with (e.g., a new match) but who
    // aren't in MockData.chats.
    for (final studentId in appState.activeDirectStudentIds) {
      if (seenStudentIds.contains(studentId)) continue;
      final student = _repo.getById(studentId);
      if (student == null) continue;
      final persisted = appState.directMessages(studentId);
      if (persisted.isEmpty) continue;
      items.add(
        _ConversationItem.direct(
          student: student,
          lastText: persisted.last.text,
          time: persisted.last.time,
          unreadCount: 0,
          sortKey: appState.directLastAt(studentId),
          fallbackOrder: 1000,
        ),
      );
    }

    // Member groups — appear in the same list as normal conversations.
    var groupOrder = 0;
    for (final groupId in appState.memberGroupIds) {
      final group = _findGroup(groupId, appState);
      if (group == null) continue;
      final messages = appState.groupMessages(groupId);
      final last = messages.isNotEmpty ? messages.last : null;
      items.add(
        _ConversationItem.group(
          group: group,
          lastText: last?.text ?? group.nextAction,
          time: last?.time ?? '',
          unreadCount: 0,
          sortKey: appState.groupLastAt(groupId),
          fallbackOrder: 500 + groupOrder,
        ),
      );
      groupOrder++;
    }

    items.sort((a, b) {
      // Real activity first (sorted by time desc), then mock order.
      final ak = a.sortKey;
      final bk = b.sortKey;
      if (ak != null && bk != null) return bk.compareTo(ak);
      if (ak != null) return -1;
      if (bk != null) return 1;
      return a.fallbackOrder.compareTo(b.fallbackOrder);
    });
    return items;
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
    final appState = AppStateRepository.instance;
    final followOnly = _followOnlyGroups(appState);
    final conversations = _conversations(appState);

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
          if (followOnly.isNotEmpty)
            SliverToBoxAdapter(child: _FollowedGroupsBand(groups: followOnly)),
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
            itemCount: conversations.length,
            separatorBuilder: (context, idx) => Divider(
              indent: 72,
              height: 0,
              color: cs.outlineVariant.withValues(alpha: 0.5),
            ),
            itemBuilder: (context, i) =>
                _ConversationRow(item: conversations[i]),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

// ---------- Models ----------

class _ConversationItem {
  _ConversationItem.direct({
    required this.student,
    required this.lastText,
    required this.time,
    required this.unreadCount,
    required this.sortKey,
    required this.fallbackOrder,
  }) : group = null;

  _ConversationItem.group({
    required this.group,
    required this.lastText,
    required this.time,
    required this.unreadCount,
    required this.sortKey,
    required this.fallbackOrder,
  }) : student = null;

  final Student? student;
  final Group? group;
  final String lastText;
  final String time;
  final int unreadCount;
  final DateTime? sortKey;
  final int fallbackOrder;

  bool get isGroup => group != null;
}

// ---------- Rail ----------

class _FollowedGroupsBand extends StatelessWidget {
  const _FollowedGroupsBand({required this.groups});
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
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space5,
              ),
              itemCount: groups.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSpacing.space3),
              itemBuilder: (context, i) => _FollowedGroupCard(group: groups[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowedGroupCard extends StatelessWidget {
  const _FollowedGroupCard({required this.group});
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
          height: 132,
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
                          '${group.memberCount} miembros',
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
}

IconData _kindIcon(GroupKind kind) => switch (kind) {
  GroupKind.project => Icons.code_outlined,
  GroupKind.study => Icons.menu_book_outlined,
  GroupKind.club => Icons.groups_outlined,
  GroupKind.sport => Icons.sports_outlined,
  GroupKind.official => Icons.campaign_outlined,
};

// ---------- Conversation row (1:1 + group share the same shape) ----------

class _ConversationRow extends StatelessWidget {
  const _ConversationRow({required this.item});
  final _ConversationItem item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasUnread = item.unreadCount > 0;
    final onTap = item.isGroup
        ? () => Navigator.of(
            context,
          ).pushNamed(AppRouter.groupDetail, arguments: item.group)
        : () => Navigator.of(
            context,
          ).pushNamed(AppRouter.conversation, arguments: item.student);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space2,
      ),
      leading: item.isGroup
          ? _GroupAvatar(group: item.group!)
          : TAvatar(
              initials: item.student!.initials,
              hue: item.student!.hue,
              photoUrl: item.student!.photoUrl,
              size: 52,
            ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.isGroup ? item.group!.name : item.student!.name,
              style: AppTextStyles.titleMd(cs.onSurface),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (item.time.isNotEmpty)
            Text(
              item.time,
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
              item.lastText,
              style:
                  AppTextStyles.bodyMd(
                    hasUnread ? cs.onSurface : cs.onSurfaceVariant,
                  ).copyWith(
                    fontWeight:
                        hasUnread ? FontWeight.w500 : FontWeight.w400,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
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
                '${item.unreadCount}',
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

class _GroupAvatar extends StatelessWidget {
  const _GroupAvatar({required this.group});
  final Group group;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
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
              0.35,
            ).toColor(),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      alignment: Alignment.center,
      child: Icon(_kindIcon(group.kind), color: Colors.white, size: 22),
    );
  }
}
