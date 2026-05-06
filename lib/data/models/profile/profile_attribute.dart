// Mirrors json-integration.md §3.3 polymorphic profile_attributes schema.
// Each subclass maps to one attribute_type value.

enum SportFrequency { casual, regular, competitive }

enum LanguageLevel { basic, intermediate, advanced, native }

extension SportFrequencyExt on SportFrequency {
  String toJson() => name;
  static SportFrequency fromString(String s) =>
      SportFrequency.values.firstWhere((e) => e.name == s,
          orElse: () => SportFrequency.casual);
}

extension LanguageLevelExt on LanguageLevel {
  String toJson() => name;
  static LanguageLevel fromString(String s) =>
      LanguageLevel.values.firstWhere((e) => e.name == s,
          orElse: () => LanguageLevel.basic);
}

sealed class ProfileAttribute {
  const ProfileAttribute();

  factory ProfileAttribute.fromJson(Map<String, dynamic> json) {
    final type = json['attribute_type'] as String;
    final value = json['value'];
    return switch (type) {
      'hobby' => HobbyAttribute(hobbyId: value as String),
      'sport' => SportAttribute(
          sportId: (value as Map<String, dynamic>)['sport'] as String,
          frequency: SportFrequencyExt.fromString(
              (value)['frequency'] as String? ?? 'casual'),
        ),
      'personality_trait' =>
        PersonalityAttribute(traitId: value as String),
      'language' => LanguageAttribute(
          langCode: (value as Map<String, dynamic>)['lang'] as String,
          level: LanguageLevelExt.fromString(
              (value)['level'] as String? ?? 'basic'),
        ),
      'diet' => DietAttribute(dietId: value as String),
      'music_genre' => MusicAttribute(genreId: value as String),
      _ => throw FormatException('Unknown attribute_type: $type'),
    };
  }

  Map<String, dynamic> toJson();
}

class HobbyAttribute extends ProfileAttribute {
  const HobbyAttribute({required this.hobbyId});
  final String hobbyId;

  @override
  Map<String, dynamic> toJson() =>
      {'attribute_type': 'hobby', 'value': hobbyId};
}

class SportAttribute extends ProfileAttribute {
  const SportAttribute({required this.sportId, required this.frequency});
  final String sportId;
  final SportFrequency frequency;

  @override
  Map<String, dynamic> toJson() => {
        'attribute_type': 'sport',
        'value': {'sport': sportId, 'frequency': frequency.toJson()},
      };
}

class PersonalityAttribute extends ProfileAttribute {
  const PersonalityAttribute({required this.traitId});
  final String traitId;

  @override
  Map<String, dynamic> toJson() =>
      {'attribute_type': 'personality_trait', 'value': traitId};
}

class LanguageAttribute extends ProfileAttribute {
  const LanguageAttribute({required this.langCode, required this.level});
  final String langCode;
  final LanguageLevel level;

  @override
  Map<String, dynamic> toJson() => {
        'attribute_type': 'language',
        'value': {'lang': langCode, 'level': level.toJson()},
      };
}

class DietAttribute extends ProfileAttribute {
  const DietAttribute({required this.dietId});
  final String dietId;

  @override
  Map<String, dynamic> toJson() =>
      {'attribute_type': 'diet', 'value': dietId};
}

class MusicAttribute extends ProfileAttribute {
  const MusicAttribute({required this.genreId});
  final String genreId;

  @override
  Map<String, dynamic> toJson() =>
      {'attribute_type': 'music_genre', 'value': genreId};
}
