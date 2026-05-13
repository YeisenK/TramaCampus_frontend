import '../models/modality.dart';
import '../models/student.dart';
import 'local_matching_engine.dart';

/// Map a `LocalMatch` (engine output) to the legacy `Student` UI model
/// so the Discover widgets keep working unchanged. `bucket` is the
/// modality the user is currently browsing — becomes `Student.intent`.
Student localMatchToStudent(LocalMatch m, ModalityType bucket) {
  final p = m.person;
  final score = (m.score * 100).round().clamp(0, 100);
  return Student(
    id: p.id,
    name: p.name,
    age: p.age,
    program: p.major,
    semester: p.semester,
    hue: p.hue,
    intent: bucket,
    photoUrl: p.photoUrl,
    bio: p.bio,
    interests: p.interests,
    compatibilityScore: score,
    reasons: m.reasons,
  );
}
