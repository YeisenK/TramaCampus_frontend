enum NotificationType { match, request, group }

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isRead,
    this.hue = 240,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;
  final double hue;
}
