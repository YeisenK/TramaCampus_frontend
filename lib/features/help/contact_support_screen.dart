import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_text_field.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  int _typeIndex = 0;
  bool _isSending = false;

  static const _types = [
    'Problema técnico',
    'Pregunta general',
    'Solicitud de información',
    'Otro',
  ];

  @override
  void dispose() {
    _descCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSending = true);
    if (!mounted) return;
    setState(() => _isSending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mensaje enviado. Te responderemos pronto.'),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const TAppBar(title: 'Contactar soporte'),
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
            Text(
              'Tipo de consulta',
              style: AppTextStyles.labelSm(cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.space2),
            DropdownButtonFormField<int>(
              initialValue: _typeIndex,
              decoration: InputDecoration(
                filled: true,
                fillColor: cs.surfaceContainerLowest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide(color: cs.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide(color: cs.outlineVariant),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space4,
                  vertical: AppSpacing.space4,
                ),
              ),
              items: _types
                  .asMap()
                  .entries
                  .map(
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _typeIndex = v ?? 0),
            ),
            const SizedBox(height: AppSpacing.space5),
            TTextField(
              controller: _descCtrl,
              label: 'Descripción',
              hint: 'Describe tu consulta con el mayor detalle posible...',
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              validator: (v) => (v == null || v.trim().length < 10)
                  ? 'Mínimo 10 caracteres'
                  : null,
            ),
            const SizedBox(height: AppSpacing.space5),
            TTextField(
              controller: _emailCtrl,
              label: 'Correo de respuesta',
              hint: 'tu@correo.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: (v) => (v == null || !v.contains('@'))
                  ? 'Ingresa un correo válido'
                  : null,
            ),
            const SizedBox(height: AppSpacing.space8),
            TButton(
              label: 'Enviar mensaje',
              onPressed: _isSending ? null : _send,
              isLoading: _isSending,
            ),
          ],
        ),
      ),
    );
  }
}
