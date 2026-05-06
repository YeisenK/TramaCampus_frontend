import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../section_card.dart';
import '../../../data/models/profile/profile.dart';

// Shows missing optional profile fields with deep-link CTAs.
// Mirrors the f_prof 12-field completeness formula from docs/tex/01_arquitectura_Trama.tex §2299.
class CompleteProfileChecklist extends StatelessWidget {
  const CompleteProfileChecklist({
    super.key,
    required this.profile,
    required this.onNavigate,
  });

  final Profile profile;
  // Called with a field key when user taps its "Completar" button.
  final void Function(String fieldKey) onNavigate;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final missing = _missingFields(profile);
    if (missing.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space5),
      child: SectionCard(
        title: 'COMPLETA TU PERFIL',
        children: missing.map((f) {
          return ListTile(
            leading: Icon(Icons.circle_outlined,
                size: 18, color: cs.onSurfaceVariant),
            title: Text(f.label, style: AppTextStyles.bodyMd(cs.onSurface)),
            subtitle: Text(f.hint,
                style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
            trailing: TextButton(
              onPressed: () => onNavigate(f.key),
              child: Text('Completar',
                  style: AppTextStyles.labelSm(cs.primary)),
            ),
          );
        }).toList(),
      ),
    );
  }

  static List<_ChecklistField> _missingFields(Profile p) {
    final fields = <_ChecklistField>[];
    if (p.base.bio.length < 20) {
      fields.add(const _ChecklistField(
        key: 'bio',
        label: 'Bio',
        hint: 'Añade una descripción de al menos 20 caracteres',
      ));
    }
    if (p.hobbyIds.length < 2) {
      fields.add(const _ChecklistField(
        key: 'hobbies',
        label: 'Pasatiempos',
        hint: 'Al menos 2 pasatiempos mejoran tu visibilidad',
      ));
    }
    if (p.personalityTraitIds.isEmpty) {
      fields.add(const _ChecklistField(
        key: 'personality',
        label: 'Personalidad',
        hint: 'Agrega rasgos de personalidad',
      ));
    }
    if (p.musicGenreIds.isEmpty) {
      fields.add(const _ChecklistField(
        key: 'music',
        label: 'Música favorita',
        hint: 'Comparte tus géneros favoritos',
      ));
    }
    if (p.sports.isEmpty) {
      fields.add(const _ChecklistField(
        key: 'sports',
        label: 'Deportes',
        hint: 'Añade los deportes que practicas',
      ));
    }
    if (p.dietIds.isEmpty) {
      fields.add(const _ChecklistField(
        key: 'diet',
        label: 'Dieta',
        hint: 'Indica tus preferencias alimentarias',
      ));
    }
    return fields;
  }
}

class _ChecklistField {
  const _ChecklistField({
    required this.key,
    required this.label,
    required this.hint,
  });

  final String key;
  final String label;
  final String hint;
}
