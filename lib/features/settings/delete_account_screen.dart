import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/confirm_modal.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_text_field.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  int _reason = -1;
  final _confirmCtrl = TextEditingController();
  bool _isDeleting = false;

  static const _reasons = [
    'Ya no lo utilizo',
    'Encontré lo que buscaba',
    'Problemas técnicos',
    'Preocupaciones de privacidad',
    'Otro',
  ];

  @override
  void dispose() {
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (_reason < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un motivo para continuar')),
      );
      return;
    }
    if (_confirmCtrl.text.trim() != 'ELIMINAR') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe ELIMINAR para confirmar')),
      );
      return;
    }

    final ok = await ConfirmModal.show(
      context,
      title: 'Última confirmación',
      message:
          'Tu cuenta y todos tus datos serán eliminados permanentemente. Esta acción no se puede deshacer.',
      confirmLabel: 'Eliminar mi cuenta',
      cancelLabel: 'Cancelar',
      destructive: true,
    );
    if (ok != true || !mounted) return;

    setState(() => _isDeleting = true);
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.welcome, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const TAppBar(title: 'Eliminar cuenta'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space6,
          AppSpacing.space4,
          AppSpacing.space6,
          AppSpacing.space10,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.space4),
            decoration: BoxDecoration(
              color: cs.errorContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: cs.error, size: 20),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: Text(
                    'Esta acción es permanente e irreversible.',
                    style: AppTextStyles.bodyMd(cs.onErrorContainer),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space6),
          Text(
            'Motivo de cancelación',
            style: AppTextStyles.titleMd(cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.space3),
          ...List.generate(_reasons.length, (i) {
            return InkWell(
              onTap: () => setState(() => _reason = i),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.space3,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _reason == i ? cs.error : cs.outlineVariant,
                          width: _reason == i ? 6 : 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space3),
                    Text(
                      _reasons[i],
                      style: AppTextStyles.bodyMd(cs.onSurface),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.space6),
          TTextField(
            controller: _confirmCtrl,
            label: 'Confirmación',
            hint: 'Escribe ELIMINAR para continuar',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            'Escribe exactamente "ELIMINAR" en mayúsculas.',
            style: AppTextStyles.labelSm(cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.space8),
          TButton(
            label: 'Eliminar mi cuenta',
            onPressed: _isDeleting ? null : _delete,
            isLoading: _isDeleting,
          ),
        ],
      ),
    );
  }
}
