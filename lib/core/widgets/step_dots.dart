import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class StepDots extends StatelessWidget {
  const StepDots({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  final int totalSteps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (i) {
        final isDone = i < currentStep;
        final isActive = i == currentStep;
        return Container(
          width: isActive ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.space1),
          decoration: BoxDecoration(
            color: isDone
                ? cs.primary.withValues(alpha: 0.55)
                : isActive
                ? cs.primary
                : cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        );
      }),
    );
  }
}
