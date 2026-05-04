import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 't_app_bar.dart';

class StaticSection {
  const StaticSection({required this.title, required this.body});
  final String title;
  final String body;
}

/// Reusable scaffold for legal, FAQ-style, and informational static pages.
class StaticTextPage extends StatelessWidget {
  const StaticTextPage({
    super.key,
    required this.title,
    required this.sections,
  });

  final String title;
  final List<StaticSection> sections;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: TAppBar(title: title),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space6,
          AppSpacing.space4,
          AppSpacing.space6,
          AppSpacing.space10,
        ),
        itemCount: sections.length,
        separatorBuilder: (_, i) => const SizedBox(height: AppSpacing.space6),
        itemBuilder: (_, i) {
          final s = sections[i];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.title, style: AppTextStyles.titleMd(cs.onSurface)),
              const SizedBox(height: AppSpacing.space3),
              Text(s.body, style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
            ],
          );
        },
      ),
    );
  }
}
