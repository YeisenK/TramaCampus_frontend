import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Progress indicator for onboarding: "Paso X de N" kicker + animated pill dots.
class StepDots extends StatelessWidget {
  const StepDots({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.showKicker = true,
  });

  final int totalSteps;
  final int currentStep;
  final bool showKicker;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showKicker) ...[
          Text(
            'Paso ${currentStep + 1} de $totalSteps',
            style: AppTextStyles.labelSm(cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.space2),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(totalSteps, (i) {
            final isDone = i < currentStep;
            final isActive = i == currentStep;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isActive ? 20 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isDone
                    ? cs.primary.withValues(alpha: 0.45)
                    : isActive
                        ? cs.primary
                        : cs.outlineVariant,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            );
          }),
        ),
      ],
    );
  }
}
