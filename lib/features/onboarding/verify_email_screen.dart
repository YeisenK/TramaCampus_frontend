import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/step_dots.dart';
import '../../core/widgets/t_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (_emailController.text.isNotEmpty) {
      setState(() => _sent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VerifyHeader(step: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.space5),
                children: [
                  if (!_sent) ...[
                    Text('Ingresa tu correo institucional', style: AppTextStyles.titleMd(cs.onSurface)),
                    const SizedBox(height: AppSpacing.space4),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'nombre@universidad.mx',
                        prefixIcon: Icon(Icons.language_outlined),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    TButton(
                      label: 'Enviar código de verificación',
                      onPressed: _sendCode,
                    ),
                  ] else ...[
                    _VerifyCodeEntry(
                      email: _emailController.text,
                      onVerified: () => Navigator.of(context).pushNamed(AppRouter.modalitySelect),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerifyHeader extends StatelessWidget {
  const _VerifyHeader({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: cs.surfaceDim,
      padding: const EdgeInsets.fromLTRB(AppSpacing.space5, AppSpacing.space6, AppSpacing.space5, AppSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back_ios_new, size: 20, color: cs.onSurface),
              ),
              const Spacer(),
              StepDots(totalSteps: 6, currentStep: step),
            ],
          ),
          const SizedBox(height: AppSpacing.space5),
          Text('Verificar correo', style: AppTextStyles.headlineSm(cs.onSurface)),
          const SizedBox(height: AppSpacing.space2),
          Text('Confirma que perteneces a tu universidad', style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _VerifyCodeEntry extends StatefulWidget {
  const _VerifyCodeEntry({required this.email, required this.onVerified});
  final String email;
  final VoidCallback onVerified;

  @override
  State<_VerifyCodeEntry> createState() => _VerifyCodeEntryState();
}

class _VerifyCodeEntryState extends State<_VerifyCodeEntry> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.space4),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Icon(Icons.mail_outline, color: cs.primary),
              const SizedBox(width: AppSpacing.space3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Código enviado a', style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
                  Text(widget.email, style: AppTextStyles.bodyMd(cs.onSurface)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space5),
        Text('Código de verificación', style: AppTextStyles.titleMd(cs.onSurface)),
        const SizedBox(height: AppSpacing.space3),
        TextField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineSm(cs.onSurface),
          decoration: const InputDecoration(
            hintText: '000000',
            counterText: '',
          ),
        ),
        const SizedBox(height: AppSpacing.space5),
        TButton(
          label: 'Verificar',
          onPressed: widget.onVerified,
        ),
        const SizedBox(height: AppSpacing.space3),
        Center(
          child: TextButton(
            onPressed: () {},
            child: Text('Reenviar código', style: AppTextStyles.bodyMd(cs.primary)),
          ),
        ),
      ],
    );
  }
}
