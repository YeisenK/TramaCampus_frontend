import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_avatar.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/conversation_message.dart';
import '../../data/models/student.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, required this.student});
  final Student student;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late List<ConversationMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(MockData.conversation);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages = [
        ..._messages,
        ConversationMessage(
          id: 'm${_messages.length + 1}',
          text: text,
          isMe: true,
          time: _nowTime(),
        ),
      ];
    });
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _nowTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final s = widget.student;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(AppRouter.profileDetail, arguments: s),
          child: Row(
            children: [
              TAvatar(initials: s.initials, hue: s.hue, size: 36),
              const SizedBox(width: AppSpacing.space3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name, style: AppTextStyles.titleMd(cs.onSurface)),
                  Text(s.program, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => Navigator.of(context).pushNamed(
              AppRouter.reportProblem,
              arguments: s,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(AppSpacing.space4, AppSpacing.space4, AppSpacing.space4, AppSpacing.space4),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _Bubble(message: _messages[i], student: s),
            ),
          ),
          _InputBar(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.student});
  final ConversationMessage message;
  final Student student;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMe = message.isMe;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            TAvatar(initials: student.initials, hue: student.hue, size: 28),
            const SizedBox(width: AppSpacing.space2),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space4,
                    vertical: AppSpacing.space3,
                  ),
                  decoration: BoxDecoration(
                    gradient: isMe ? AppColors.ctaGradient() : null,
                    color: isMe ? null : cs.surfaceContainerLowest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(AppRadius.md),
                      topRight: const Radius.circular(AppRadius.md),
                      bottomLeft: Radius.circular(isMe ? AppRadius.md : 6),
                      bottomRight: Radius.circular(isMe ? 6 : AppRadius.md),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyles.bodyMd(isMe ? Colors.white : cs.onSurface),
                  ),
                ),
                const SizedBox(height: AppSpacing.space1),
                Text(message.time, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: AppSpacing.space2),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4,
          vertical: AppSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(top: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5))),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: cs.surfaceContainerHigh,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space4,
                    vertical: AppSpacing.space3,
                  ),
                ),
                minLines: 1,
                maxLines: 4,
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.ctaGradient(),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.arrow_upward, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
