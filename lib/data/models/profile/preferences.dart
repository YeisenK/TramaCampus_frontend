// Mirrors json-integration.md §3.2 preferences table.
class Preferences {
  const Preferences({
    this.modes = const [],
    this.uiModality = '',
    this.goals = const [],
    this.skills = const [],
    this.researchInterests = const [],
    this.availableDays = const [],
    this.connectivityState = 'active',
    this.modeOverrides = const [],
  });

  final List<String> modes; // 13-mode backend list (resolved by ModalityResolver)
  final String uiModality; // "estudio" | "amistad" | "personal" — analytics
  final List<String> goals; // catalog IDs, 1–5
  final List<String> skills; // catalog IDs, 3–10
  final List<String> researchInterests; // catalog IDs, 0–8
  final List<String> availableDays; // "mon_am" etc., 0–21
  final String connectivityState; // "active" | "paused" | "invisible"
  // Granular overrides: subset of backend modality IDs the user explicitly
  // toggled in edit-profile. ModalityResolver applies these over bucket defaults.
  final List<String> modeOverrides;

  Preferences copyWith({
    List<String>? modes,
    String? uiModality,
    List<String>? goals,
    List<String>? skills,
    List<String>? researchInterests,
    List<String>? availableDays,
    String? connectivityState,
    List<String>? modeOverrides,
  }) =>
      Preferences(
        modes: modes ?? this.modes,
        uiModality: uiModality ?? this.uiModality,
        goals: goals ?? this.goals,
        skills: skills ?? this.skills,
        researchInterests: researchInterests ?? this.researchInterests,
        availableDays: availableDays ?? this.availableDays,
        connectivityState: connectivityState ?? this.connectivityState,
        modeOverrides: modeOverrides ?? this.modeOverrides,
      );

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        modes: (json['modes'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        uiModality: json['ui_modality'] as String? ?? '',
        goals: (json['goals'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        skills: (json['skills'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        researchInterests:
            (json['research_interests'] as List<dynamic>?)
                    ?.map((e) => e as String)
                    .toList() ??
                const [],
        availableDays:
            (json['available_days'] as List<dynamic>?)
                    ?.map((e) => e as String)
                    .toList() ??
                const [],
        connectivityState:
            json['connectivity_state'] as String? ?? 'active',
        modeOverrides:
            (json['mode_overrides'] as List<dynamic>?)
                    ?.map((e) => e as String)
                    .toList() ??
                const [],
      );

  Map<String, dynamic> toJson() => {
        'modes': modes,
        'ui_modality': uiModality,
        'goals': goals,
        'skills': skills,
        if (researchInterests.isNotEmpty)
          'research_interests': researchInterests,
        if (availableDays.isNotEmpty) 'available_days': availableDays,
        'connectivity_state': connectivityState,
      };
}
