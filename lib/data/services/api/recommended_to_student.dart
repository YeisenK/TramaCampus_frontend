import '../../models/modality.dart';
import '../../models/recommended_student.dart';
import '../../models/student.dart';

/// Map an API-recommended candidate into the legacy `Student` UI model
/// so the existing Discover widgets keep working untouched.
///
/// `modality` is the bucket the user is currently browsing — it
/// becomes `Student.intent`. The compatibility score is multiplied by
/// 100 to match the legacy `compatibilityScore` int convention.
Student recommendedToStudent(RecommendedStudent r, ModalityType modality) {
  final score = (r.score * 100).round().clamp(0, 100);
  final reasons = _topReasons(r.breakdown);
  return Student(
    id: r.id.toString(),
    name: r.displayName,
    age: _ageFromSemester(r.semester),
    program: r.major,
    semester: r.semester,
    hue: _hueFromId(r.id),
    intent: modality,
    photoUrl: _resolvePhoto(r.avatarUrl, r.id),
    bio: r.bio,
    interests: [
      ...r.goals.take(3),
      ...r.hobbies.take(3),
      ...r.skills.take(2),
    ],
    compatibilityScore: score,
    reasons: reasons,
  );
}

/// Rough age estimate when the backend only returns semester. Demo
/// only — the real avatar/age data should come from the candidate
/// payload once that lands.
int _ageFromSemester(int semester) => 17 + (semester.clamp(1, 12));

double _hueFromId(int id) {
  // Spread ids deterministically over the hue wheel.
  return (id * 137) % 360;
}

String? _resolvePhoto(String avatarUrl, int id) {
  if (avatarUrl.isEmpty) return null;
  if (avatarUrl.startsWith('http')) return avatarUrl;
  // Backend ships paths like `assets/avatars/0042.jpg` — Flutter only
  // resolves bundle assets that exist; we don't ship 1000 mock images.
  // Return null so the avatar widget falls back to initials/gradient.
  return null;
}

List<String> _topReasons(ScoreBreakdown b) {
  final entries = <MapEntry<String, double>>[
    MapEntry('Académico', b.academic),
    MapEntry('Personalidad', b.personal),
    MapEntry('Intención', b.intent),
    MapEntry('Actividad', b.behavior),
  ]..sort((a, b) => b.value.compareTo(a.value));
  return entries
      .where((e) => e.value > 0.55)
      .take(3)
      .map((e) => '${e.key} ${(e.value * 100).round()}%')
      .toList();
}
