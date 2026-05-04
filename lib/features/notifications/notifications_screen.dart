import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/notification_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = MockData.notifications;
    final unread = notifications.where((n) => !n.isRead).toList();
    final read = notifications.where((n) => n.isRead).toList();

    return Scaffold(
      appBar: const TAppBar(title: 'Notificaciones'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        children: [
          if (unread.isNotEmpty) ...[
            _SectionHeader(label: 'Nuevas'),
            const SizedBox(height: AppSpacing.space2),
            ...unread.map((n) => _NotificationCard(item: n)),
            const SizedBox(height: AppSpacing.space4),
          ],
          if (read.isNotEmpty) ...[
            _SectionHeader(label: 'Anteriores'),
            const SizedBox(height: AppSpacing.space2),
            ...read.map((n) => _NotificationCard(item: n)),
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.space2,
        bottom: AppSpacing.space1,
      ),
      child: Text(label, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});
  final NotificationItem item;

  IconData get _icon => switch (item.type) {
    NotificationType.match => Icons.favorite,
    NotificationType.request => Icons.person_add_outlined,
    NotificationType.group => Icons.group_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space3),
      padding: const EdgeInsets.all(AppSpacing.space3),
      decoration: BoxDecoration(
        color: item.isRead
            ? cs.surfaceContainerLowest
            : cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: item.isRead
            ? null
            : Border.all(color: cs.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.avatarGradient(item.hue),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(_icon, size: 22, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppTextStyles.bodyMd(cs.onSurface).copyWith(
                          fontWeight: item.isRead
                              ? FontWeight.w400
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (!item.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: AppSpacing.space2),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space1),
                Text(
                  item.subtitle,
                  style: AppTextStyles.bodySm(cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.space1),
                Text(
                  item.time,
                  style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
