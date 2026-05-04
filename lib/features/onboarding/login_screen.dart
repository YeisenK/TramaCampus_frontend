import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/trama_mark.dart';

const _demoEmail = 'sofia.r@anahuac.mx';
const _demoPassword = 'trama2024';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: _demoEmail);
  final _passwordController = TextEditingController(text: _demoPassword);
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.discover, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Hero(cs: cs),
            _DemoBadge(cs: cs),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.space6, AppSpacing.space5,
                AppSpacing.space6, AppSpacing.space4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Field(
                    label: 'Correo institucional',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    cs: cs,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  _Field(
                    label: 'Contraseña',
                    controller: _passwordController,
                    obscure: _obscure,
                    cs: cs,
                    suffix: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20,
                        color: cs.onSurfaceVariant,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('¿Olvidaste tu contraseña?',
                          style: AppTextStyles.bodySm(cs.primary)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  TButton(
                    label: _loading ? 'Entrando…' : 'Iniciar sesión',
                    onPressed: _loading ? null : _login,
                    icon: _loading ? null : Icons.arrow_upward,
                  ),
                  const SizedBox(height: AppSpacing.space5),
                  Row(
                    children: [
                      Expanded(child: Divider(color: cs.outlineVariant.withValues(alpha: 0.5))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space3),
                        child: Text('o', style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
                      ),
                      Expanded(child: Divider(color: cs.outlineVariant.withValues(alpha: 0.5))),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  TButton(
                    label: 'Crear cuenta nueva',
                    variant: TButtonVariant.secondary,
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(AppRouter.selectUni, (_) => false),
                  ),
                  const SizedBox(height: AppSpacing.space7),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space6, 0, AppSpacing.space6, AppSpacing.space6,
      ),
      decoration: BoxDecoration(color: cs.surfaceContainerLowest),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space4),
            const TramaMark(size: 44),
            const SizedBox(height: AppSpacing.space5),
            Text('Bienvenida de vuelta', style: AppTextStyles.headlineMd(cs.onSurface)),
            const SizedBox(height: AppSpacing.space2),
            Text(
              'Ingresa con tu correo institucional verificado.',
              style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoBadge extends StatelessWidget {
  const _DemoBadge({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.space6, AppSpacing.space5, AppSpacing.space6, 0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space4,
        vertical: AppSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.key_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodySm(AppColors.primary),
                children: const [
                  TextSpan(
                    text: 'Cuenta demo — ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: '$_demoEmail  ·  $_demoPassword'),
                ],
              ),
            ),
          ),
        ],
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
