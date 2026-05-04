import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/step_dots.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_chip.dart';

class PersonalGoalsScreen extends StatefulWidget {
  const PersonalGoalsScreen({super.key});

  @override
  State<PersonalGoalsScreen> createState() => _PersonalGoalsScreenState();
}

class _PersonalGoalsScreenState extends State<PersonalGoalsScreen> {
  final Set<String> _selectedInterests = {};
  final Set<String> _selectedGoals = {};

  static const _interests = [
    'Café', 'Música', 'Deportes', 'Lectura', 'Cine', 'Viajes', 'Fotografía',
    'Arte', 'Gaming', 'Tecnología', 'Meditación', 'Cocina', 'Senderismo',
    'Teatro', 'Anime', 'Podcasts', 'Yoga', 'Idiomas',
  ];

  static const _goals = [
    'Mejorar mis calificaciones', 'Ampliar mi red de contactos',
    'Encontrar un equipo para proyectos', 'Hacer nuevos amigos',
    'Practicar idiomas', 'Participar en hackathons',
    'Encontrar pareja', 'Explorar la ciudad',
  ];

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
                  Text('Intereses', style: AppTextStyles.titleMd(cs.onSurface)),
                  const SizedBox(height: AppSpacing.space1),
                  Text('Elige los que más te representan', style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
                  const SizedBox(height: AppSpacing.space3),
                  Wrap(
                    spacing: AppSpacing.space2,
                    runSpacing: AppSpacing.space2,
                    children: _interests.map((i) => TChip(
                          label: i,
                          selected: _selectedInterests.contains(i),
                          onTap: () => setState(() {
                            if (_selectedInterests.contains(i)) {
                              _selectedInterests.remove(i);
                            } else {
                              _selectedInterests.add(i);
                            }
                          }),
                        )).toList(),
                  ),
                  const SizedBox(height: AppSpacing.space6),
                  Text('Objetivos en Trama', style: AppTextStyles.titleMd(cs.onSurface)),
                  const SizedBox(height: AppSpacing.space1),
                  Text('¿Qué esperas encontrar?', style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
                  const SizedBox(height: AppSpacing.space3),
                  Wrap(
                    spacing: AppSpacing.space2,
                    runSpacing: AppSpacing.space2,
                    children: _goals.map((g) => TChip(
                          label: g,
                          selected: _selectedGoals.contains(g),
                          onTap: () => setState(() {
                            if (_selectedGoals.contains(g)) {
                              _selectedGoals.remove(g);
                            } else {
                              _selectedGoals.add(g);
                            }
                          }),
                        )).toList(),
                  ),
                  const SizedBox(height: AppSpacing.space6),
                  Text('Bio (opcional)', style: AppTextStyles.titleMd(cs.onSurface)),
                  const SizedBox(height: AppSpacing.space3),
                  TextField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Cuéntanos algo sobre ti...',
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space5),
              child: TButton(
                label: 'Continuar',
                onPressed: () => Navigator.of(context).pushNamed(AppRouter.profileComplete),
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
              const StepDots(totalSteps: 6, currentStep: 4),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          Text('Intereses y metas', style: AppTextStyles.headlineSm(cs.onSurface)),
          const SizedBox(height: AppSpacing.space2),
          Text('Personaliza tu experiencia en Trama', style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}
