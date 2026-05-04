import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_text_field.dart';
import '../../data/models/student.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key, this.reportedStudent});

  final Student? reportedStudent;

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  int _typeIndex = 0;
  bool _isSending = false;

  static const _types = [
    'Error en la aplicación',
    'Contenido inapropiado',
    'Acoso o comportamiento ofensivo',
    'Perfil falso o suplantación',
    'Spam',
    'Otro',
  ];

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSending = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isSending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reporte enviado. Gracias por ayudarnos a mejorar.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const TAppBar(title: 'Reportar problema'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space6,
            AppSpacing.space4,
            AppSpacing.space6,
            AppSpacing.space10,
          ),
          children: [
            if (widget.reportedStudent != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.space4),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: cs.onSurfaceVariant, size: 20),
                    const SizedBox(width: AppSpacing.space3),
                    Text(
                      'Reportando a: ${widget.reportedStudent!.name}',
                      style: AppTextStyles.bodyMd(cs.onSurface),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.space5),
            ],
            Text('Tipo de problema', style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.space3),
            ..._types.asMap().entries.map((e) {
              final isSelected = e.key == _typeIndex;
              return InkWell(
                onTap: () => setState(() => _typeIndex = e.key),
                borderRadius: BorderRadius.circular(AppRadius.sm),
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
                      Text(e.value, style: AppTextStyles.bodyMd(cs.onSurface)),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: AppSpacing.space5),
            TTextField(
              controller: _descCtrl,
              label: 'Descripción (opcional)',
              hint: 'Proporciona más detalles sobre el problema...',
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: AppSpacing.space8),
            TButton(
              label: 'Enviar reporte',
              onPressed: _isSending ? null : _send,
              isLoading: _isSending,
            ),
          ],
        ),
      ),
    );
  }
}
