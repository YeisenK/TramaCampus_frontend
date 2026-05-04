import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/feed_card.dart';
import '../../../data/models/student.dart';

class DiscoverFeedView extends StatelessWidget {
  const DiscoverFeedView({
    super.key,
    required this.students,
    required this.saved,
    required this.onTap,
    required this.onSave,
  });

  final List<Student> students;
  final Set<String> saved;
  final ValueChanged<Student> onTap;
  final ValueChanged<String> onSave;

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const EmptyState(
        icon: Icons.explore_outlined,
        title: 'Sin resultados',
        subtitle: 'Prueba con otra modalidad',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space4,
        AppSpacing.space4,
        AppSpacing.space4,
        120,
      ),
      itemCount: students.length,
      separatorBuilder: (_, i) => const SizedBox(height: AppSpacing.space4),
      itemBuilder: (context, i) {
        final s = students[i];
        return RepaintBoundary(
          child: FeedCard(
            student: s,
            onTap: () => onTap(s),
            onSave: () => onSave(s.id),
            isSaved: saved.contains(s.id),
          ),
        );
      },
    );
  }
}
