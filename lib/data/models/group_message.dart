import 'dart:convert';

class GroupMessage {
  const GroupMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    required this.senderName,
    this.senderHue = 0,
  });

  final String id;
  final String text;
  final bool isMe;
  final String time;
  final String senderName;
  final double senderHue;

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isMe': isMe,
    'time': time,
    'senderName': senderName,
    'senderHue': senderHue,
  };

  String toJsonString() => jsonEncode(toJson());

  factory GroupMessage.fromJson(Map<String, dynamic> json) => GroupMessage(
    id: json['id'] as String,
    text: json['text'] as String,
    isMe: json['isMe'] as bool,
    time: json['time'] as String,
    senderName: json['senderName'] as String,
    senderHue: (json['senderHue'] as num?)?.toDouble() ?? 0,
  );

  factory GroupMessage.fromJsonString(String s) =>
      GroupMessage.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
