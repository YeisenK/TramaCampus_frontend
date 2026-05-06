import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_button.dart';
import '../../data/mock/mock_data.dart';
import '../../data/repositories/onboarding_draft_repository.dart';

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  String? _initials;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final draft = await OnboardingDraftRepository.instance.load();
    if (!mounted) return;
    final first = draft.firstName ?? MockData.currentProfile.base.firstName;
    final last = draft.lastName ?? MockData.currentProfile.base.lastName;
    setState(() {
      _initials = _toInitials(first, last);
    });
  }

  String _toInitials(String first, String last) {
    final f = first.isNotEmpty ? first[0].toUpperCase() : '';
    final l = last.isNotEmpty ? last[0].toUpperCase() : '';
    return '$f$l';
  }

  Future<void> _skip() async {
    if (!mounted) return;
    Navigator.of(context).pushNamed(AppRouter.profileComplete);
  }

  void _uploadPhoto() {
    // Photo picker — no-op in mock; navigates forward.
    _skip();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space6),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.space6),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Icon(Icons.arrow_back_ios_new,
                      size: 20, color: cs.onSurface),
                ),
              ),
              const Spacer(flex: 2),
              // Avatar placeholder
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.avatarGradient(220),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials ?? '',
                      style: AppTextStyles.headlineLg(Colors.white),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.primary,
                    ),
                    child: const Icon(Icons.add_a_photo_outlined,
                        size: 18, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space6),
              Text('Agrega una foto',
                  style: AppTextStyles.headlineSm(cs.onSurface),
                  textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.space3),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  'Los perfiles con foto reciben más conexiones. Puedes agregarla ahora o después.',
                  style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 3),
              TButton(
                label: 'Subir foto',
                onPressed: _uploadPhoto,
                icon: Icons.upload_outlined,
              ),
              const SizedBox(height: AppSpacing.space3),
              TextButton(
                onPressed: _skip,
                child: Text(
                  'Omitir por ahora',
                  style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                ),
              ),
              const SizedBox(height: AppSpacing.space6),
            ],
          ),
        ),
      ),
    );
  }
}
