import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../toggle_tile.dart';
import '../section_card.dart';
import '../../../data/models/modality_bucket.dart';
import '../../../data/services/modality_resolver.dart';

// Edit-profile "Avanzado" panel — 13 individual mode toggles grouped by bucket.
// When the user sets any overrides, ModalityResolver uses them instead of
// the bucket defaults. Caller holds the full override list.
class ModalityAdvancedToggle extends StatelessWidget {
  const ModalityAdvancedToggle({
    super.key,
    required this.enabledBuckets,
    required this.overrides,
    required this.onOverridesChanged,
  });

  final Set<ModalityBucketId> enabledBuckets;
  final List<String> overrides;
  final void Function(List<String>) onOverridesChanged;

  bool _isEnabled(String modeId) => overrides.isNotEmpty
      ? overrides.contains(modeId)
      : ModalityResolver.expand(
              buckets: enabledBuckets.toList(), overrides: const [])
          .contains(modeId);

  void _toggle(String modeId) {
    // On first toggle, materialise the current implicit list as overrides.
    final current = overrides.isNotEmpty
        ? List<String>.from(overrides)
        : ModalityResolver.expand(
            buckets: enabledBuckets.toList(), overrides: const []);
    if (current.contains(modeId)) {
      current.remove(modeId);
    } else {
      current.add(modeId);
    }
    onOverridesChanged(List.unmodifiable(current));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ModalityBucket.all.map((bucket) {
        final modes = bucket.defaultModes;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.space4),
          child: SectionCard(
            title: bucket.label.toUpperCase(),
            children: modes.map((modeId) {
              final label = _modeLabel(modeId);
              return ToggleTile(
                icon: _modeIcon(modeId),
                label: label,
                value: _isEnabled(modeId),
                onChanged: (_) => _toggle(modeId),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  static IconData _modeIcon(String id) => switch (id) {
        'study' => Icons.menu_book_outlined,
        'research' => Icons.science_outlined,
        'competition' => Icons.emoji_events_outlined,
        'social' => Icons.people_outline,
        'networking' => Icons.hub_outlined,
        'gaming' => Icons.sports_esports_outlined,
        'language' => Icons.translate,
        'creative' => Icons.palette_outlined,
        'volunteer' => Icons.volunteer_activism_outlined,
        'wellness' => Icons.spa_outlined,
        'lifestyle' => Icons.local_cafe_outlined,
        'startup' => Icons.rocket_launch_outlined,
        'eros' => Icons.favorite_border,
        _ => Icons.circle_outlined,
      };

  static String _modeLabel(String id) => switch (id) {
        'study' => 'Estudio',
        'research' => 'Investigación',
        'competition' => 'Competencia',
        'social' => 'Social',
        'networking' => 'Networking',
        'gaming' => 'Gaming',
        'language' => 'Idiomas',
        'creative' => 'Creatividad',
        'volunteer' => 'Voluntariado',
        'wellness' => 'Bienestar',
        'lifestyle' => 'Estilo de vida',
        'startup' => 'Emprendimiento',
        'eros' => 'Conexión personal',
        _ => id,
      };
}
