import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/network_texture.dart';
import '../../core/widgets/t_button.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/student.dart';

class MatchSuccessScreen extends StatefulWidget {
  const MatchSuccessScreen({super.key, required this.student});
  final Student student;

  @override
  State<MatchSuccessScreen> createState() => _MatchSuccessScreenState();
}

class _MatchSuccessScreenState extends State<MatchSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _slideUp = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final me = MockData.currentUser;
    final other = widget.student;

    return Scaffold(
      backgroundColor: cs.surfaceDim,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Network texture overlay
          NetworkTexture(opacity: 0.06),
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space6,
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    ScaleTransition(
                      scale: _scale,
                      child: _AvatarPair(me: me, other: other),
                    ),
                    const SizedBox(height: AppSpacing.space6),
                    AnimatedBuilder(
                      animation: _slideUp,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _slideUp.value),
                        child: child,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '¡Conexión!',
                            style: AppTextStyles.headlineLg(cs.onSurface),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.space3),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: Text(
                              'Tú y ${other.firstName} han hecho match.\n¡Empieza la conversación!',
                              style: AppTextStyles.bodyLg(cs.onSurfaceVariant),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 3),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: TButton(
                        label: 'Iniciar conversación',
                        onPressed: () =>
                            Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRouter.conversation,
                          (r) =>
                              r.settings.name == AppRouter.discover ||
                              r.settings.name == AppRouter.connections,
                          arguments: other,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: TButton(
                        label: 'Seguir explorando',
                        variant: TButtonVariant.secondary,
                        onPressed: () => Navigator.of(context).popUntil(
                          (r) =>
                              r.settings.name == AppRouter.discover ||
                              r.settings.name == AppRouter.connections,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space6),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarPair extends StatelessWidget {
  const _AvatarPair({required this.me, required this.other});
  final Student me;
  final Student other;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 112,
      width: 172,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(left: 0, child: _AvatarCircle(student: me, size: 96)),
          Positioned(right: 0, child: _AvatarCircle(student: other, size: 96)),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.surfaceDim,
              shape: BoxShape.circle,
              border: Border.all(color: cs.surfaceDim, width: 2),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.ctaGradient(),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.favorite,
                color: AppColors.lightOnPrimary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.student, required this.size});
  final Student student;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            HSLColor.fromAHSL(1.0, student.hue, 0.45, 0.72).toColor(),
            HSLColor.fromAHSL(
              1.0,
              (student.hue + 30) % 360,
              0.55,
              0.42,
            ).toColor(),
          ],
        ),
        border: Border.all(color: cs.surface, width: 4),
      ),
      alignment: Alignment.center,
      child: Text(
        student.initials,
        style: AppTextStyles.headlineSm(Colors.white),
      ),
    );
  }
}
