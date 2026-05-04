import 'package:flutter/material.dart';
import '../../app.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_app_bar.dart';

class SettingsThemeScreen extends StatelessWidget {
  const SettingsThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const TAppBar(title: 'Apariencia'),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, currentMode, _) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.space4),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  children: [
                    _ThemeOption(
                      icon: Icons.brightness_auto,
                      label: 'Automático',
                      description: 'Sigue la configuración del sistema',
                      isSelected: currentMode == ThemeMode.system,
                      onTap: () => themeNotifier.value = ThemeMode.system,
                    ),
                    Divider(indent: 56, height: 0, color: cs.outlineVariant.withValues(alpha: 0.5)),
                    _ThemeOption(
                      icon: Icons.light_mode_outlined,
                      label: 'Claro',
                      description: 'Siempre usar el tema claro',
                      isSelected: currentMode == ThemeMode.light,
                      onTap: () => themeNotifier.value = ThemeMode.light,
                    ),
                    Divider(indent: 56, height: 0, color: cs.outlineVariant.withValues(alpha: 0.5)),
                    _ThemeOption(
                      icon: Icons.dark_mode_outlined,
                      label: 'Oscuro',
                      description: 'Siempre usar el tema oscuro',
                      isSelected: currentMode == ThemeMode.dark,
                      onTap: () => themeNotifier.value = ThemeMode.dark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.space5),
              Container(
                padding: const EdgeInsets.all(AppSpacing.space4),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: cs.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.space3),
                    Expanded(
                      child: Text(
                        'El tema automático se adapta según la configuración de tu dispositivo.',
                        style: AppTextStyles.bodySm(cs.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? cs.primary.withValues(alpha: 0.12) : cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: isSelected ? cs.primary : cs.onSurfaceVariant),
      ),
      title: Text(label, style: AppTextStyles.bodyMd(cs.onSurface)),
      subtitle: Text(description, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: cs.primary, size: 22)
          : Icon(Icons.radio_button_unchecked, color: cs.outlineVariant, size: 22),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4, vertical: AppSpacing.space1),
    );
  }
}
