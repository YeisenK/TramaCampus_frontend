import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/toggle_tile.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _twoFactor = false;
  bool _biometrics = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const TAppBar(title: 'Seguridad'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.space6),
        children: [
          SectionCard(
            title: 'Contraseña',
            children: [
              ListTile(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente disponible')),
                ),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.lock_outline, size: 18, color: cs.onSurfaceVariant),
                ),
                title: Text('Cambiar contraseña', style: AppTextStyles.bodyMd(cs.onSurface)),
                trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4, vertical: AppSpacing.space1),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Autenticación',
            children: [
              ToggleTile(
                icon: Icons.phone_android_outlined,
                label: 'Verificación en dos pasos',
                subtitle: 'Código SMS al iniciar sesión',
                value: _twoFactor,
                onChanged: (v) => setState(() => _twoFactor = v),
              ),
              ToggleTile(
                icon: Icons.fingerprint,
                label: 'Biometría',
                subtitle: 'Huella o Face ID',
                value: _biometrics,
                onChanged: (v) => setState(() => _biometrics = v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Sesiones activas',
            children: [
              _SessionTile(
                device: 'iPhone 15 Pro',
                location: 'Oaxaca, México',
                date: 'Activo ahora',
                isCurrent: true,
              ),
              _SessionTile(
                device: 'MacBook Pro',
                location: 'Oaxaca, México',
                date: 'Hace 2 días',
                isCurrent: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.device,
    required this.location,
    required this.date,
    required this.isCurrent,
  });

  final String device;
  final String location;
  final String date;
  final bool isCurrent;

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
        child: Icon(Icons.devices_outlined, size: 18, color: cs.onSurfaceVariant),
      ),
      title: Text(device, style: AppTextStyles.bodyMd(cs.onSurface)),
      subtitle: Text('$location · $date', style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
      trailing: isCurrent
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space2, vertical: 3),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text('Esta', style: AppTextStyles.labelSm(cs.primary)),
            )
          : IconButton(
              icon: Icon(Icons.close, size: 18, color: cs.error),
              onPressed: () {},
            ),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4, vertical: AppSpacing.space1),
    );
  }
}
