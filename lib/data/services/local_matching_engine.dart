import '../models/mock_person.dart';
import '../models/profile/profile.dart';

/// One ranked candidate ready to render in Discover.
class LocalMatch {
  const LocalMatch({
    required this.person,
    required this.score,
    required this.reasons,
  });

  final MockPerson person;
  final double score;
  final List<String> reasons;
}

/// Pure-Dart matching. Takes the local user's `Profile` and a pool of
/// `MockPerson`, applies a hard gender-preference filter, scores by
/// shared interests / modes / age / city / personality, and returns
/// the top-K with human-readable reasons.
///
/// Score components (sum to 1.0):
///   interests     0.35  Jaccard over hobby-style attributes
///   modes         0.25  Jaccard over modality buckets
///   age           0.15  Linear decay over 10-year gap
///   city          0.15  Exact match
///   personality   0.10  Jaccard
class LocalMatchingEngine {
  const LocalMatchingEngine();

  List<LocalMatch> recommend({
    required Profile user,
    required List<MockPerson> pool,
    required int userAge,
    required String userCity,
    int topK = 50,
    String? modeFilter,
  }) {
    final myInterests = user.hobbyIds.map(_norm).toSet();
    final myModes = user.preferences.modes.map(_norm).toSet();
    final myTraits = user.personalityTraitIds.map(_norm).toSet();
    final preference = user.base.genderPreference;
    final cityLc = userCity.toLowerCase();

    final scored = <LocalMatch>[];
    for (final p in pool) {
      if (!_passesGenderFilter(preference, p.gender)) continue;
      if (modeFilter != null && !p.modes.map(_norm).contains(_norm(modeFilter))) {
        continue;
      }

      final theirInterests = p.interests.map(_norm).toSet();
      final theirModes = p.modes.map(_norm).toSet();
      final theirTraits = p.personality.map(_norm).toSet();

      final interestScore = _jaccard(myInterests, theirInterests);
      final modeScore = _jaccard(myModes, theirModes);
      final ageScore = _ageProximity(userAge, p.age);
      final cityScore = p.city.toLowerCase() == cityLc ? 1.0 : 0.0;
      final personalityScore = _jaccard(myTraits, theirTraits);

      final score = 0.35 * interestScore +
          0.25 * modeScore +
          0.15 * ageScore +
          0.15 * cityScore +
          0.10 * personalityScore;

      if (score <= 0) continue;

      final reasons = _buildReasons(
        interestScore: interestScore,
        sharedInterests: myInterests.intersection(theirInterests),
        modeScore: modeScore,
        sharedModes: myModes.intersection(theirModes),
        cityScore: cityScore,
        userCity: userCity,
        ageScore: ageScore,
        userAge: userAge,
        themAge: p.age,
        personalityScore: personalityScore,
        sharedTraits: myTraits.intersection(theirTraits),
      );

      scored.add(LocalMatch(person: p, score: score, reasons: reasons));
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    if (scored.length > topK) return scored.sublist(0, topK);
    return scored;
  }

  static String _norm(String s) => s.trim().toLowerCase();

  bool _passesGenderFilter(String preference, String theirGender) {
    if (preference == 'any' || preference.isEmpty) return true;
    if (theirGender == 'NR') return true; // "no answer" never gets filtered out
    return preference == theirGender;
  }

  double _jaccard(Set<String> a, Set<String> b) {
    if (a.isEmpty || b.isEmpty) return 0.0;
    final inter = a.intersection(b).length;
    final union = a.union(b).length;
    return union == 0 ? 0.0 : inter / union;
  }

  double _ageProximity(int a, int b) {
    final diff = (a - b).abs();
    if (diff >= 10) return 0.0;
    return 1.0 - diff / 10.0;
  }

  List<String> _buildReasons({
    required double interestScore,
    required Set<String> sharedInterests,
    required double modeScore,
    required Set<String> sharedModes,
    required double cityScore,
    required String userCity,
    required double ageScore,
    required int userAge,
    required int themAge,
    required double personalityScore,
    required Set<String> sharedTraits,
  }) {
    final reasons = <(double, String)>[];

    if (sharedInterests.isNotEmpty) {
      final n = sharedInterests.length;
      final label = n == 1
          ? '1 interés en común'
          : '$n intereses en común';
      reasons.add((interestScore, label));
    }
    if (sharedModes.isNotEmpty) {
      final pretty = sharedModes.map(_prettyMode).join(', ');
      reasons.add((modeScore, 'Buscan $pretty'));
    }
    if (cityScore > 0) {
      reasons.add((cityScore, 'Misma ciudad · $userCity'));
    }
    final ageDiff = (userAge - themAge).abs();
    if (ageScore > 0.7 && ageDiff <= 3) {
      reasons.add((ageScore, 'Edad similar'));
    }
    if (sharedTraits.isNotEmpty) {
      final pretty = sharedTraits.take(2).join(', ');
      reasons.add((personalityScore, 'Personalidad: $pretty'));
    }

    reasons.sort((a, b) => b.$1.compareTo(a.$1));
    return reasons.take(3).map((e) => e.$2).toList();
  }

  String _prettyMode(String m) => switch (m) {
    'estudio' => 'estudio',
    'amistad' => 'amistad',
    'personal' => 'conexión',
    _ => m,
  };
}
