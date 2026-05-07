import 'package:flutter/material.dart';
import '../../../core/constants/app_info.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/t_app_bar.dart';
import '../../../core/widgets/t_button.dart';
import '../../../core/widgets/t_text_field.dart';

enum ArcoType { access, rectification, cancellation, opposition }

extension ArcoTypeLabel on ArcoType {
  String get label {
    switch (this) {
      case ArcoType.access:
        return 'Acceso';
      case ArcoType.rectification:
        return 'Rectificación';
      case ArcoType.cancellation:
        return 'Cancelación';
      case ArcoType.opposition:
        return 'Oposición';
    }
  }

  String get description {
    switch (this) {
      case ArcoType.access:
        return 'Quiero saber qué datos tienes sobre mí y para qué los usas.';
      case ArcoType.rectification:
        return 'Quiero corregir datos incorrectos o desactualizados.';
      case ArcoType.cancellation:
        return 'Quiero que elimines algunos o todos mis datos personales.';
      case ArcoType.opposition:
        return 'Quiero oponerme al tratamiento de mis datos para ciertos fines.';
    }
  }

  IconData get icon {
    switch (this) {
      case ArcoType.access:
        return Icons.visibility_outlined;
      case ArcoType.rectification:
        return Icons.edit_outlined;
      case ArcoType.cancellation:
        return Icons.delete_outline;
      case ArcoType.opposition:
        return Icons.block_outlined;
    }
  }
}

class ArcoRequestArgs {
  const ArcoRequestArgs({
    required this.type,
    required this.detail,
    required this.additionalContext,
  });
  final ArcoType type;
  final String detail;
  final String additionalContext;
}

class ArcoRequestScreen extends StatefulWidget {
  const ArcoRequestScreen({super.key});

  @override
  State<ArcoRequestScreen> createState() => _ArcoRequestScreenState();
}

class _ArcoRequestScreenState extends State<ArcoRequestScreen> {
  ArcoType? _selectedType;
  final _detailController = TextEditingController();
  final _contextController = TextEditingController();

  @override
  void dispose() {
    _detailController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    if (_selectedType == null) return false;
    if (_selectedType == ArcoType.access) return true;
    return _detailController.text.trim().isNotEmpty;
  }

  String get _detailHint {
    switch (_selectedType) {
      case ArcoType.rectification:
        return 'Describe qué datos deseas corregir y cuál es la información correcta.';
      case ArcoType.cancellation:
        return 'Describe qué datos deseas que eliminemos (o indica "todos mis datos").';
      case ArcoType.opposition:
        return 'Indica a qué finalidad del tratamiento te opones y los motivos.';
      default:
        return '';
    }
  }

  void _continue() {
    if (!_canContinue) return;
    Navigator.of(context).pushNamed(
      AppRouter.arcoRequestConfirm,
      arguments: ArcoRequestArgs(
        type: _selectedType!,
        detail: _detailController.text.trim(),
        additionalContext: _contextController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const TAppBar(title: 'Solicitud ARCO'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.edgePadding,
          AppSpacing.space4,
          AppSpacing.edgePadding,
          120,
        ),
        children: [
          Text(
            'Elige el derecho que deseas ejercer',
            style: AppTextStyles.titleMd(cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            'Tu solicitud será enviada por correo a ${AppInfo.arcoEmail}. '
            'Respondemos en 20 días hábiles conforme al artículo 32 de la LFPDPPP.',
            style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.space5),
          ...ArcoType.values.map(
            (type) => _TypeCard(
              type: type,
              selected: _selectedType == type,
              onTap: () => setState(() {
                _selectedType = type;
                _detailController.clear();
              }),
            ),
          ),
          if (_selectedType != null && _selectedType != ArcoType.access) ...[
            const SizedBox(height: AppSpacing.space5),
            Text(
              'Describe tu solicitud',
              style: AppTextStyles.titleMd(cs.onSurface),
            ),
            const SizedBox(height: AppSpacing.space3),
            TTextField(
              controller: _detailController,
              label: 'Descripción',
              hint: _detailHint,
              maxLines: 5,
              onChanged: (_) => setState(() {}),
            ),
          ],
          const SizedBox(height: AppSpacing.space5),
          Text(
            'Información adicional (opcional)',
            style: AppTextStyles.titleMd(cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            'Cualquier otro elemento que ayude a localizar tus datos '
            '(ej. correo anterior, nombre de usuario antiguo).',
            style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.space3),
          TTextField(
            controller: _contextController,
            label: 'Elemento adicional',
            hint: 'Correo anterior, nombre de usuario antiguo, etc.',
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.space7),
          SizedBox(
            width: double.infinity,
            child: TButton(
              label: 'Continuar',
              onPressed: _canContinue ? _continue : null,
              icon: Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final ArcoType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: AppSpacing.space3),
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: selected
              ? cs.primaryContainer.withValues(alpha: 0.35)
              : cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected
                ? cs.primary.withValues(alpha: 0.5)
                : cs.outlineVariant.withValues(alpha: 0.4),
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected
                    ? cs.primary.withValues(alpha: 0.12)
                    : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                type.icon,
                size: 20,
                color: selected ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Derecho de ${type.label}',
                    style: AppTextStyles.titleMd(cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.space1),
                  Text(
                    type.description,
                    style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, size: 20, color: cs.primary),
          ],
        ),
      ),
    );
  }
}
