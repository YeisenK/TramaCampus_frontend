// DTO returned by the matching API. Mirrors `EnrichedCandidate` from
// matching_service::api::enrichment.

class RecommendedStudent {
  const RecommendedStudent({
    required this.id,
    required this.score,
    required this.displayName,
    required this.bio,
    required this.major,
    required this.area,
    required this.semester,
    required this.gender,
    required this.modalities,
    required this.goals,
    required this.hobbies,
    required this.skills,
    required this.personalityTraits,
    required this.avatarUrl,
    required this.idCampus,
    required this.breakdown,
  });

  final int id;
  final double score;
  final String displayName;
  final String bio;
  final String major;
  final String area;
  final int semester;
  final String gender;
  final List<String> modalities;
  final List<String> goals;
  final List<String> hobbies;
  final List<String> skills;
  final List<String> personalityTraits;
  final String avatarUrl;
  final String idCampus;
  final ScoreBreakdown breakdown;

  factory RecommendedStudent.fromJson(Map<String, dynamic> json) {
    final breakdownJson = (json['breakdown'] as Map<String, dynamic>?) ?? {};
    return RecommendedStudent(
      id: (json['candidate_id'] as num).toInt(),
      score: (json['general_score'] as num).toDouble(),
      displayName: json['display_name'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      major: json['major'] as String? ?? '',
      area: json['area'] as String? ?? '',
      semester: (json['semester'] as num?)?.toInt() ?? 1,
      gender: json['gender'] as String? ?? 'NR',
      modalities: _strList(json['modalities']),
      goals: _strList(json['goals']),
      hobbies: _strList(json['hobbies']),
      skills: _strList(json['skills']),
      personalityTraits: _strList(json['personality_traits']),
      avatarUrl: json['avatar_url'] as String? ?? '',
      idCampus: json['id_campus'] as String? ?? '',
      breakdown: ScoreBreakdown.fromJson(breakdownJson),
    );
  }

  static List<String> _strList(dynamic v) {
    if (v is List) return v.map((e) => e.toString()).toList();
    return const [];
  }
}

class ScoreBreakdown {
  const ScoreBreakdown({
    required this.academic,
    required this.personal,
    required this.intent,
    required this.behavior,
    this.eros,
  });

  final double academic;
  final double personal;
  final double intent;
  final double behavior;
  final double? eros;

  factory ScoreBreakdown.fromJson(Map<String, dynamic> json) => ScoreBreakdown(
    academic: (json['s_acad'] as num?)?.toDouble() ?? 0,
    personal: (json['s_pers'] as num?)?.toDouble() ?? 0,
    intent: (json['s_int'] as num?)?.toDouble() ?? 0,
    behavior: (json['s_behav'] as num?)?.toDouble() ?? 0,
    eros: (json['s_eros'] as num?)?.toDouble(),
  );
}

class MatchResultsDto {
  const MatchResultsDto({
    required this.userId,
    required this.coldStart,
    required this.topGeneral,
  });

  final int userId;
  final bool coldStart;
  final List<RecommendedStudent> topGeneral;

  factory MatchResultsDto.fromJson(Map<String, dynamic> json) =>
      MatchResultsDto(
        userId: (json['user_id'] as num).toInt(),
        coldStart: json['cold_start'] as bool? ?? false,
        topGeneral: ((json['top_general'] as List<dynamic>?) ?? const [])
            .map((e) => RecommendedStudent.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
