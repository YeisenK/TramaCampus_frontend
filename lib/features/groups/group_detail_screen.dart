import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/group.dart';
import '../../data/models/group_message.dart';
import '../../data/models/task.dart';
import '../../data/repositories/app_state_repository.dart';
import 'widgets/group_hero.dart';
import 'widgets/task_row.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({super.key, required this.group});

  final Group group;

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  String _tab = 'tasks';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ghost = isDark
        ? AppColors.darkOutlineGhost
        : AppColors.lightOutlineGhost;

    return Scaffold(
      body: Column(
        children: [
          GroupHero(
            group: widget.group,
            onBack: () => Navigator.of(context).pop(),
          ),
          _TabBar(
            selected: _tab,
            onChanged: (t) => setState(() => _tab = t),
            ghostColor: ghost,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _tab == 'tasks'
                  ? _TasksTab(key: const ValueKey('tasks'))
                  : _tab == 'chat'
                  ? _ConversationTab(
                      key: const ValueKey('chat'),
                      group: widget.group,
                    )
                  : _AboutTab(
                      key: const ValueKey('about'),
                      group: widget.group,
                      cs: cs,
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: _tab == 'tasks'
          ? FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Nueva tarea'),
            )
          : _tab == 'chat'
          ? null
          : null,
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.selected,
    required this.onChanged,
    required this.ghostColor,
  });
  final String selected;
  final ValueChanged<String> onChanged;
  final Color ghostColor;

  static const _tabs = [
    ('tasks', 'Tablero'),
    ('chat', 'Conversación'),
    ('about', 'Acerca de'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ghostColor, width: 1)),
      ),
      child: Row(
        children: _tabs.map((entry) {
          final (id, label) = entry;
          final isActive = selected == id;
          return GestureDetector(
            onTap: () => onChanged(id),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space5,
                vertical: AppSpacing.space3,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? cs.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? cs.onSurface : cs.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TasksTab extends StatefulWidget {
  const _TasksTab({super.key});

  @override
  State<_TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<_TasksTab> {
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(MockData.mockGroupTasks);
  }

  void _toggleTask(int index) {
    setState(() {
      final t = _tasks[index];
      final next = t.status == TaskStatus.done
          ? TaskStatus.todo
          : TaskStatus.done;
      _tasks[index] = Task(
        id: t.id,
        code: t.code,
        title: t.title,
        status: next,
        assigneeName: t.assigneeName,
        due: t.due,
        priority: t.priority,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final inProgress = _tasks
        .where((t) => t.status == TaskStatus.inProgress)
        .toList();
    final todo = _tasks.where((t) => t.status == TaskStatus.todo).toList();
    final done = _tasks.where((t) => t.status == TaskStatus.done).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space5,
        AppSpacing.space4,
        AppSpacing.space5,
        100,
      ),
      children: [
        if (inProgress.isNotEmpty) ...[
          _SectionHeader(
            label: 'EN PROGRESO',
            count: inProgress.length,
            cs: cs,
          ),
          ...inProgress.asMap().entries.map(
            (e) => TaskRow(
              task: e.value,
              onToggle: () =>
                  _toggleTask(_tasks.indexWhere((t) => t.id == e.value.id)),
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
        ],
        if (todo.isNotEmpty) ...[
          _SectionHeader(label: 'PENDIENTES', count: todo.length, cs: cs),
          ...todo.asMap().entries.map(
            (e) => TaskRow(
              task: e.value,
              onToggle: () =>
                  _toggleTask(_tasks.indexWhere((t) => t.id == e.value.id)),
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
        ],
        if (done.isNotEmpty) ...[
          _SectionHeader(label: 'COMPLETADAS', count: done.length, cs: cs),
          ...done.asMap().entries.map(
            (e) => TaskRow(
              task: e.value,
              onToggle: () =>
                  _toggleTask(_tasks.indexWhere((t) => t.id == e.value.id)),
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.label,
    required this.count,
    required this.cs,
  });
  final String label;
  final int count;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space2),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: cs.onSurfaceVariant,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: AppSpacing.space2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTab extends StatefulWidget {
  const _ConversationTab({super.key, required this.group});
  final Group group;

  @override
  State<_ConversationTab> createState() => _ConversationTabState();
}

class _ConversationTabState extends State<_ConversationTab> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  List<GroupMessage> get _messages =>
      AppStateRepository.instance.groupMessages(widget.group.id);

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final user = MockData.currentUser;
    final msg = GroupMessage(
      id: '${widget.group.id}_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      isMe: true,
      time: _nowTime(),
      senderName: user.name,
      senderHue: user.hue.toDouble(),
    );
    AppStateRepository.instance.sendGroupMessage(widget.group.id, msg);
    _controller.clear();
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _nowTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final messages = _messages;
    return Column(
      children: [
        Expanded(
          child: messages.isEmpty
              ? Center(
                  child: Text(
                    'Sé el primero en escribir',
                    style: AppTextStyles.bodySm(cs.onSurfaceVariant),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.space4,
                    AppSpacing.space4,
                    AppSpacing.space4,
                    AppSpacing.space2,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, i) => _GroupBubble(msg: messages[i]),
                ),
        ),
        _GroupInputBar(controller: _controller, onSend: _send),
      ],
    );
  }
}

class _GroupBubble extends StatelessWidget {
  const _GroupBubble({required this.msg});
  final GroupMessage msg;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
      child: Row(
        mainAxisAlignment: msg.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMe) ...[
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: AppSpacing.space2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HSLColor.fromAHSL(1.0, msg.senderHue, 0.50, 0.60)
                        .toColor(),
                    HSLColor.fromAHSL(
                      1.0,
                      (msg.senderHue + 30) % 360,
                      0.60,
                      0.40,
                    ).toColor(),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                msg.senderName.isNotEmpty ? msg.senderName[0] : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space3,
                vertical: AppSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: msg.isMe ? cs.primary : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: msg.isMe
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: msg.isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: msg.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!msg.isMe)
                    Text(
                      msg.senderName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cs.primary,
                      ),
                    ),
                  Text(
                    msg.text,
                    style: AppTextStyles.bodyMd(
                      msg.isMe ? cs.onPrimary : cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    msg.time,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: (msg.isMe ? cs.onPrimary : cs.onSurfaceVariant)
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupInputBar extends StatelessWidget {
  const _GroupInputBar({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.space4,
          right: AppSpacing.space4,
          bottom: AppSpacing.space3 +
              MediaQuery.viewInsetsOf(context).bottom,
          top: AppSpacing.space2,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: AppTextStyles.bodyMd(cs.onSurface),
                decoration: InputDecoration(
                  hintText: 'Escribe algo…',
                  hintStyle: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                  filled: true,
                  fillColor: cs.surfaceContainerLowest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space3,
                    vertical: 10,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: AppSpacing.space2),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.ctaGradient(),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.send_rounded, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab({super.key, required this.group, required this.cs});
  final Group group;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space5,
        AppSpacing.space4,
        AppSpacing.space5,
        100,
      ),
      children: [
        Text('Descripción', style: AppTextStyles.titleMd(cs.onSurface)),
        const SizedBox(height: AppSpacing.space3),
        Text(
          group.description,
          style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.space5),
        Text('Miembros', style: AppTextStyles.titleMd(cs.onSurface)),
        const SizedBox(height: AppSpacing.space3),
        _MembersInline(group: group, cs: cs),
        const SizedBox(height: AppSpacing.space5),
        _InfoRow(
          icon: Icons.lock_outline,
          label: 'Acceso',
          value: group.access.label,
          cs: cs,
        ),
        const SizedBox(height: AppSpacing.space3),
        _InfoRow(
          icon: Icons.bolt_outlined,
          label: 'Actividad',
          value: group.activity,
          cs: cs,
        ),
        const SizedBox(height: AppSpacing.space3),
        _InfoRow(
          icon: Icons.person_outline,
          label: 'Líder',
          value: group.leader,
          cs: cs,
        ),
      ],
    );
  }
}

class _MembersInline extends StatelessWidget {
  const _MembersInline({required this.group, required this.cs});
  final Group group;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final names = [group.leader, 'Miembro 2', 'Miembro 3'];
    return Row(
      children: [
        ...names.take(3).map((name) => _AvatarCircle(name: name, cs: cs)),
        if (group.memberCount > 3) ...[
          const SizedBox(width: AppSpacing.space2),
          Text(
            '+${group.memberCount - 3} más',
            style: AppTextStyles.labelSm(cs.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.name, required this.cs});
  final String name;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        shape: BoxShape.circle,
        border: Border.all(color: cs.surface, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0] : '?',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
  });
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: cs.onSurfaceVariant),
        const SizedBox(width: AppSpacing.space3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
            Text(value, style: AppTextStyles.bodyMd(cs.onSurface)),
          ],
        ),
      ],
    );
  }
}
