class ConversationMessage {
  const ConversationMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
  });

  final String id;
  final String text;
  final bool isMe;
  final String time;
}
