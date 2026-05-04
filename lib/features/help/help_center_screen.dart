import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/t_app_bar.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const TAppBar(title: 'Centro de ayuda'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.space6),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.space5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cs.primary.withValues(alpha: 0.12),
                  cs.primary.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.support_agent_outlined, size: 32, color: cs.primary),
                const SizedBox(height: AppSpacing.space3),
                Text(
                  '¿Cómo podemos ayudarte?',
                  style: AppTextStyles.titleMd(cs.onSurface),
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  'Encuentra respuestas, reporta problemas o contacta a nuestro equipo.',
                  style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space6),
          SectionCard(
            title: 'Recursos',
            children: [
              _HelpItem(
                icon: Icons.help_outline,
                label: 'Preguntas frecuentes',
                subtitle: 'Respuestas a las dudas más comunes',
                onTap: () => Navigator.of(context).pushNamed(AppRouter.faq),
              ),
              _HelpItem(
                icon: Icons.chat_bubble_outline,
                label: 'Contactar soporte',
                subtitle: 'Envía un mensaje a nuestro equipo',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRouter.contactSupport),
              ),
              _HelpItem(
                icon: Icons.flag_outlined,
                label: 'Reportar un problema',
                subtitle: 'Bugs, contenido inapropiado u otros',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRouter.reportProblem),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Información legal',
            children: [
              _HelpItem(
                icon: Icons.description_outlined,
                label: 'Términos y condiciones',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRouter.termsConditions),
              ),
              _HelpItem(
                icon: Icons.privacy_tip_outlined,
                label: 'Política de privacidad',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRouter.privacyPolicy),
              ),
              _HelpItem(
                icon: Icons.people_outline,
                label: 'Normas de la comunidad',
                onTap: () => Navigator.of(
                  context,
                ).pushNamed(AppRouter.communityGuidelines),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            children: [
              _HelpItem(
                icon: Icons.info_outline,
                label: 'Acerca de Trama Campus',
                onTap: () => Navigator.of(context).pushNamed(AppRouter.about),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  const _HelpItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: cs.onSurfaceVariant),
      ),
      title: Text(label, style: AppTextStyles.bodyMd(cs.onSurface)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTextStyles.labelSm(cs.onSurfaceVariant))
          : null,
      trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 20),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space1,
      ),
    );
  }
}
