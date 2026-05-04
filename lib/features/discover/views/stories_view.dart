import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/models/student.dart';

class DiscoverStoriesView extends StatelessWidget {
  const DiscoverStoriesView({super.key, required this.students});

  final List<Student> students;

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const EmptyState(
        icon: Icons.explore_outlined,
        title: 'Sin resultados',
        subtitle: 'Prueba con otra modalidad',
      );
    }
    return PageView.builder(
      itemCount: students.length,
      itemBuilder: (context, i) {
        final s = students[i];
        return Stack(
          children: [
            Positioned.fill(
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
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              left: AppSpacing.space6,
              right: AppSpacing.space6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${s.name}, ${s.age}', style: AppTextStyles.headlineMd(Colors.white)),
                  Text(
                    '${s.program} · Sem. ${s.semester}',
                    style: AppTextStyles.bodyLg(Colors.white70),
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  if (s.bio.isNotEmpty)
                    Text(
                      '"${s.bio}"',
                      style: AppTextStyles.bodyMd(Colors.white70).copyWith(fontStyle: FontStyle.italic),
                    ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                children: List.generate(
                  students.length,
                  (j) => Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: j <= i ? Colors.white : Colors.white38,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
