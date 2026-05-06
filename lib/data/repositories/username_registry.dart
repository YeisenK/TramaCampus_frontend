// Abstract interface. MockUsernameRegistry validates against a pre-seeded set.
// When backend exists, swap in RemoteUsernameRegistry with GET /v1/users/username/{handle}.
abstract class UsernameRegistry {
  Future<bool> isAvailable(String handle);
  Future<List<String>> suggest(String handle);
}

// Validation rules applied before any registry check.
final _kUsernameRegex = RegExp(r'^[a-z][a-z0-9_]{2,19}$');

String? validateUsernameShape(String raw) {
  final handle = raw.trim().toLowerCase();
  if (handle.length < 3) return 'Mínimo 3 caracteres';
  if (handle.length > 20) return 'Máximo 20 caracteres';
  if (!_kUsernameRegex.hasMatch(handle)) {
    return 'Solo letras, números y _ · debe iniciar con letra';
  }
  return null;
}

class MockUsernameRegistry implements UsernameRegistry {
  MockUsernameRegistry._();
  static final MockUsernameRegistry instance = MockUsernameRegistry._();

  static const _taken = {
    'sofia',
    'sofia_r',
    'sofiaramirez',
    'diego',
    'diego_n',
    'ana',
    'renata',
    'mateo',
    'lucia',
    'javier',
    'camila',
    'trama',
    'anahuac',
    'admin',
    'yeisen',
    'estudiante',
    'campus',
    'tramacampus',
  };

  @override
  Future<bool> isAvailable(String handle) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return !_taken.contains(handle.trim().toLowerCase());
  }

  @override
  Future<List<String>> suggest(String handle) async {
    final base = handle.trim().toLowerCase();
    final candidates = [base, '${base}_', '${base}x', '${base}01', '${base}2'];
    final available = <String>[];
    for (final c in candidates) {
      if (validateUsernameShape(c) == null && !_taken.contains(c)) {
        available.add(c);
        if (available.length >= 3) break;
      }
    }
    return available;
  }
}
