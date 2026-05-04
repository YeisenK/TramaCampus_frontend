import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/compatibility_card.dart';
import '../../core/widgets/confirm_modal.dart';
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

  void _showMoreMenu(BuildContext context, Student s) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MoreMenuSheet(
        student: s,
        onReport: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(AppRouter.reportProblem, arguments: s);
        },
        onBlock: () async {
          Navigator.of(context).pop();
          final ok = await ConfirmModal.show(
            context,
            title: 'Bloquear usuario',
            message: '${s.firstName} no podrá ver tu perfil ni contactarte.',
            confirmLabel: 'Bloquear',
            destructive: true,
          );
          if (ok == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${s.firstName} ha sido bloqueado')),
            );
            Navigator.of(context).pop();
          }
        },
        onShare: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Próximamente disponible')),
          );
        },
      ),
    );
  }

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
                onTap: () => _showMoreMenu(context, s),
              ),
              const SizedBox(width: AppSpacing.space2),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    child: s.photoUrl != null
                        ? Image(
                            image: s.photoUrl!.startsWith('assets/')
                                ? AssetImage(s.photoUrl!) as ImageProvider
                                : NetworkImage(s.photoUrl!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, _) => Container(
                              decoration: BoxDecoration(gradient: AppColors.avatarGradient(s.hue)),
                              alignment: Alignment.center,
                              child: Text(s.initials, style: AppTextStyles.display(Colors.white.withValues(alpha: 0.8))),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(gradient: AppColors.avatarGradient(s.hue)),
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

class _MoreMenuSheet extends StatelessWidget {
  const _MoreMenuSheet({
    required this.student,
    required this.onReport,
    required this.onBlock,
    required this.onShare,
  });

  final Student student;
  final VoidCallback onReport;
  final VoidCallback onBlock;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      child: Container(
        color: cs.surfaceContainerLowest,
        padding: EdgeInsets.fromLTRB(
          AppSpacing.space6,
          AppSpacing.space5,
          AppSpacing.space6,
          AppSpacing.space6 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space5),
            _MenuAction(
              icon: Icons.flag_outlined,
              label: 'Reportar a ${student.firstName}',
              onTap: onReport,
            ),
            const Divider(height: 1),
            _MenuAction(
              icon: Icons.block_outlined,
              label: 'Bloquear a ${student.firstName}',
              isDestructive: true,
              onTap: onBlock,
            ),
            const Divider(height: 1),
            _MenuAction(
              icon: Icons.share_outlined,
              label: 'Compartir perfil',
              onTap: onShare,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuAction extends StatelessWidget {
  const _MenuAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = isDestructive ? cs.error : cs.onSurface;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 20, color: color),
      title: Text(label, style: AppTextStyles.bodyMd(color)),
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.space1),
    );
  }
}
