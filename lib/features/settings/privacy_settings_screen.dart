import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/section_card.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/toggle_tile.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  int _visibility = 0; // 0=Público, 1=Solo verificados, 2=Oculto
  bool _showSemester = true;
  bool _showProgram = true;
  bool _showAge = true;
  bool _shareInterests = true;
  bool _allowMessages = true;
  bool _allowGroupInvites = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const TAppBar(title: 'Privacidad'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.space6),
        children: [
          SectionCard(
            title: 'Visibilidad del perfil',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space4,
                  vertical: AppSpacing.space3,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('¿Quién puede ver tu perfil?', style: AppTextStyles.bodyMd(cs.onSurface)),
                    const SizedBox(height: AppSpacing.space3),
                    _VisibilityOption(
                      label: 'Público',
                      subtitle: 'Todos los estudiantes',
                      value: 0,
                      groupValue: _visibility,
                      onChanged: (v) => setState(() => _visibility = v),
                    ),
                    _VisibilityOption(
                      label: 'Solo verificados',
                      subtitle: 'Estudiantes con correo verificado',
                      value: 1,
                      groupValue: _visibility,
                      onChanged: (v) => setState(() => _visibility = v),
                    ),
                    _VisibilityOption(
                      label: 'Oculto',
                      subtitle: 'No apareces en sugerencias',
                      value: 2,
                      groupValue: _visibility,
                      onChanged: (v) => setState(() => _visibility = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Información visible',
            children: [
              ToggleTile(
                icon: Icons.school_outlined,
                label: 'Mostrar semestre',
                value: _showSemester,
                onChanged: (v) => setState(() => _showSemester = v),
              ),
              ToggleTile(
                icon: Icons.book_outlined,
                label: 'Mostrar carrera',
                value: _showProgram,
                onChanged: (v) => setState(() => _showProgram = v),
              ),
              ToggleTile(
                icon: Icons.cake_outlined,
                label: 'Mostrar edad',
                value: _showAge,
                onChanged: (v) => setState(() => _showAge = v),
              ),
              ToggleTile(
                icon: Icons.tag,
                label: 'Compartir intereses',
                subtitle: 'Mejora las sugerencias de compatibilidad',
                value: _shareInterests,
                onChanged: (v) => setState(() => _shareInterests = v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          SectionCard(
            title: 'Contacto',
            children: [
              ToggleTile(
                icon: Icons.chat_bubble_outline,
                label: 'Recibir mensajes',
                subtitle: 'Solo de tus conexiones actuales',
                value: _allowMessages,
                onChanged: (v) => setState(() => _allowMessages = v),
              ),
              ToggleTile(
                icon: Icons.group_outlined,
                label: 'Invitaciones a grupos',
                value: _allowGroupInvites,
                onChanged: (v) => setState(() => _allowGroupInvites = v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VisibilityOption extends StatelessWidget {
  const _VisibilityOption({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final int value;
  final int groupValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? cs.primary : cs.outlineVariant,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodyMd(isSelected ? cs.primary : cs.onSurface)),
                  Text(subtitle, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
