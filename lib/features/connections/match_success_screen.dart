import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
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
    final me = MockData.currentUser;
    final other = widget.student;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.ctaGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
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
                          '¡Conectaron!',
                          style: AppTextStyles.headlineLg(Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.space3),
                        Text(
                          'Tú y ${other.firstName} han hecho match.\n¡Empieza la conversación!',
                          style: AppTextStyles.bodyLg(
                            Colors.white.withValues(alpha: 0.85),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 3),
                  _WhiteButton(
                    label: 'Iniciar conversación',
                    onPressed: () =>
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRouter.conversation,
                          (r) => r.settings.name == AppRouter.discover,
                          arguments: other,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  TextButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).popUntil((r) => r.settings.name == AppRouter.discover),
                    child: Text(
                      'Seguir explorando',
                      style: AppTextStyles.bodyLg(
                        Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space6),
                ],
              ),
            ),
          ),
        ),
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
    return SizedBox(
      height: 140,
      width: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(left: 0, child: _AvatarCircle(student: me, size: 110)),
          Positioned(right: 0, child: _AvatarCircle(student: other, size: 110)),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.favorite,
              color: Color(0xFFE85A12),
              size: 24,
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
        border: Border.all(color: Colors.white, width: 3),
      ),
      alignment: Alignment.center,
      child: Text(
        student.initials,
        style: AppTextStyles.headlineSm(Colors.white),
      ),
    );
  }
}

class _WhiteButton extends StatelessWidget {
  const _WhiteButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: Text(label, style: AppTextStyles.titleMd(AppColors.primary)),
      ),
    );
  }
}
