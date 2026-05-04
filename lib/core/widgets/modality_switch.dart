import 'package:flutter/material.dart';
import '../../data/models/modality.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class ModalitySwitch extends StatelessWidget {
  const ModalitySwitch({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ModalityType selected;
  final ValueChanged<ModalityType> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      child: Row(
        children: Modality.all.map((m) {
          final isSelected = m.type == selected;
          return GestureDetector(
            onTap: () => onChanged(m.type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: AppSpacing.space2),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space3,
                vertical: AppSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: isSelected ? cs.primary : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    m.icon,
                    size: 16,
                    color: isSelected ? Colors.white : cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.space1),
                  Text(
                    m.label,
                    style: AppTextStyles.labelSm(
                      isSelected ? Colors.white : cs.onSurfaceVariant,
                    ).copyWith(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
