import 'modality.dart';

class Student {
  const Student({
    required this.id,
    required this.name,
    required this.age,
    required this.program,
    required this.semester,
    required this.hue,
    required this.intent,
    this.photoUrl,
    this.bio = '',
    this.interests = const [],
    this.compatibilityScore = 0,
    this.reasons = const [],
  });

  final String id;
  final String name;
  final int age;
  final String program;
  final int semester;
  final double hue;
  final ModalityType intent;
  final String? photoUrl;
  final String bio;
  final List<String> interests;
  final int compatibilityScore;
  final List<String> reasons;

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return parts[0][0];
  }

  String get firstName => name.split(' ').first;
}
