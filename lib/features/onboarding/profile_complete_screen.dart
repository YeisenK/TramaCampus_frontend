import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/network_texture.dart';
import '../../core/widgets/t_button.dart';
import '../../data/repositories/onboarding_draft_repository.dart';

class ProfileCompleteScreen extends StatefulWidget {
  const ProfileCompleteScreen({super.key});

  @override
  State<ProfileCompleteScreen> createState() => _ProfileCompleteScreenState();
}

class _ProfileCompleteScreenState extends State<ProfileCompleteScreen> {
  String _displayName = '';
  String _username = '';
  double _hue = 220;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final draft = await OnboardingDraftRepository.instance.load();
    if (!mounted) return;
    final first = draft.firstName ?? '';
    final last = draft.lastName ?? '';
    final username = draft.username ?? '';
    setState(() {
      _displayName = [first, last].where((s) => s.isNotEmpty).join(' ');
      _username = username.isNotEmpty ? '@$username' : '';
      _hue =
          (first.isNotEmpty ? first.codeUnitAt(0).toDouble() * 1.4 : 220) % 360;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final initials = _displayName.isNotEmpty
        ? _displayName
              .split(' ')
              .where((w) => w.isNotEmpty)
              .map((w) => w[0].toUpperCase())
              .take(2)
              .join()
        : '?';
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          NetworkTexture(opacity: 0.04),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space6,
              ),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  SizedBox(
                    height: 104,
                    width: 172,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 0,
                          child: _AvatarCircle(
                            hue: _hue,
                            initials: initials,
                            size: 96,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: _AvatarCircle(
                            hue: (_hue + 140) % 360,
                            initials: '?',
                            size: 96,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space6),
                  Text(
                    '¡Perfil creado!',
                    style: AppTextStyles.headlineLg(cs.onSurface),
                    textAlign: TextAlign.center,
                  ),
                  if (_displayName.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      _displayName,
                      style: AppTextStyles.titleMd(cs.onSurface),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (_username.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.space1),
                    Text(
                      _username,
                      style: AppTextStyles.bodyMd(cs.primary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.space3),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Text(
                      'Ya puedes empezar a conectar con estudiantes de tu campus.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLg(cs.onSurfaceVariant),
                    ),
                  ),
                  const Spacer(flex: 3),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: TButton(
                      label: 'Completar mi perfil',
                      onPressed: () {
                        final nav = Navigator.of(context);
                        nav.pushNamedAndRemoveUntil(
                          AppRouter.discover,
                          (route) => false,
                        );
                        nav.pushNamed(AppRouter.editProfile);
                      },
                      icon: Icons.edit_outlined,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: TButton(
                      label: 'Ir al feed',
                      variant: TButtonVariant.secondary,
                      onPressed: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRouter.discover,
                            (route) => false,
                          ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({
    required this.hue,
    required this.initials,
    required this.size,
  });

  final double hue;
  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.avatarGradient(hue),
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 4,
        ),
      ),
      alignment: Alignment.center,
      child: Text(initials, style: AppTextStyles.headlineSm(Colors.white)),
    );
  }
}
