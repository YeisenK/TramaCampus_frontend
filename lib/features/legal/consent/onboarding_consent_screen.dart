import 'package:flutter/material.dart';
import '../../../core/constants/app_info.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/t_button.dart';
import '../../../core/widgets/trama_mark.dart';
import 'consent_record.dart';

class OnboardingConsentScreen extends StatefulWidget {
  const OnboardingConsentScreen({super.key});

  @override
  State<OnboardingConsentScreen> createState() =>
      _OnboardingConsentScreenState();
}

class _OnboardingConsentScreenState extends State<OnboardingConsentScreen> {
  bool _acceptedMain = false;
  bool _acceptedSecondary = false;
  bool _loading = false;

  Future<void> _continue() async {
    if (!_acceptedMain || _loading) return;
    setState(() => _loading = true);
    await ConsentRepository.instance.saveConsent(
      ConsentRecord(
        docsVersion: AppInfo.legalDocsVersion,
        acceptedPrimary: true,
        acceptedSecondary: _acceptedSecondary,
        acceptedAge: true,
        timestamp: DateTime.now(),
      ),
    );
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRouter.identity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.edgePadding,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Column(
                children: [
                  const TramaMark(size: 48),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    'Antes de empezar',
                    style: AppTextStyles.headlineSm(cs.onSurface),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  Text(
                    'Necesitamos tu consentimiento informado para tratar '
                    'tus datos personales conforme a la LFPDPPP.',
                    style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space7),
              _MainConsentCard(
                cs: cs,
                value: _acceptedMain,
                onChanged: (v) => setState(() => _acceptedMain = v),
              ),
              const SizedBox(height: AppSpacing.space3),
              _SecondaryConsentCard(
                cs: cs,
                value: _acceptedSecondary,
                onChanged: (v) => setState(() => _acceptedSecondary = v),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: TButton(
                  label: _loading ? 'Guardando...' : 'Continuar',
                  onPressed: (_acceptedMain && !_loading) ? _continue : null,
                  icon: Icons.arrow_upward,
                ),
              ),
              const SizedBox(height: AppSpacing.space6),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainConsentCard extends StatelessWidget {
  const _MainConsentCard({
    required this.cs,
    required this.value,
    required this.onChanged,
  });

  final ColorScheme cs;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: value
              ? cs.primaryContainer.withValues(alpha: 0.25)
              : cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: value
                ? cs.primary.withValues(alpha: 0.4)
                : cs.outlineVariant.withValues(alpha: 0.4),
            width: value ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: cs.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: AppSpacing.space2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acepto los Términos y Condiciones y el Aviso de Privacidad.',
                    style: AppTextStyles.bodyMd(cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  Row(
                    children: [
                      _DocLink(
                        label: 'Términos y Condiciones',
                        route: AppRouter.termsConditions,
                      ),
                      const SizedBox(width: AppSpacing.space4),
                      _DocLink(
                        label: 'Aviso de Privacidad',
                        route: AppRouter.avisoPrivacidad,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryConsentCard extends StatelessWidget {
  const _SecondaryConsentCard({
    required this.cs,
    required this.value,
    required this.onChanged,
  });

  final ColorScheme cs;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: cs.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: AppSpacing.space2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Finalidades secundarias',
                          style: AppTextStyles.titleMd(cs.onSurface),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.space2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          'Opcional',
                          style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space1),
                  Text(
                    'Autorizo el uso de mis datos para mejora del producto '
                    'y comunicaciones no operativas. Puedes cambiarlo en '
                    'cualquier momento en Configuración.',
                    style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocLink extends StatelessWidget {
  const _DocLink({required this.label, required this.route});
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(route),
      child: Text(
        label,
        style: AppTextStyles.labelSm(AppColors.primary),
      ),
    );
  }
}
