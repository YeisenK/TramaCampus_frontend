import '../mock/mock_data.dart';
import '../models/student.dart';
import '../models/modality.dart';

class StudentRepository {
  const StudentRepository();

  List<Student> getAll() => MockData.students;

  List<Student> getByModality(ModalityType type) =>
      MockData.students.where((s) => s.intent == type).toList();

  Student? getById(String id) {
    for (final s in MockData.students) {
      if (s.id == id) return s;
    }
    return null;
  }

  Student getCurrentUser() => MockData.currentUser;
}
