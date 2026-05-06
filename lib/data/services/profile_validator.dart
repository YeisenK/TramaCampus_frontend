import '../models/profile/profile.dart';
import '../models/profile/profile_draft.dart';
import 'modality_resolver.dart';

// Validates profile data against json-integration.md §12 rules.
// Returns a map of fieldKey → error message. Empty map = valid.
abstract final class ProfileValidator {
  static Map<String, String> validate(Profile profile) {
    final errors = <String, String>{};
    final prefs = profile.preferences;
    final base = profile.base;

    if (base.careerId.isEmpty) {
      errors['career_id'] = 'Selecciona una carrera.';
    }
    if (base.universityId.isEmpty) {
      errors['university_id'] = 'Selecciona un campus.';
    }
    if (base.semester < 1 || base.semester > 12) {
      errors['semester'] = 'El semestre debe estar entre 1 y 12.';
    }
    if (base.gender.isEmpty) {
      errors['gender'] = 'Selecciona tu género.';
    }
    if (base.birthDate == null) {
      errors['birth_date'] = 'Ingresa tu fecha de nacimiento.';
    }

    // Modalities: ≥1 required (hard filter).
    if (prefs.modes.isEmpty) {
      errors['modes'] = 'Selecciona al menos una modalidad.';
    }
    for (final m in prefs.modes) {
      if (!ModalityResolver.isValidMode(m)) {
        errors['modes'] = 'Modalidad inválida: $m';
        break;
      }
    }

    // Goals: 1–10.
    if (prefs.goals.isEmpty) {
      errors['goals'] = 'Selecciona al menos un objetivo.';
    } else if (prefs.goals.length > 15) {
      errors['goals'] = 'Máximo 15 objetivos.';
    }

    // Skills: 3–50 (hard required).
    if (prefs.skills.length < 3) {
      errors['skills'] =
          'Selecciona al menos 3 habilidades (${prefs.skills.length}/3).';
    } else if (prefs.skills.length > 50) {
      errors['skills'] = 'Máximo 50 habilidades.';
    }

    // Research interests: 0–8 (conditional, not enforced here).
    if (prefs.researchInterests.length > 8) {
      errors['research_interests'] = 'Máximo 8 intereses de investigación.';
    }

    // Hobbies: ≤10.
    if (profile.hobbyIds.length > 10) {
      errors['hobbies'] = 'Máximo 10 pasatiempos.';
    }

    // Sports: ≤5.
    if (profile.sports.length > 5) {
      errors['sports'] = 'Máximo 5 deportes.';
    }

    // Personality: ≤5 (default applied at toJson if empty, not an error).
    if (profile.personalityTraitIds.length > 5) {
      errors['personality_traits'] = 'Máximo 5 rasgos de personalidad.';
    }

    // Music genres: ≤4.
    if (profile.musicGenreIds.length > 4) {
      errors['music_genres'] = 'Máximo 4 géneros musicales.';
    }

    // Diet: ≤3.
    if (profile.dietIds.length > 3) {
      errors['diet'] = 'Máximo 3 preferencias alimentarias.';
    }

    // Languages: ≤15.
    if (profile.languages.length > 15) {
      errors['languages'] = 'Máximo 15 idiomas.';
    }

    return errors;
  }

  // Lightweight check for onboarding step gating — only required fields.
  static Map<String, String> validateOnboarding(ProfileDraft draft) {
    final errors = <String, String>{};
    if (draft.universityId == null || draft.universityId!.isEmpty) {
      errors['university_id'] = 'Selecciona un campus.';
    }
    if (draft.careerId == null || draft.careerId!.isEmpty) {
      errors['career_id'] = 'Selecciona una carrera.';
    }
    if (draft.uiModality == null || draft.uiModality!.isEmpty) {
      errors['modes'] = 'Selecciona al menos una modalidad.';
    }
    if ((draft.goals ?? []).isEmpty) {
      errors['goals'] = 'Selecciona al menos un objetivo.';
    }
    if ((draft.skills ?? []).length < 3) {
      errors['skills'] = 'Selecciona al menos 3 habilidades.';
    }
    return errors;
  }
}
