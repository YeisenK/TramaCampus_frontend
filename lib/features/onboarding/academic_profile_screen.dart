import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/step_dots.dart';
import '../../core/widgets/t_button.dart';

class AcademicProfileScreen extends StatefulWidget {
  const AcademicProfileScreen({super.key});

  @override
  State<AcademicProfileScreen> createState() => _AcademicProfileScreenState();
}

class _AcademicProfileScreenState extends State<AcademicProfileScreen> {
  final _programController = TextEditingController();
  int _semester = 1;

  @override
  void dispose() {
    _programController.dispose();
    super.dispose();
  }

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
                  Text('Carrera o programa', style: AppTextStyles.titleMd(cs.onSurface)),
                  const SizedBox(height: AppSpacing.space3),
                  TextField(
                    controller: _programController,
                    decoration: const InputDecoration(
                      hintText: 'Ej: Ingeniería en Sistemas',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Semestre', style: AppTextStyles.titleMd(cs.onSurface)),
                      Text('$_semester de 12', style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: cs.primary,
                      thumbColor: cs.primary,
                      inactiveTrackColor: cs.surfaceContainerHigh,
                      overlayColor: cs.primary.withValues(alpha: 0.12),
                    ),
                    child: Slider(
                      value: _semester.toDouble(),
                      min: 1,
                      max: 12,
                      divisions: 11,
                      label: 'Semestre $_semester',
                      onChanged: (v) => setState(() => _semester = v.round()),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space5),
                  Text('Materias clave (opcional)', style: AppTextStyles.titleMd(cs.onSurface)),
                  const SizedBox(height: AppSpacing.space3),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Ej: Álgebra Lineal, Cálculo III...',
                      prefixIcon: Icon(Icons.science_outlined),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space5),
              child: TButton(
                label: 'Continuar',
                onPressed: () => Navigator.of(context).pushNamed(AppRouter.personalGoals),
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
                onTap: () => Navigator.of(context).maybePop(),
                child: Icon(Icons.arrow_back_ios_new, size: 20, color: cs.onSurface),
              ),
              const Spacer(),
              const StepDots(totalSteps: 6, currentStep: 3),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          Text('Perfil académico', style: AppTextStyles.headlineSm(cs.onSurface)),
          const SizedBox(height: AppSpacing.space2),
          Text('Cuéntanos sobre tus estudios', style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}
