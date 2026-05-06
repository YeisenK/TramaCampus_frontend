import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/network_texture.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/trama_mark.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Network texture background
          NetworkTexture(opacity: 0.04),
          // Radial brand glow centered
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space6,
              ),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TramaMark(size: 72),
                      const SizedBox(height: AppSpacing.space3),
                      Text(
                        'Trama Campus',
                        style: AppTextStyles.headlineSm(AppColors.primary)
                            .copyWith(
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space6),
                  Text(
                    'Conoce personas\nen tu campus',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.display(cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    'Encuentra compañeros de estudio, amigos y conexiones reales con estudiantes de tu universidad.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLg(cs.onSurfaceVariant),
                  ),
                  const Spacer(flex: 3),
                  _ModalityRow(),
                  const SizedBox(height: AppSpacing.space7),
                  TButton(
                    label: 'Crear cuenta',
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRouter.identity),
                    icon: Icons.arrow_upward,
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  TButton(
                    label: 'Ya tengo cuenta',
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRouter.login),
                    variant: TButtonVariant.secondary,
                  ),
                  const SizedBox(height: AppSpacing.space6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModalityRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = [
      (Icons.menu_book_outlined, 'Estudio'),
      (Icons.group_outlined, 'Amistad'),
      (Icons.explore_outlined, 'Conexión'),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.space2),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space4,
            vertical: AppSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: [
              BoxShadow(
                color: cs.onSurface.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(item.$1, size: 24, color: AppColors.primary),
              const SizedBox(height: AppSpacing.space2),
              Text(item.$2, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
