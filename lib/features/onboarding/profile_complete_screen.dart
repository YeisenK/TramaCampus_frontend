import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_button.dart';
import '../../data/mock/mock_data.dart';

class ProfileCompleteScreen extends StatelessWidget {
  const ProfileCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = MockData.currentUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space6),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.avatarGradient(user.hue),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      user.initials,
                      style: AppTextStyles.display(Colors.white),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.ctaGradient(),
                      border: Border.all(color: cs.surface, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space6),
              Text(
                '¡Perfil creado!',
                style: AppTextStyles.headlineLg(cs.onSurface),
              ),
              const SizedBox(height: AppSpacing.space3),
              Text(
                'Ya puedes empezar a conectar con estudiantes de tu campus.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLg(cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.space7),
              _CompletionBadge(
                icon: Icons.verified_user_outlined,
                label: 'Correo verificado',
              ),
              const SizedBox(height: AppSpacing.space3),
              _CompletionBadge(
                icon: Icons.school_outlined,
                label: 'Universidad confirmada',
              ),
              const SizedBox(height: AppSpacing.space3),
              _CompletionBadge(
                icon: Icons.explore_outlined,
                label: 'Modalidades seleccionadas',
              ),
              const Spacer(flex: 3),
              TButton(
                label: 'Empezar a conectar',
                onPressed: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRouter.discover, (route) => false),
                icon: Icons.explore_outlined,
              ),
              const SizedBox(height: AppSpacing.space6),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletionBadge extends StatelessWidget {
  const _CompletionBadge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space3),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: cs.primary),
          ),
          const SizedBox(width: AppSpacing.space3),
          Text(label, style: AppTextStyles.bodyMd(cs.onSurface)),
          const Spacer(),
          Icon(Icons.check_circle, color: cs.primary, size: 18),
        ],
      ),
    );
  }
}
