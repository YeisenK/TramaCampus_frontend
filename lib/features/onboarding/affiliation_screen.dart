import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/step_dots.dart';
import '../../core/widgets/t_button.dart';
import '../../data/repositories/onboarding_draft_repository.dart';

class AffiliationScreen extends StatefulWidget {
  const AffiliationScreen({super.key});

  @override
  State<AffiliationScreen> createState() => _AffiliationScreenState();
}

class _AffiliationScreenState extends State<AffiliationScreen> {
  String? _selected;

  static const _options = [
    _AffiliationOption(
      id: 'student',
      label: 'Estudiante',
      subtitle: 'Inscrito en un programa de licenciatura o ingeniería',
      icon: Icons.school_outlined,
      requiresApproval: false,
    ),
    _AffiliationOption(
      id: 'faculty',
      label: 'Docente',
      subtitle: 'Profesor o instructor del campus',
      icon: Icons.person_outlined,
      requiresApproval: true,
    ),
    _AffiliationOption(
      id: 'staff',
      label: 'Personal administrativo',
      subtitle: 'Colaborador del campus fuera del aula',
      icon: Icons.badge_outlined,
      requiresApproval: true,
    ),
  ];

  bool get _needsApproval =>
      _selected != null &&
      _options.firstWhere((o) => o.id == _selected).requiresApproval;

  Future<void> _continue() async {
    final draft = await OnboardingDraftRepository.instance.load();
    draft.lastCompletedStep = 'affiliation';
    // affiliation is not in ProfileDraft yet — store as a free field via
    // lastCompletedStep tagging. When backend exists, add proper affiliation field.
    await OnboardingDraftRepository.instance.save(draft);
    if (!mounted) return;
    Navigator.of(context).pushNamed(AppRouter.academicProfile);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(cs),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.space5),
                children: [
                  ..._options.map(
                    (opt) => _AffiliationCard(
                      option: opt,
                      isSelected: _selected == opt.id,
                      onTap: () => setState(() => _selected = opt.id),
                    ),
                  ),
                  if (_needsApproval) ...[
                    const SizedBox(height: AppSpacing.space4),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.space4),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.schedule_outlined,
                            size: 20,
                            color: cs.onPrimaryContainer,
                          ),
                          const SizedBox(width: AppSpacing.space3),
                          Expanded(
                            child: Text(
                              'Tu cuenta quedará en revisión por hasta 72 horas antes de activarse. Recibirás una notificación cuando esté lista.',
                              style: AppTextStyles.bodySm(
                                cs.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space5),
              child: TButton(
                label: 'Continuar',
                onPressed: _selected == null ? null : _continue,
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
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: cs.onSurface,
              ),
            ),
            const Spacer(),
            const StepDots(totalSteps: 8, currentStep: 3),
          ],
        ),
        const SizedBox(height: AppSpacing.space5),
        Text(
          'Tu rol en el campus',
          style: AppTextStyles.headlineSm(cs.onSurface),
        ),
        const SizedBox(height: AppSpacing.space2),
        Text(
          '¿Cómo participas en tu institución?',
          style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
        ),
      ],
    ),
  );
}

class _AffiliationOption {
  const _AffiliationOption({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.requiresApproval,
  });

  final String id;
  final String label;
  final String subtitle;
  final IconData icon;
  final bool requiresApproval;
}

class _AffiliationCard extends StatelessWidget {
  const _AffiliationCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final _AffiliationOption option;
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
                color: isSelected
                    ? cs.primary.withValues(alpha: 0.12)
                    : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              alignment: Alignment.center,
              child: Icon(
                option.icon,
                size: 22,
                color: isSelected ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: AppTextStyles.titleMd(cs.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.subtitle,
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
