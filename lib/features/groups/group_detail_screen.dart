import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_avatar.dart';
import '../../core/widgets/t_grab_bar.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/group.dart';
import '../../data/models/group_message.dart';
import '../../data/models/student.dart';
import '../../data/models/task.dart';
import '../../data/repositories/app_state_repository.dart';
import '../../data/repositories/student_repository.dart';
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

enum _DateBucket { today, week, later }

extension on _DateBucket {
  String get label => switch (this) {
    _DateBucket.today => 'Hoy',
    _DateBucket.week => 'Esta semana',
    _DateBucket.later => 'Próximas',
  };
}

_DateBucket _bucketFor(String due) {
  final s = due.toLowerCase().trim();
  if (s.startsWith('hoy') ||
      s.startsWith('mañana') ||
      s.startsWith('manana') ||
      s.startsWith('ayer') ||
      s.startsWith('hace ')) {
    return _DateBucket.today;
  }
  const weekdays = ['lun', 'mar', 'mié', 'mie', 'jue', 'vie', 'sáb', 'sab', 'dom'];
  if (weekdays.any(s.startsWith)) return _DateBucket.week;
  return _DateBucket.later;
}

class _TasksTab extends StatefulWidget {
  const _TasksTab({super.key});

  @override
  State<_TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<_TasksTab> {
  late List<Task> _tasks;
  bool _showCompleted = false;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(MockData.mockGroupTasks);
  }

  void _toggleTask(String id) {
    setState(() {
      final i = _tasks.indexWhere((t) => t.id == id);
      if (i < 0) return;
      final t = _tasks[i];
      final next = t.status == TaskStatus.done
          ? TaskStatus.todo
          : TaskStatus.done;
      _tasks[i] = Task(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ghost = isDark
        ? AppColors.darkOutlineGhost
        : AppColors.lightOutlineGhost;

    final open = _tasks.where((t) => t.status != TaskStatus.done).toList();
    final done = _tasks.where((t) => t.status == TaskStatus.done).toList();
    final inProgressCount = _tasks
        .where((t) => t.status == TaskStatus.inProgress)
        .length;
    final todoCount = _tasks
        .where((t) => t.status == TaskStatus.todo)
        .length;

    final byBucket = <_DateBucket, List<Task>>{};
    for (final t in open) {
      byBucket.putIfAbsent(_bucketFor(t.due), () => []).add(t);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space5,
        AppSpacing.space4,
        AppSpacing.space5,
        120,
      ),
      children: [
        _KpiStrip(
          inProgress: inProgressCount,
          pending: todoCount,
          done: done.length,
          cs: cs,
          ghost: ghost,
        ),
        const SizedBox(height: AppSpacing.space5),
        for (final bucket in _DateBucket.values)
          if ((byBucket[bucket] ?? const []).isNotEmpty) ...[
            _BucketHeader(
              label: bucket.label,
              count: byBucket[bucket]!.length,
              cs: cs,
            ),
            ...byBucket[bucket]!.map(
              (t) => TaskRow(task: t, onToggle: () => _toggleTask(t.id)),
            ),
            const SizedBox(height: AppSpacing.space4),
          ],
        if (done.isNotEmpty) _CompletedSection(
          tasks: done,
          expanded: _showCompleted,
          onToggleExpand: () =>
              setState(() => _showCompleted = !_showCompleted),
          onToggleTask: _toggleTask,
          cs: cs,
        ),
      ],
    );
  }
}

class _KpiStrip extends StatelessWidget {
  const _KpiStrip({
    required this.inProgress,
    required this.pending,
    required this.done,
    required this.cs,
    required this.ghost,
  });

  final int inProgress;
  final int pending;
  final int done;
  final ColorScheme cs;
  final Color ghost;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('En curso', inProgress, cs.primary),
      ('Pendientes', pending, cs.onSurface),
      ('Hechas', done, cs.onSurfaceVariant),
    ];
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: SizedBox(
        height: 84,
        child: Row(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0)
                VerticalDivider(width: 1, thickness: 1, color: ghost),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${items[i].$2}',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: items[i].$3,
                        letterSpacing: -0.02 * 28,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      items[i].$1,
                      style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BucketHeader extends StatelessWidget {
  const _BucketHeader({
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
      padding: const EdgeInsets.fromLTRB(
        0,
        0,
        0,
        AppSpacing.space2,
      ),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.titleMd(cs.onSurface)),
          const SizedBox(width: AppSpacing.space2),
          Text(
            '$count',
            style: AppTextStyles.labelSm(cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _CompletedSection extends StatelessWidget {
  const _CompletedSection({
    required this.tasks,
    required this.expanded,
    required this.onToggleExpand,
    required this.onToggleTask,
    required this.cs,
  });

  final List<Task> tasks;
  final bool expanded;
  final VoidCallback onToggleExpand;
  final ValueChanged<String> onToggleTask;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggleExpand,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.space2,
            ),
            child: Row(
              children: [
                Icon(
                  expanded ? Icons.expand_more : Icons.chevron_right,
                  size: 18,
                  color: cs.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  'Completadas',
                  style: AppTextStyles.titleMd(cs.onSurface),
                ),
                const SizedBox(width: AppSpacing.space2),
                Text(
                  '${tasks.length}',
                  style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          ...tasks.map(
            (t) => TaskRow(task: t, onToggle: () => onToggleTask(t.id)),
          ),
      ],
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

// ---------- Member roster (mix of real students + synthetic anonymous) ----------

const _kFirstNames = [
  'Andrea', 'Bruno', 'Carolina', 'Daniel', 'Elena', 'Fernando',
  'Gabriela', 'Hugo', 'Isabel', 'Jorge', 'Karla', 'Luis',
  'María', 'Nicolás', 'Olivia', 'Pablo', 'Quetzalli', 'Roberto',
  'Sara', 'Tomás', 'Valeria', 'Ximena', 'Yael', 'Zaira',
  'Regina', 'Emilio', 'Claudia', 'Sebastián', 'Lorena', 'Patricio',
];

const _kLastNames = [
  'Mendoza', 'Reyes', 'Vega', 'Castillo', 'Torres', 'Ramos',
  'Vargas', 'Jiménez', 'Salazar', 'Domínguez', 'Aguilar', 'Ortega',
  'Medina', 'Rojas', 'Cruz', 'Estrada', 'Romero', 'Ibarra',
  'Bautista', 'Núñez', 'Maldonado',
];

const _kPrograms = [
  'Ing. Industrial',
  'Negocios Internacionales',
  'Comunicación',
  'Psicología',
  'Arquitectura',
  'Diseño Gráfico',
  'Derecho',
  'Mercadotecnia',
  'Ing. Sistemas',
  'Pedagogía',
  'Nutrición',
  'Administración',
];

enum _MemberBadge { you, leader, notConnected, none }

class _RosterEntry {
  const _RosterEntry({
    this.student,
    required this.name,
    required this.program,
    required this.hue,
    this.photoUrl,
    required this.badge,
  });

  final Student? student;
  final String name;
  final String program;
  final double hue;
  final String? photoUrl;
  final _MemberBadge badge;

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return parts.isNotEmpty && parts[0].isNotEmpty ? parts[0][0] : '?';
  }
}

bool _isConnected(String studentId) =>
    MockData.chats.any((c) => c.studentId == studentId);

_MemberBadge _badgeFor({
  required Student student,
  required Group group,
}) {
  if (student.id == MockData.currentUser.id) return _MemberBadge.you;
  if (student.name == group.leader) return _MemberBadge.leader;
  if (!_isConnected(student.id)) return _MemberBadge.notConnected;
  return _MemberBadge.none;
}

List<_RosterEntry> _buildRoster(Group group) {
  const repo = StudentRepository();
  final entries = <_RosterEntry>[];
  final usedIds = <String>{};

  for (final id in group.members) {
    final s = repo.getById(id);
    if (s == null || !usedIds.add(s.id)) continue;
    entries.add(
      _RosterEntry(
        student: s,
        name: s.name,
        program: s.program,
        hue: s.hue,
        photoUrl: s.photoUrl,
        badge: _badgeFor(student: s, group: group),
      ),
    );
  }

  // Pad with deterministic synthetic members up to memberCount.
  // Cap at 80 to keep the official channel from generating thousands of rows.
  final remaining = group.memberCount - entries.length;
  final synthCount = remaining.clamp(0, 80);
  for (var i = 0; i < synthCount; i++) {
    final seed = (group.id.hashCode ^ ((i + 1) * 31)).abs();
    final first = _kFirstNames[seed % _kFirstNames.length];
    final last = _kLastNames[(seed ~/ 17) % _kLastNames.length];
    final program = _kPrograms[(seed ~/ 53) % _kPrograms.length];
    final hue = ((seed * 47) % 360).toDouble();
    entries.add(
      _RosterEntry(
        name: '$first $last',
        program: program,
        hue: hue,
        badge: _MemberBadge.notConnected,
      ),
    );
  }

  return entries;
}

int _hiddenAnonymousCount(Group group) {
  final visibleMax = group.members.length + 80;
  if (group.memberCount <= visibleMax) return 0;
  return group.memberCount - visibleMax;
}

class _MembersInline extends StatelessWidget {
  const _MembersInline({required this.group, required this.cs});
  final Group group;
  final ColorScheme cs;

  void _openMembersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => _MembersSheet(group: group),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roster = _buildRoster(group);
    if (roster.isEmpty) {
      return Text(
        '${group.memberCount} miembros',
        style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
      );
    }
    final shown = roster.take(4).toList();
    final remainder = group.memberCount - shown.length;

    return InkWell(
      onTap: () => _openMembersSheet(context),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space1),
        child: Row(
          children: [
            SizedBox(
              height: 38,
              width: shown.length * 26.0 + 12,
              child: Stack(
                children: [
                  for (int i = 0; i < shown.length; i++)
                    Positioned(
                      left: i * 26.0,
                      child: _StackedAvatar(entry: shown[i], cs: cs),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space2),
            Expanded(
              child: Text(
                _buildSummary(shown, remainder),
                style: AppTextStyles.bodyMd(cs.onSurface),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: cs.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  String _buildSummary(List<_RosterEntry> shown, int remainder) {
    final firstNames = shown
        .take(2)
        .map((e) => e.name.split(' ').first)
        .join(', ');
    if (remainder > 0) return '$firstNames y $remainder más';
    return firstNames;
  }
}

class _StackedAvatar extends StatelessWidget {
  const _StackedAvatar({required this.entry, required this.cs});
  final _RosterEntry entry;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: cs.surface, width: 2),
      ),
      child: TAvatar(
        initials: entry.initials,
        hue: entry.hue,
        photoUrl: entry.photoUrl,
        size: 34,
      ),
    );
  }
}

class _MembersSheet extends StatelessWidget {
  const _MembersSheet({required this.group});
  final Group group;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final roster = _buildRoster(group);
    final hidden = _hiddenAnonymousCount(group);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) => Column(
        children: [
          const SizedBox(height: AppSpacing.space3),
          const Center(child: TGrabBar()),
          const SizedBox(height: AppSpacing.space3),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space5,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Miembros',
                        style: AppTextStyles.titleMd(cs.onSurface),
                      ),
                      Text(
                        '${group.memberCount} en total',
                        style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
          Expanded(
            child: ListView.builder(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.space3,
                0,
                AppSpacing.space3,
                AppSpacing.space5,
              ),
              itemCount: roster.length + (hidden > 0 ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == roster.length) {
                  return _HiddenCountRow(count: hidden, cs: cs);
                }
                return _MemberRow(entry: roster[i], cs: cs);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.entry, required this.cs});
  final _RosterEntry entry;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final tappable = entry.student != null;
    return ListTile(
      onTap: tappable
          ? () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(
                AppRouter.profileDetail,
                arguments: entry.student,
              );
            }
          : null,
      leading: TAvatar(
        initials: entry.initials,
        hue: entry.hue,
        photoUrl: entry.photoUrl,
        size: 44,
      ),
      title: Text(
        entry.name,
        style: AppTextStyles.titleMd(cs.onSurface),
      ),
      subtitle: Text(
        entry.program,
        style: AppTextStyles.bodySm(cs.onSurfaceVariant),
      ),
      trailing: _BadgePill(badge: entry.badge, cs: cs),
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({required this.badge, required this.cs});
  final _MemberBadge badge;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    if (badge == _MemberBadge.none) return const SizedBox.shrink();

    final (label, bg, fg) = switch (badge) {
      _MemberBadge.you => (
        'Tú',
        cs.primary.withValues(alpha: 0.12),
        cs.primary,
      ),
      _MemberBadge.leader => (
        'Líder',
        cs.primary.withValues(alpha: 0.12),
        cs.primary,
      ),
      _MemberBadge.notConnected => (
        'No conectado',
        cs.surfaceContainerHigh,
        cs.onSurfaceVariant,
      ),
      _MemberBadge.none => ('', Colors.transparent, Colors.transparent),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _HiddenCountRow extends StatelessWidget {
  const _HiddenCountRow({required this.count, required this.cs});
  final int count;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.more_horiz,
          size: 20,
          color: cs.onSurfaceVariant,
        ),
      ),
      title: Text(
        '$count miembros más',
        style: AppTextStyles.titleMd(cs.onSurface),
      ),
      subtitle: Text(
        'No mostrados',
        style: AppTextStyles.bodySm(cs.onSurfaceVariant),
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
