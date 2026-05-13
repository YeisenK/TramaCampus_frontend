import 'package:flutter/material.dart';

import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/trama_mark.dart';
import '../../data/repositories/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    final email = _emailCtrl.text.trim();
    final pwd = _pwdCtrl.text;
    final confirm = _confirmCtrl.text;
    if (pwd != confirm) {
      setState(() {
        _loading = false;
        _error = 'Las contraseñas no coinciden';
      });
      return;
    }
    final result = await AuthRepository.instance
        .register(email: email, password: pwd);
    if (!mounted) return;
    if (!result.isOk) {
      setState(() {
        _loading = false;
        _error = result.error;
      });
      return;
    }
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRouter.quickProfileSetup, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.space6,
          MediaQuery.of(context).padding.top + AppSpacing.space5,
          AppSpacing.space6,
          AppSpacing.space7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(height: AppSpacing.space4),
            const TramaMark(size: 44),
            const SizedBox(height: AppSpacing.space5),
            Text('Crear cuenta', style: AppTextStyles.headlineMd(cs.onSurface)),
            const SizedBox(height: AppSpacing.space2),
            Text(
              'Solo necesitamos un correo y una contraseña para empezar.',
              style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.space6),
            _Field(
              label: 'Correo',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              cs: cs,
            ),
            const SizedBox(height: AppSpacing.space4),
            _Field(
              label: 'Contraseña',
              controller: _pwdCtrl,
              obscure: _obscure1,
              cs: cs,
              suffix: IconButton(
                icon: Icon(
                  _obscure1 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                  color: cs.onSurfaceVariant,
                ),
                onPressed: () => setState(() => _obscure1 = !_obscure1),
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            _Field(
              label: 'Confirmar contraseña',
              controller: _confirmCtrl,
              obscure: _obscure2,
              cs: cs,
              suffix: IconButton(
                icon: Icon(
                  _obscure2 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                  color: cs.onSurfaceVariant,
                ),
                onPressed: () => setState(() => _obscure2 = !_obscure2),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.space4),
              Text(_error!, style: AppTextStyles.bodySm(cs.error)),
            ],
            const SizedBox(height: AppSpacing.space6),
            TButton(
              label: _loading ? 'Creando…' : 'Crear cuenta',
              onPressed: _loading ? null : _submit,
              icon: _loading ? null : Icons.arrow_forward,
            ),
            const SizedBox(height: AppSpacing.space4),
            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed(AppRouter.login),
                child: Text(
                  '¿Ya tenés cuenta? Iniciar sesión',
                  style: AppTextStyles.bodySm(cs.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.cs,
    this.keyboardType,
    this.obscure = false,
    this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final ColorScheme cs;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
        const SizedBox(height: AppSpacing.space2),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          style: AppTextStyles.bodyMd(cs.onSurface),
          decoration: InputDecoration(
            suffixIcon: suffix,
            filled: true,
            fillColor: cs.surfaceContainerHigh,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space4,
              vertical: AppSpacing.space4,
            ),
          ),
        ),
      ],
    );
  }
}
