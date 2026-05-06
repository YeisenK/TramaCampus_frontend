import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_chip.dart';
import '../../core/widgets/t_schedule_grid.dart';
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
            expandedHeight: 320,
            pinned: true,
            title: Text(
              'Mi perfil',
              style: AppTextStyles.titleMd(cs.onSurface),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRouter.settingsMain),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: RepaintBoundary(child: _HeroPhoto(user: user)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.space5,
              AppSpacing.space5,
              AppSpacing.space5,
              120,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _StatsRow(),
                const SizedBox(height: AppSpacing.space5),
                Text('Bio', style: AppTextStyles.titleMd(cs.onSurface)),
                const SizedBox(height: AppSpacing.space3),
                Text(
                  user.bio,
                  style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.space5),
                Text('Intereses', style: AppTextStyles.titleMd(cs.onSurface)),
                const SizedBox(height: AppSpacing.space3),
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space2,
                  children: user.interests
                      .map((i) => TChip(label: i, selected: true))
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.space5),
                Text(
                  'Disponibilidad semanal',
                  style: AppTextStyles.titleMd(cs.onSurface),
                ),
                const SizedBox(height: AppSpacing.space3),
                TScheduleGrid(schedule: _demoSchedule()),
                const SizedBox(height: AppSpacing.space5),
                _InfoRow(
                  icon: Icons.school_outlined,
                  label: 'Universidad',
                  value: 'Anáhuac Oaxaca',
                ),
                const SizedBox(height: AppSpacing.space3),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Ciudad',
                  value: 'Oaxaca de Juárez',
                ),
                const SizedBox(height: AppSpacing.space3),
                _InfoRow(
                  icon: Icons.access_time_outlined,
                  label: 'En Trama desde',
                  value: 'Mayo 2026',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<List<ScheduleState>> _demoSchedule() {
    return List.generate(7, (day) {
      return List.generate(8, (hour) {
        if (day < 5 && hour >= 2 && hour <= 5) return ScheduleState.busy;
        if (day < 5 && (hour == 1 || hour == 6)) return ScheduleState.maybe;
        return ScheduleState.free;
      });
    });
  }
}

class _HeroPhoto extends StatelessWidget {
  const _HeroPhoto({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Positioned.fill(
          child: user.photoUrl != null
              ? Image(
                  image: user.photoUrl!.startsWith('assets/')
                      ? AssetImage(user.photoUrl!) as ImageProvider
                      : NetworkImage(user.photoUrl!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, _) => Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.avatarGradient(user.hue as double),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.avatarGradient(user.hue as double),
                  ),
                ),
        ),
        // Top vignette — keeps photo edge visible against nav bar on light themes
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: const Alignment(0, 0.1),
                colors: [
                  Colors.black.withValues(alpha: 0.28),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom fade into surface
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  cs.surface.withValues(alpha: 0.55),
                  cs.surface,
                ],
                stops: const [0.4, 0.7, 1.0],
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
                user.name as String,
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
    );
  }
}

class _EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRouter.editProfile),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppColors.glassBlurSigma / 2,
            sigmaY: AppColors.glassBlurSigma / 2,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space3,
              vertical: AppSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(AppRadius.pill),
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
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ghostDivider = isDark
        ? AppColors.darkOutlineGhost
        : AppColors.lightOutlineGhost;
    final stats = [('Matches', '8'), ('Conexiones', '14'), ('Chats', '5')];
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            for (int i = 0; i < stats.length; i++) ...[
              if (i > 0)
                VerticalDivider(width: 1, thickness: 1, color: ghostDivider),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stats[i].$2,
                      style: AppTextStyles.headlineSm(cs.primary),
                    ),
                    Text(
                      stats[i].$1,
                      style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
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
