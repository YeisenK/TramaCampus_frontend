import 'dart:convert';

import 'preferences.dart';
import 'profile.dart';
import 'profile_attribute.dart';
import 'profile_base.dart';

// Nullable version of Profile for accumulating onboarding state across screens.
// Written to SQLite after each step; restored on app resume.
class ProfileDraft {
  ProfileDraft({
    this.displayName,
    this.firstName,
    this.lastName,
    this.username,
    this.bio,
    this.careerId,
    this.semester,
    this.universityId,
    this.gender,
    this.genderPreference,
    this.birthDate,
    this.avatarUrl,
    this.uiModality,
    this.modeOverrides,
    this.goals,
    this.skills,
    this.researchInterests,
    this.availableDays,
    this.connectivityState,
    this.hobbies,
    this.sports,
    this.personalityTraits,
    this.languages,
    this.dietIds,
    this.musicGenreIds,
    this.lastCompletedStep,
  });

  String? displayName;
  String? firstName;
  String? lastName;
  String? username;
  String? bio;
  String? careerId;
  int? semester;
  String? universityId;
  String? gender;
  String? genderPreference;
  DateTime? birthDate;
  String? avatarUrl;
  String? uiModality;
  List<String>? modeOverrides;
  List<String>? goals;
  List<String>? skills;
  List<String>? researchInterests;
  List<String>? availableDays;
  String? connectivityState;
  List<String>? hobbies;
  List<SportAttribute>? sports;
  List<String>? personalityTraits;
  List<LanguageAttribute>? languages;
  List<String>? dietIds;
  List<String>? musicGenreIds;
  String? lastCompletedStep;

  // Build a final Profile — caller must ensure validation has passed.
  Profile toProfile({required List<String> resolvedModes}) {
    final attrs = <ProfileAttribute>[
      for (final h in hobbies ?? []) HobbyAttribute(hobbyId: h),
      ...sports ?? [],
      for (final t in personalityTraits ?? []) PersonalityAttribute(traitId: t),
      ...languages ?? [],
      for (final d in dietIds ?? []) DietAttribute(dietId: d),
      for (final m in musicGenreIds ?? []) MusicAttribute(genreId: m),
    ];

    return Profile(
      base: ProfileBase(
        displayName: displayName ?? '',
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        username: username ?? '',
        bio: bio ?? '',
        careerId: careerId ?? '',
        semester: semester ?? 1,
        universityId: universityId ?? '',
        gender: gender ?? '',
        genderPreference: genderPreference ?? 'any',
        birthDate: birthDate,
        avatarUrl: avatarUrl,
      ),
      preferences: Preferences(
        modes: resolvedModes,
        uiModality: uiModality ?? '',
        goals: goals ?? [],
        skills: skills ?? [],
        researchInterests: researchInterests ?? [],
        availableDays: availableDays ?? [],
        connectivityState: connectivityState ?? 'active',
        modeOverrides: modeOverrides ?? [],
      ),
      attributes: attrs,
    );
  }

  Map<String, dynamic> _toMap() => {
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
        'birth_date': birthDate?.toIso8601String(),
        'avatar_url': avatarUrl,
        'ui_modality': uiModality,
        'mode_overrides': modeOverrides,
        'goals': goals,
        'skills': skills,
        'research_interests': researchInterests,
        'available_days': availableDays,
        'connectivity_state': connectivityState,
        'hobbies': hobbies,
        'sports': sports?.map((s) => s.toJson()).toList(),
        'personality_traits': personalityTraits,
        'languages': languages?.map((l) => l.toJson()).toList(),
        'diet_ids': dietIds,
        'music_genre_ids': musicGenreIds,
        'last_completed_step': lastCompletedStep,
      };

  String toJsonString() => jsonEncode(_toMap());

  factory ProfileDraft.fromJsonString(String s) {
    final map = jsonDecode(s) as Map<String, dynamic>;
    return ProfileDraft(
      displayName: map['display_name'] as String?,
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      username: map['username'] as String?,
      bio: map['bio'] as String?,
      careerId: map['career_id'] as String?,
      semester: map['semester'] as int?,
      universityId: map['university_id'] as String?,
      gender: map['gender'] as String?,
      genderPreference: map['gender_preference'] as String?,
      birthDate: map['birth_date'] != null
          ? DateTime.tryParse(map['birth_date'] as String)
          : null,
      avatarUrl: map['avatar_url'] as String?,
      uiModality: map['ui_modality'] as String?,
      modeOverrides:
          (map['mode_overrides'] as List<dynamic>?)?.cast<String>(),
      goals: (map['goals'] as List<dynamic>?)?.cast<String>(),
      skills: (map['skills'] as List<dynamic>?)?.cast<String>(),
      researchInterests:
          (map['research_interests'] as List<dynamic>?)?.cast<String>(),
      availableDays:
          (map['available_days'] as List<dynamic>?)?.cast<String>(),
      connectivityState: map['connectivity_state'] as String?,
      hobbies: (map['hobbies'] as List<dynamic>?)?.cast<String>(),
      sports: (map['sports'] as List<dynamic>?)
          ?.map((e) =>
              ProfileAttribute.fromJson(e as Map<String, dynamic>) as SportAttribute)
          .toList(),
      personalityTraits:
          (map['personality_traits'] as List<dynamic>?)?.cast<String>(),
      languages: (map['languages'] as List<dynamic>?)
          ?.map((e) =>
              ProfileAttribute.fromJson(e as Map<String, dynamic>) as LanguageAttribute)
          .toList(),
      dietIds: (map['diet_ids'] as List<dynamic>?)?.cast<String>(),
      musicGenreIds:
          (map['music_genre_ids'] as List<dynamic>?)?.cast<String>(),
      lastCompletedStep: map['last_completed_step'] as String?,
    );
  }
}
