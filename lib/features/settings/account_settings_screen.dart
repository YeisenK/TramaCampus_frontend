import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/confirm_modal.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../data/mock/mock_data.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = MockData.currentUser;

    return Scaffold(
      appBar: const TAppBar(title: 'Cuenta'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.space6),
        children: [
          SectionCard(
            title: 'Información',
            children: [
              _InfoTile(
                icon: Icons.person_outline,
                label: 'Nombre',
                value: user.name,
              ),
              _InfoTile(
                icon: Icons.school_outlined,
                label: 'Universidad',
                value: 'Anáhuac Oaxaca',
              ),
              _InfoTile(
                icon: Icons.email_outlined,
                label: 'Correo institucional',
                value: 'usuario@anahuac.mx',
              ),
              _InfoTile(
                icon: Icons.verified_outlined,
                label: 'Estado de verificación',
                value: 'Verificado',
                valueColor: cs.primary,
              ),
              _InfoTile(
                icon: Icons.calendar_today_outlined,
                label: 'Miembro desde',
                value: 'Mayo 2026',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Acciones',
            children: [
              _ActionTile(
                icon: Icons.email_outlined,
                label: 'Cambiar correo',
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente disponible')),
                ),
              ),
              _ActionTile(
                icon: Icons.security_outlined,
                label: 'Seguridad y contraseña',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRouter.securitySettings),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Zona de peligro',
            children: [
              _ActionTile(
                icon: Icons.delete_forever_outlined,
                label: 'Eliminar cuenta',
                isDestructive: true,
                onTap: () async {
                  final ok = await ConfirmModal.show(
                    context,
                    title: '¿Eliminar cuenta?',
                    message:
                        'Esta acción no se puede deshacer. Perderás todos tus datos, conexiones y conversaciones.',
                    confirmLabel: 'Continuar',
                    destructive: true,
                  );
                  if (ok == true && context.mounted) {
                    Navigator.of(context).pushNamed(AppRouter.deleteAccount);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
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
      title: Text(label, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
      subtitle: Text(
        value,
        style: AppTextStyles.bodyMd(valueColor ?? cs.onSurface),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space1,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = isDestructive ? cs.error : cs.onSurface;
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDestructive
              ? cs.error.withValues(alpha: 0.12)
              : cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: isDestructive ? cs.error : cs.onSurfaceVariant,
        ),
      ),
      title: Text(label, style: AppTextStyles.bodyMd(color)),
      trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 20),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space1,
      ),
    );
  }
}
