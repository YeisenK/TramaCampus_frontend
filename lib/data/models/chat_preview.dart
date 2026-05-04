class ChatPreview {
  const ChatPreview({
    required this.studentId,
    required this.studentName,
    required this.hue,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
  });

  final String studentId;
  final String studentName;
  final double hue;
  final String lastMessage;
  final String time;
  final int unreadCount;

  String get initials {
    final parts = studentName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return parts[0][0];
  }
}
