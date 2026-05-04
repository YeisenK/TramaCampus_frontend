import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_app_bar.dart';

class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(title: 'Ajustes'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        children: [
          _SettingsSection(
            title: 'Cuenta',
            items: [
              _SettingsItem(
                icon: Icons.person_outline,
                label: 'Editar perfil',
                description: 'Nombre, foto, bio',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.lock_outline,
                label: 'Privacidad',
                description: 'Control de visibilidad',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.verified_user_outlined,
                label: 'Verificación',
                description: 'Estado del correo institucional',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space4),
          _SettingsSection(
            title: 'Preferencias',
            items: [
              _SettingsItem(
                icon: Icons.brightness_auto,
                label: 'Apariencia',
                description: 'Tema claro, oscuro o automático',
                onTap: () => Navigator.of(context).pushNamed(AppRouter.settingsTheme),
              ),
              _SettingsItem(
                icon: Icons.notifications_none,
                label: 'Notificaciones',
                description: 'Gestiona tus alertas',
                onTap: () => Navigator.of(context).pushNamed(AppRouter.notifications),
              ),
              _SettingsItem(
                icon: Icons.language_outlined,
                label: 'Idioma',
                description: 'Español',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space4),
          _SettingsSection(
            title: 'Descubrimiento',
            items: [
              _SettingsItem(
                icon: Icons.tune,
                label: 'Filtros de búsqueda',
                description: 'Carrera, semestre, intereses',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.explore_outlined,
                label: 'Modalidades activas',
                description: 'Estudio, Amistad, Conexión',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space4),
          _SettingsSection(
            title: 'Soporte',
            items: [
              _SettingsItem(
                icon: Icons.help_outline,
                label: 'Ayuda y FAQ',
                description: 'Preguntas frecuentes',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.shield_outlined,
                label: 'Privacidad y términos',
                description: 'Políticas de uso',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.flag_outlined,
                label: 'Reportar un problema',
                description: 'Envía un reporte al equipo',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space4),
          _SettingsSection(
            title: 'Sesión',
            items: [
              _SettingsItem(
                icon: Icons.logout,
                label: 'Cerrar sesión',
                description: 'Salir de tu cuenta',
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.welcome, (r) => false),
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.items});
  final String title;
  final List<_SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.space2, bottom: AppSpacing.space2),
          child: Text(title, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
        ),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  item,
                  if (i < items.length - 1)
                    Divider(
                      indent: 56,
                      height: 0,
                      color: cs.outlineVariant.withValues(alpha: 0.5),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final String description;
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
          color: isDestructive ? cs.error.withValues(alpha: 0.12) : cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: isDestructive ? cs.error : cs.onSurfaceVariant),
      ),
      title: Text(label, style: AppTextStyles.bodyMd(color)),
      subtitle: Text(description, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
      trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4, vertical: AppSpacing.space1),
    );
  }
}
