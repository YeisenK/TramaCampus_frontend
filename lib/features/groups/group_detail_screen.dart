import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/group.dart';
import '../../data/models/task.dart';
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
                  : _tab == 'members'
                  ? _MembersTab(
                      key: const ValueKey('members'),
                      group: widget.group,
                      cs: cs,
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
    ('members', 'Miembros'),
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

class _MembersTab extends StatelessWidget {
  const _MembersTab({super.key, required this.group, required this.cs});
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
        Text(
          '${group.memberCount} miembros',
          style: AppTextStyles.titleMd(cs.onSurface),
        ),
        const SizedBox(height: AppSpacing.space3),
        _MemberRow(name: group.leader, role: 'Líder', cs: cs),
        ...List.generate(
          3,
          (i) => _MemberRow(name: 'Miembro ${i + 1}', role: 'Miembro', cs: cs),
        ),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.name, required this.role, required this.cs});
  final String name;
  final String role;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name[0] : '?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.titleMd(cs.onSurface)),
                Text(role, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
              ],
            ),
          ),
        ],
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
        _InfoRow(
          icon: Icons.lock_outline,
          label: 'Acceso',
          value: group.access.label,
          cs: cs,
        ),
        const SizedBox(height: AppSpacing.space3),
        _InfoRow(
          icon: Icons.people_outline,
          label: 'Miembros',
          value: group.capacity != null
              ? '${group.memberCount} / ${group.capacity}'
              : '${group.memberCount}',
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
