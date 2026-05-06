import 'dart:convert';

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isMe': isMe,
    'time': time,
  };

  String toJsonString() => jsonEncode(toJson());

  factory ConversationMessage.fromJson(Map<String, dynamic> json) =>
      ConversationMessage(
        id: json['id'] as String,
        text: json['text'] as String,
        isMe: json['isMe'] as bool,
        time: json['time'] as String,
      );

  factory ConversationMessage.fromJsonString(String s) =>
      ConversationMessage.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
