import 'package:flutter/material.dart';
import '../../core/constants/app_info.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/trama_mark.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const TAppBar(title: 'Acerca de'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space6,
          AppSpacing.space6,
          AppSpacing.space6,
          AppSpacing.space10,
        ),
        children: [
          Center(
            child: Column(
              children: [
                const TramaMark(size: 72),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  'Trama Campus',
                  style: AppTextStyles.headlineSm(cs.onSurface),
                ),
                const SizedBox(height: AppSpacing.space1),
                Text(
                  'Versión ${AppInfo.version} (${AppInfo.buildNumber})',
                  style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space6),
          Container(
            padding: const EdgeInsets.all(AppSpacing.space5),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Text(
              'Trama Campus es una plataforma universitaria para conectar estudiantes con propósito. Creada para ir más allá de las redes sociales tradicionales y construir vínculos reales en el campus.',
              style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Legal',
            children: [
              _AboutItem(
                label: 'Términos y condiciones',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRouter.termsConditions),
              ),
              _AboutItem(
                label: 'Política de privacidad',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRouter.privacyPolicy),
              ),
              _AboutItem(
                label: 'Normas de la comunidad',
                onTap: () => Navigator.of(
                  context,
                ).pushNamed(AppRouter.communityGuidelines),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Contacto',
            children: [_AboutItem(label: AppInfo.supportEmail, onTap: () {})],
          ),
          const SizedBox(height: AppSpacing.space8),
          Center(
            child: Text(
              '© 2026 Trama Campus. Todos los derechos reservados.',
              style: AppTextStyles.labelSm(cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
          Center(
            child: Text(
              'Hecho con ❤️ para estudiantes mexicanos.',
              style: AppTextStyles.labelSm(AppColors.primary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutItem extends StatelessWidget {
  const _AboutItem({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      title: Text(label, style: AppTextStyles.bodyMd(cs.onSurface)),
      trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 20),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space1,
      ),
    );
  }
}
