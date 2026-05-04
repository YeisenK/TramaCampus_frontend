import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/step_dots.dart';
import '../../core/widgets/t_button.dart';
import '../../data/models/modality.dart';

class ModalitySelectScreen extends StatefulWidget {
  const ModalitySelectScreen({super.key});

  @override
  State<ModalitySelectScreen> createState() => _ModalitySelectScreenState();
}

class _ModalitySelectScreenState extends State<ModalitySelectScreen> {
  final Set<ModalityType> _selected = {};

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.space5),
                children: [
                  Text(
                    '¿Qué tipo de conexiones buscas?',
                    style: AppTextStyles.bodyLg(cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.space1),
                  Text(
                    'Puedes seleccionar más de una opción',
                    style: AppTextStyles.bodySm(cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.space5),
                  ...Modality.all.map((m) => _ModalityCard(
                        modality: m,
                        isSelected: _selected.contains(m.type),
                        onTap: () => setState(() {
                          if (_selected.contains(m.type)) {
                            _selected.remove(m.type);
                          } else {
                            _selected.add(m.type);
                          }
                        }),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space5),
              child: TButton(
                label: 'Continuar',
                onPressed: _selected.isEmpty
                    ? null
                    : () => Navigator.of(context).pushNamed(AppRouter.academicProfile),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: cs.surfaceDim,
      padding: const EdgeInsets.fromLTRB(AppSpacing.space5, AppSpacing.space6, AppSpacing.space5, AppSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back_ios_new, size: 20, color: cs.onSurface),
              ),
              const Spacer(),
              const StepDots(totalSteps: 6, currentStep: 2),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          Text('Modalidad', style: AppTextStyles.headlineSm(cs.onSurface)),
          const SizedBox(height: AppSpacing.space2),
          Text('Elige cómo quieres conectar', style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _ModalityCard extends StatelessWidget {
  const _ModalityCard({
    required this.modality,
    required this.isSelected,
    required this.onTap,
  });

  final Modality modality;
  final bool isSelected;
  final VoidCallback onTap;

  String get _description => switch (modality.type) {
        ModalityType.estudio => 'Encuentra compañeros para estudiar, hacer tareas y preparar exámenes juntos.',
        ModalityType.amistad => 'Conecta con personas que comparten tus intereses y actividades fuera de clase.',
        ModalityType.personal => 'Conoce a alguien especial en tu campus de una forma auténtica.',
      };

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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.ctaGradient() : null,
                color: isSelected ? null : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              alignment: Alignment.center,
              child: Icon(
                modality.icon,
                size: 24,
                color: isSelected ? Colors.white : cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(modality.label, style: AppTextStyles.titleMd(cs.onSurface)),
                  const SizedBox(height: 2),
                  Text(modality.verb, style: AppTextStyles.labelSm(cs.primary)),
                  const SizedBox(height: AppSpacing.space2),
                  Text(_description, style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: cs.primary, size: 22),
          ],
        ),
      ),
    );
  }
}
