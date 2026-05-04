import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/compatibility_card.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_chip.dart';
import '../../data/models/student.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key, required this.student});
  final Student student;

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final s = widget.student;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            automaticallyImplyLeading: false,
            leading: _GlassButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () => Navigator.of(context).pop(),
            ),
            actions: [
              _GlassButton(
                icon: _isSaved ? Icons.bookmark : Icons.bookmark_border,
                onTap: () => setState(() => _isSaved = !_isSaved),
              ),
              const SizedBox(width: AppSpacing.space2),
              _GlassButton(
                icon: Icons.more_vert,
                onTap: () {},
              ),
              const SizedBox(width: AppSpacing.space2),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.avatarGradient(s.hue),
                      ),
                      alignment: Alignment.center,
                      child: Text(s.initials, style: AppTextStyles.display(Colors.white.withValues(alpha: 0.8))),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, cs.surface],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.space5,
                    left: AppSpacing.space5,
                    right: AppSpacing.space5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${s.name}, ${s.age}', style: AppTextStyles.headlineMd(cs.onSurface)),
                        const SizedBox(height: AppSpacing.space1),
                        Text('${s.program} · Sem. ${s.semester}', style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.space5, AppSpacing.space5, AppSpacing.space5, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (s.bio.isNotEmpty) ...[
                  Text('Sobre mí', style: AppTextStyles.titleMd(cs.onSurface)),
                  const SizedBox(height: AppSpacing.space3),
                  Text(s.bio, style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
                  const SizedBox(height: AppSpacing.space5),
                ],
                if (s.interests.isNotEmpty) ...[
                  Text('Intereses', style: AppTextStyles.titleMd(cs.onSurface)),
                  const SizedBox(height: AppSpacing.space3),
                  Wrap(
                    spacing: AppSpacing.space2,
                    runSpacing: AppSpacing.space2,
                    children: s.interests.map((i) => TChip(label: i)).toList(),
                  ),
                  const SizedBox(height: AppSpacing.space5),
                ],
                if (s.compatibilityScore > 0)
                  CompatibilityCard(
                    score: s.compatibilityScore,
                    rows: [
                      CompatibilityRow(
                        icon: Icons.school_outlined,
                        label: 'Académico',
                        title: s.program,
                        detail: 'Semestre ${s.semester}',
                        isStrong: true,
                      ),
                      CompatibilityRow(
                        icon: Icons.favorite_border,
                        label: 'Intereses',
                        title: 'Varios en común',
                        chips: s.interests.take(3).toList(),
                        isStrong: s.interests.length > 3,
                      ),
                      CompatibilityRow(
                        icon: Icons.flag_outlined,
                        label: 'Objetivo',
                        title: switch (s.intent) {
                          _ when s.intent.name == 'estudio' => 'Estudiar juntos',
                          _ when s.intent.name == 'amistad' => 'Hacer amigos',
                          _ => 'Conexión personal',
                        },
                      ),
                    ],
                  ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _ActionBar(
        student: widget.student,
        onMatch: () => Navigator.of(context).pushNamed(
          AppRouter.matchSuccess,
          arguments: widget.student,
        ),
        onPass: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 20, color: cs.onSurface),
          ),
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.student, required this.onMatch, required this.onPass});
  final Student student;
  final VoidCallback onMatch;
  final VoidCallback onPass;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.space5, AppSpacing.space4, AppSpacing.space5, 0),
          decoration: BoxDecoration(
            color: cs.surface.withValues(alpha: 0.85),
            border: Border(top: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5))),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TButton(
                    label: 'Pasar',
                    variant: TButtonVariant.secondary,
                    onPressed: onPass,
                  ),
                ),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  flex: 2,
                  child: TButton(
                    label: 'Conectar',
                    onPressed: onMatch,
                    icon: Icons.explore_outlined,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
