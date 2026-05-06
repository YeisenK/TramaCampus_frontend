import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/step_dots.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/selection/selection_experience.dart';

// Shared scaffold for onboarding selection steps.
// Renders the step header + selection widget + continue button.
class SelectionStepScaffold extends StatelessWidget {
  const SelectionStepScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.selection,
    required this.canContinue,
    required this.onContinue,
  });

  final int step;
  final String title;
  final String subtitle;
  final SelectionExperience selection;
  final bool canContinue;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(cs),
            Expanded(child: selection),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space5),
              child: TButton(
                label: 'Continuar',
                onPressed: canContinue ? onContinue : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs) => Container(
    width: double.infinity,
    color: cs.surfaceDim,
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.space5,
      AppSpacing.space6,
      AppSpacing.space5,
      AppSpacing.space5,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (ctx) => GestureDetector(
                onTap: () => Navigator.of(ctx).maybePop(),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: cs.onSurface,
                ),
              ),
            ),
            const Spacer(),
            StepDots(totalSteps: 8, currentStep: step),
          ],
        ),
        const SizedBox(height: AppSpacing.space5),
        Text(title, style: AppTextStyles.headlineSm(cs.onSurface)),
        const SizedBox(height: AppSpacing.space2),
        Text(subtitle, style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
      ],
    ),
  );
}
