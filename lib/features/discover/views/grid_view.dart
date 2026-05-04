import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/models/student.dart';

class DiscoverGridView extends StatelessWidget {
  const DiscoverGridView({
    super.key,
    required this.students,
    required this.onTap,
  });

  final List<Student> students;
  final ValueChanged<Student> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (students.isEmpty) {
      return const EmptyState(
        icon: Icons.explore_outlined,
        title: 'Sin resultados',
        subtitle: 'Prueba con otra modalidad',
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space4,
        AppSpacing.space4,
        AppSpacing.space4,
        120,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.space3,
        crossAxisSpacing: AppSpacing.space3,
        childAspectRatio: 0.72,
      ),
      itemCount: students.length,
      itemBuilder: (context, i) {
        final s = students[i];
        return GestureDetector(
          onTap: () => onTap(s),
          child: Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          HSLColor.fromAHSL(1.0, s.hue, 0.45, 0.72).toColor(),
                          HSLColor.fromAHSL(1.0, (s.hue + 30) % 360, 0.55, 0.42).toColor(),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadius.md),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      s.initials,
                      style: AppTextStyles.headlineLg(Colors.white.withValues(alpha: 0.9)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.space3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.firstName, style: AppTextStyles.titleMd(cs.onSurface)),
                      Text(
                        '${s.program} · ${s.semester}°',
                        style: AppTextStyles.bodySm(cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
