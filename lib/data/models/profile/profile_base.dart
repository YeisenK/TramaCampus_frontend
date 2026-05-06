// Mirrors json-integration.md §3.1 profiles table.
class ProfileBase {
  const ProfileBase({
    this.displayName = '',
    this.firstName = '',
    this.lastName = '',
    this.username = '',
    this.bio = '',
    this.careerId = '',
    this.semester = 1,
    this.universityId = '',
    this.gender = '',
    this.genderPreference = 'any',
    this.birthDate,
    this.avatarUrl,
  });

  final String displayName;
  final String firstName;
  final String lastName;
  // @handle chosen at signup. Lowercase [a-z0-9_], 3–20 chars, unique.
  // Separate from displayName — "Yeisen Martínez" vs "@yeisen".
  final String username;
  final String bio;
  final String careerId; // major code, e.g. "BADM"
  final int semester;
  final String universityId; // campus code, e.g. "UAO"
  final String gender; // "M" | "F" | "NB" | "prefer_not_say"
  final String genderPreference; // "M" | "F" | "NB" | "any"
  final DateTime? birthDate;
  final String? avatarUrl;

  ProfileBase copyWith({
    String? displayName,
    String? firstName,
    String? lastName,
    String? username,
    String? bio,
    String? careerId,
    int? semester,
    String? universityId,
    String? gender,
    String? genderPreference,
    DateTime? birthDate,
    String? avatarUrl,
  }) => ProfileBase(
    displayName: displayName ?? this.displayName,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    username: username ?? this.username,
    bio: bio ?? this.bio,
    careerId: careerId ?? this.careerId,
    semester: semester ?? this.semester,
    universityId: universityId ?? this.universityId,
    gender: gender ?? this.gender,
    genderPreference: genderPreference ?? this.genderPreference,
    birthDate: birthDate ?? this.birthDate,
    avatarUrl: avatarUrl ?? this.avatarUrl,
  );

  factory ProfileBase.fromJson(Map<String, dynamic> json) => ProfileBase(
    displayName: json['display_name'] as String? ?? '',
    firstName: json['first_name'] as String? ?? '',
    lastName: json['last_name'] as String? ?? '',
    username: json['username'] as String? ?? '',
    bio: json['bio'] as String? ?? '',
    careerId: json['career_id'] as String? ?? '',
    semester: json['semester'] as int? ?? 1,
    universityId: json['university_id'] as String? ?? '',
    gender: json['gender'] as String? ?? '',
    genderPreference: json['gender_preference'] as String? ?? 'any',
    birthDate: json['birth_date'] != null
        ? DateTime.tryParse(json['birth_date'] as String)
        : null,
    avatarUrl: json['avatar_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'display_name': displayName,
    'first_name': firstName,
    'last_name': lastName,
    'username': username,
    'bio': bio,
    'career_id': careerId,
    'semester': semester,
    'university_id': universityId,
    'gender': gender,
    'gender_preference': genderPreference,
    if (birthDate != null) 'birth_date': birthDate!.toIso8601String(),
    if (avatarUrl != null) 'avatar_url': avatarUrl,
  };
}
