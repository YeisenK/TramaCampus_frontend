import 'package:flutter/material.dart';
import '../../core/constants/app_info.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/t_app_bar.dart';

class LegalHubScreen extends StatelessWidget {
  const LegalHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const TAppBar(title: 'Centro Legal'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.edgePadding,
          AppSpacing.space4,
          AppSpacing.edgePadding,
          120,
        ),
        children: [
          _HeroCard(cs: cs),
          const SizedBox(height: AppSpacing.space6),
          SectionCard(
            title: 'Documentos esenciales',
            children: [
              _LegalItem(
                icon: Icons.privacy_tip_outlined,
                label: 'Aviso de Privacidad',
                subtitle: 'Tratamiento de datos personales — LFPDPPP',
                route: AppRouter.avisoPrivacidad,
              ),
              _LegalItem(
                icon: Icons.article_outlined,
                label: 'Términos y Condiciones',
                subtitle: 'Reglas de uso de la plataforma',
                route: AppRouter.termsConditions,
              ),
              _LegalItem(
                icon: Icons.gavel,
                label: 'Derechos ARCO',
                subtitle: 'Acceso, Rectificación, Cancelación y Oposición',
                route: AppRouter.arcoRights,
              ),
              _LegalItem(
                icon: Icons.lock_outline,
                label: 'Política de Privacidad',
                subtitle: 'Resumen de cómo protegemos tus datos',
                route: AppRouter.privacyPolicy,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Servicios de la plataforma',
            children: [
              _LegalItem(
                icon: Icons.store_outlined,
                label: 'Política de Marketplace',
                subtitle: 'Vendedores, comisiones y disputas',
                route: AppRouter.marketplacePolicy,
              ),
              _LegalItem(
                icon: Icons.business_center_outlined,
                label: 'Política de Sponsors',
                subtitle: 'Empresas y partnerships',
                route: AppRouter.sponsorsPolicy,
              ),
              _LegalItem(
                icon: Icons.groups_outlined,
                label: 'Comunidad y Normas',
                subtitle: 'Conducta, contenido y roles',
                route: AppRouter.communityGuidelines,
              ),
              _LegalItem(
                icon: Icons.admin_panel_settings,
                label: 'Política de Moderación',
                subtitle: 'Proceso de revisión y sanciones',
                route: AppRouter.moderationPolicy,
              ),
              _LegalItem(
                icon: Icons.delete_outline,
                label: 'Eliminación de cuenta',
                subtitle: 'Retención y eliminación de datos',
                route: AppRouter.accountDeletionPolicy,
              ),
              _LegalItem(
                icon: Icons.data_usage_outlined,
                label: 'Cookies y Telemetría',
                subtitle: 'Almacenamiento local y analítica',
                route: AppRouter.cookiesPolicy,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Información',
            children: [
              _LegalItem(
                icon: Icons.info_outline,
                label: 'Acerca de Trama Campus',
                subtitle: 'Versión ${AppInfo.version}',
                route: AppRouter.about,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          _ContactCard(cs: cs),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: 0.1),
            cs.primary.withValues(alpha: 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(Icons.verified_user, size: 24, color: cs.primary),
          ),
          const SizedBox(width: AppSpacing.space4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Centro Legal', style: AppTextStyles.titleMd(cs.onSurface)),
                const SizedBox(height: AppSpacing.space1),
                Text(
                  'Transparencia total sobre cómo opera Trama Campus.',
                  style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space5),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mail_outline, size: 18, color: cs.primary),
              const SizedBox(width: AppSpacing.space2),
              Text(
                'Departamento de Privacidad',
                style: AppTextStyles.titleMd(cs.onSurface),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          _ContactRow(
            label: 'Derechos ARCO',
            value: AppInfo.arcoEmail,
            cs: cs,
          ),
          const SizedBox(height: AppSpacing.space2),
          _ContactRow(
            label: 'Privacidad',
            value: AppInfo.privacyEmail,
            cs: cs,
          ),
          const SizedBox(height: AppSpacing.space2),
          _ContactRow(
            label: 'Legal',
            value: AppInfo.legalEmail,
            cs: cs,
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            'Documentos versión ${AppInfo.legalDocsVersion} · Vigentes desde ${AppInfo.legalEffectiveDate}',
            style: AppTextStyles.labelSm(cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.label,
    required this.value,
    required this.cs,
  });
  final String label;
  final String value;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label: ', style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
        Flexible(
          child: Text(value, style: AppTextStyles.bodySm(cs.primary)),
        ),
      ],
    );
  }
}

class _LegalItem extends StatelessWidget {
  const _LegalItem({
    required this.icon,
    required this.label,
    required this.route,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String route;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(route),
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
      trailing: Icon(
        Icons.chevron_right,
        color: cs.onSurfaceVariant,
        size: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space1,
      ),
    );
  }
}
