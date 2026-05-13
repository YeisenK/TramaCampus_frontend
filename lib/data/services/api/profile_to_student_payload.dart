import '../../models/profile/profile.dart';

/// Build the JSON body for `POST /v1/match/ingest`. Mirrors the shape
/// expected by `matching_service::api::translator::IngestRequest`.
///
/// The backend is lenient with missing fields (see `api/README.md`), so
/// we only need to pass what the Flutter profile actually carries.
Map<String, dynamic> profileToIngestPayload(Profile profile, {required int userId}) {
  final profileJson = profile.base.toJson();
  // Backend `modes` is the canonical 13-modality list (catalog IDs).
  // The Flutter side resolves these via ModalityResolver / picker before
  // saving, so `preferences.modes` is already the list we send.
  return {
    'user_id': userId,
    'profile': {
      'display_name': profileJson['display_name'] ?? '',
      'first_name': profileJson['first_name'] ?? '',
      'last_name': profileJson['last_name'] ?? '',
      'bio': profileJson['bio'] ?? '',
      'career_id': profileJson['career_id'] ?? '',
      'semester': profileJson['semester'] ?? 1,
      'university_id': profileJson['university_id'] ?? '',
      'gender': _normalizeGender(profileJson['gender'] as String?),
      if (profileJson['birth_date'] != null)
        'birth_date': profileJson['birth_date'],
      if (profileJson['avatar_url'] != null)
        'avatar_url': profileJson['avatar_url'],
    },
    'preferences': {
      'modes': profile.preferences.modes,
      'goals': profile.preferences.goals,
      'skills': profile.preferences.skills,
      'research_interests': profile.preferences.researchInterests,
      'available_days': profile.preferences.availableDays,
      'connectivity_state': profile.preferences.connectivityState,
    },
    'profile_attributes': profile.attributes.map((a) => a.toJson()).toList(),
  };
}

// Backend gender enum: "M" | "F" | "NR". Frontend may carry
// "prefer_not_say" — collapse it to "NR".
String _normalizeGender(String? g) {
  switch (g) {
    case 'M':
    case 'F':
      return g!;
    default:
      return 'NR';
  }
}
