import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/step_dots.dart';
import '../../core/widgets/t_button.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/university.dart';

class SelectUniScreen extends StatefulWidget {
  const SelectUniScreen({super.key});

  @override
  State<SelectUniScreen> createState() => _SelectUniScreenState();
}

class _SelectUniScreenState extends State<SelectUniScreen> {
  University? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OnboardingHeader(
              step: 0,
              title: 'Tu universidad',
              subtitle: 'Selecciona tu institución educativa',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.space5),
                children: [
                  ...MockData.universities.map(
                    (uni) => _UniCard(
                      university: uni,
                      isSelected: _selected == uni,
                      onTap: () => setState(() => _selected = uni),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space5),
              child: TButton(
                label: 'Continuar',
                onPressed: _selected == null
                    ? null
                    : () => Navigator.of(
                        context,
                      ).pushNamed(AppRouter.verifyEmail),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UniCard extends StatelessWidget {
  const _UniCard({
    required this.university,
    required this.isSelected,
    required this.onTap,
  });

  final University university;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.space3),
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.school_outlined,
                size: 22,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        university.name,
                        style: AppTextStyles.titleMd(cs.onSurface),
                      ),
                      if (university.verified) ...[
                        const SizedBox(width: AppSpacing.space1),
                        Icon(
                          Icons.verified_user_outlined,
                          size: 14,
                          color: cs.primary,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    university.emailDomain,
                    style: AppTextStyles.bodySm(cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check, color: cs.primary),
          ],
        ),
      ),
    );
  }
}

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader({
    required this.step,
    required this.title,
    required this.subtitle,
  });

  final int step;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
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
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: cs.onSurface,
                ),
              ),
              const Spacer(),
              StepDots(totalSteps: 6, currentStep: step),
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
}
