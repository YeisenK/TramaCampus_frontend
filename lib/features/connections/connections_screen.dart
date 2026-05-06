import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_avatar.dart';
import '../../core/widgets/t_button.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/student.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !widget.embedded,
        title: Text('Conexiones', style: AppTextStyles.titleMd(cs.onSurface)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: cs.primary,
          labelColor: cs.primary,
          unselectedLabelColor: cs.onSurfaceVariant,
          tabs: const [
            Tab(text: 'Matches'),
            Tab(text: 'Solicitudes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_MatchesTab(), _RequestsTab()],
      ),
    );
  }
}

class _MatchesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final matches = MockData.students.take(4).toList();
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.space4),
      itemCount: matches.length,
      separatorBuilder: (context, idx) =>
          const SizedBox(height: AppSpacing.space3),
      itemBuilder: (context, i) {
        final s = matches[i];
        return _ConnectionCard(
          student: s,
          trailing: IconButton(
            icon: Icon(Icons.chat_bubble_outline, color: cs.primary),
            onPressed: () => Navigator.of(
              context,
            ).pushNamed(AppRouter.conversation, arguments: s),
          ),
        );
      },
    );
  }
}

class _RequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final requests = MockData.students.skip(4).toList();
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.space4),
      itemCount: requests.length,
      separatorBuilder: (context, idx) =>
          const SizedBox(height: AppSpacing.space3),
      itemBuilder: (context, i) {
        final s = requests[i];
        return _ConnectionCard(
          student: s,
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 92),
            child: TButton(
              label: 'Aceptar',
              isFullWidth: false,
              size: TButtonSize.sm,
              onPressed: () => Navigator.of(
                context,
              ).pushNamed(AppRouter.matchSuccess, arguments: s),
            ),
          ),
          showAcceptReject: true,
        );
      },
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({
    required this.student,
    required this.trailing,
    this.showAcceptReject = false,
  });

  final Student student;
  final Widget trailing;
  final bool showAcceptReject;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).pushNamed(AppRouter.profileDetail, arguments: student),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space3),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            TAvatar(
              initials: student.initials,
              hue: student.hue,
              photoUrl: student.photoUrl,
              size: 52,
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: AppTextStyles.titleMd(cs.onSurface),
                  ),
                  Text(
                    '${student.program} · Sem. ${student.semester}',
                    style: AppTextStyles.bodySm(cs.onSurfaceVariant),
                  ),
                  if (student.compatibilityScore > 0) ...[
                    const SizedBox(height: AppSpacing.space1),
                    Text(
                      '${student.compatibilityScore}% compatibilidad',
                      style: AppTextStyles.labelSm(cs.primary),
                    ),
                  ],
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
