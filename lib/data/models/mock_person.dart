/// One row of assets/data/mock_people.json. Shape decided by the
/// Python generator in scripts/ — keep `fromJson` lenient so the
/// schema can evolve without breaking the app.
class MockPerson {
  const MockPerson({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.city,
    required this.major,
    required this.semester,
    required this.bio,
    required this.interests,
    required this.modes,
    required this.personality,
    required this.photoUrl,
    this.photoMediumUrl,
    this.photoThumbUrl,
  });

  final String id;
  final String name;
  final int age;
  final String gender; // "M" | "F" | "NR"
  final String city;
  final String major;
  final int semester;
  final String bio;
  final List<String> interests;
  final List<String> modes; // "estudio" | "amistad" | "personal"
  final List<String> personality;
  final String photoUrl;
  final String? photoMediumUrl;
  final String? photoThumbUrl;

  factory MockPerson.fromJson(Map<String, dynamic> json) => MockPerson(
    id: json['id'] as String,
    name: json['name'] as String,
    age: (json['age'] as num).toInt(),
    gender: json['gender'] as String? ?? 'NR',
    city: json['city'] as String? ?? '',
    major: json['major'] as String? ?? '',
    semester: (json['semester'] as num?)?.toInt() ?? 1,
    bio: json['bio'] as String? ?? '',
    interests: _strList(json['interests']),
    modes: _strList(json['modes']),
    personality: _strList(json['personality']),
    photoUrl: json['photoUrl'] as String? ?? '',
    photoMediumUrl: json['photoMediumUrl'] as String?,
    photoThumbUrl: json['photoThumbUrl'] as String?,
  );

  static List<String> _strList(dynamic v) {
    if (v is List) return v.map((e) => e.toString()).toList();
    return const [];
  }

  String get firstName => name.split(' ').first;
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return parts[0][0];
  }

  /// Stable hue for the gradient fallback (when the network photo
  /// fails to load).
  double get hue {
    var h = 0;
    for (final c in id.codeUnits) {
      h = (h * 31 + c) & 0xFFFFFFFF;
    }
    return (h % 360).toDouble();
  }
}
