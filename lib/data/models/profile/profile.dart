import 'dart:convert';

import 'preferences.dart';
import 'profile_attribute.dart';
import 'profile_base.dart';

// Mirrors json-integration.md §3 full profile payload.
class Profile {
  const Profile({
    required this.base,
    required this.preferences,
    this.attributes = const [],
  });

  final ProfileBase base;
  final Preferences preferences;
  final List<ProfileAttribute> attributes;

  // Convenience accessors for attribute lists.
  List<String> get hobbyIds =>
      attributes.whereType<HobbyAttribute>().map((a) => a.hobbyId).toList();

  List<SportAttribute> get sports =>
      attributes.whereType<SportAttribute>().toList();

  List<String> get personalityTraitIds => attributes
      .whereType<PersonalityAttribute>()
      .map((a) => a.traitId)
      .toList();

  List<LanguageAttribute> get languages =>
      attributes.whereType<LanguageAttribute>().toList();

  List<String> get dietIds =>
      attributes.whereType<DietAttribute>().map((a) => a.dietId).toList();

  List<String> get musicGenreIds =>
      attributes.whereType<MusicAttribute>().map((a) => a.genreId).toList();

  Profile copyWith({
    ProfileBase? base,
    Preferences? preferences,
    List<ProfileAttribute>? attributes,
  }) => Profile(
    base: base ?? this.base,
    preferences: preferences ?? this.preferences,
    attributes: attributes ?? this.attributes,
  );

  factory Profile.fromJson(Map<String, dynamic> json) {
    final attrList = json['profile_attributes'] as List<dynamic>? ?? [];
    return Profile(
      base: ProfileBase.fromJson(
        (json['profile'] as Map<String, dynamic>?) ?? {},
      ),
      preferences: Preferences.fromJson(
        (json['preferences'] as Map<String, dynamic>?) ?? {},
      ),
      attributes: attrList
          .map((e) => ProfileAttribute.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    // Apply personality default if none selected (per matching_input.md line 200).
    final traits = personalityTraitIds;
    final effectiveAttributes = traits.isEmpty
        ? [
            ...attributes,
            const PersonalityAttribute(traitId: 'curioso'),
            const PersonalityAttribute(traitId: 'colaborador'),
            const PersonalityAttribute(traitId: 'reflexivo'),
          ]
        : attributes;

    return {
      'profile': base.toJson(),
      'preferences': preferences.toJson(),
      'profile_attributes': effectiveAttributes.map((a) => a.toJson()).toList(),
    };
  }

  // Convenience: JSON blob for SQLite storage.
  String toJsonString() => jsonEncode(toJson());

  factory Profile.fromJsonString(String s) =>
      Profile.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
