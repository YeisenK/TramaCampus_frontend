import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_avatar.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/chat_preview.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final chats = MockData.chats;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !embedded,
        title: Text('Mensajes', style: AppTextStyles.titleMd(cs.onSurface)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
        itemCount: chats.length,
        separatorBuilder: (context, idx) => Divider(
          indent: 72,
          height: 0,
          color: cs.outlineVariant.withValues(alpha: 0.5),
        ),
        itemBuilder: (context, i) {
          final chat = chats[i];
          return _ChatRow(
            chat: chat,
            onTap: () {
              final student = MockData.students.firstWhere(
                (s) => s.id == chat.studentId,
                orElse: () => MockData.students.first,
              );
              Navigator.of(context).pushNamed(AppRouter.conversation, arguments: student);
            },
          );
        },
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({required this.chat, required this.onTap});
  final ChatPreview chat;
  final VoidCallback onTap;

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
      leading: TAvatar(initials: chat.initials, hue: chat.hue, size: 52),
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
            style: AppTextStyles.labelSm(hasUnread ? cs.primary : cs.onSurfaceVariant),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              chat.lastMessage,
              style: AppTextStyles.bodyMd(hasUnread ? cs.onSurface : cs.onSurfaceVariant).copyWith(
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
                style: AppTextStyles.labelSm(Colors.white).copyWith(fontSize: 11),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
