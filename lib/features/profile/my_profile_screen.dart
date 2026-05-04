import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_chip.dart';
import '../../data/mock/mock_data.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = MockData.currentUser;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: !embedded,
            expandedHeight: 280,
            pinned: true,
            title: Text('Mi perfil', style: AppTextStyles.titleMd(cs.onSurface)),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.of(context).pushNamed(AppRouter.settingsMain),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.avatarGradient(user.hue),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, cs.surface],
                          stops: const [0.55, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.space5,
                    left: AppSpacing.space5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: AppTextStyles.headlineSm(cs.onSurface),
                        ),
                        Text(
                          '${user.program} · Sem. ${user.semester}',
                          style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.space4,
                    right: AppSpacing.space5,
                    child: _EditButton(),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.space5, AppSpacing.space5, AppSpacing.space5, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _StatRow(user: user),
                const SizedBox(height: AppSpacing.space5),
                Text('Bio', style: AppTextStyles.titleMd(cs.onSurface)),
                const SizedBox(height: AppSpacing.space3),
                Text(user.bio, style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
                const SizedBox(height: AppSpacing.space5),
                Text('Intereses', style: AppTextStyles.titleMd(cs.onSurface)),
                const SizedBox(height: AppSpacing.space3),
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space2,
                  children: user.interests.map((i) => TChip(label: i, selected: true)).toList(),
                ),
                const SizedBox(height: AppSpacing.space5),
                _InfoRow(icon: Icons.school_outlined, label: 'Universidad', value: 'Anáhuac Oaxaca'),
                const SizedBox(height: AppSpacing.space3),
                _InfoRow(icon: Icons.location_on_outlined, label: 'Ciudad', value: 'Oaxaca de Juárez'),
                const SizedBox(height: AppSpacing.space3),
                _InfoRow(icon: Icons.access_time_outlined, label: 'En Trama desde', value: 'Mayo 2026'),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space3, vertical: AppSpacing.space2),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined, size: 16, color: cs.onSurface),
            const SizedBox(width: AppSpacing.space1),
            Text('Editar', style: AppTextStyles.labelSm(cs.onSurface)),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stats = [
      ('Matches', '8'),
      ('Conexiones', '14'),
      ('Chats activos', '5'),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: stats.map((s) {
          return Expanded(
            child: Column(
              children: [
                Text(s.$2, style: AppTextStyles.headlineSm(cs.primary)),
                Text(s.$1, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: cs.onSurfaceVariant),
        const SizedBox(width: AppSpacing.space3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
            Text(value, style: AppTextStyles.bodyMd(cs.onSurface)),
          ],
        ),
      ],
    );
  }
}
