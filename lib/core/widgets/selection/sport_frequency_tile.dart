import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../../data/models/profile/profile_attribute.dart';

// A selected sport row with a frequency picker (casual / regular / competitive).
class SportFrequencyTile extends StatelessWidget {
  const SportFrequencyTile({
    super.key,
    required this.label,
    required this.frequency,
    required this.onFrequencyChanged,
    required this.onRemove,
  });

  final String label;
  final SportFrequency frequency;
  final void Function(SportFrequency) onFrequencyChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space3),
      padding: const EdgeInsets.all(AppSpacing.space3),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label, style: AppTextStyles.bodyMd(cs.onSurface)),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 18, color: cs.onSurfaceVariant),
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          _FrequencySegment(current: frequency, onChanged: onFrequencyChanged),
        ],
      ),
    );
  }
}

class _FrequencySegment extends StatelessWidget {
  const _FrequencySegment({required this.current, required this.onChanged});

  final SportFrequency current;
  final void Function(SportFrequency) onChanged;

  static const _options = [
    (SportFrequency.casual, 'Casual'),
    (SportFrequency.regular, 'Regular'),
    (SportFrequency.competitive, 'Competitivo'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: _options.map((opt) {
        final (freq, label) = opt;
        final selected = current == freq;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(freq),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: AppSpacing.space1),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
              decoration: BoxDecoration(
                color: selected
                    ? cs.primary.withValues(alpha: 0.15)
                    : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: selected ? cs.primary : Colors.transparent,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: AppTextStyles.labelSm(
                  selected ? cs.primary : cs.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
