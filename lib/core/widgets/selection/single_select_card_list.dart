import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

// Generic single-select card list (extracted from select_uni_screen.dart pattern).
class SingleSelectCardOption {
  const SingleSelectCardOption({
    required this.id,
    required this.label,
    this.subtitle,
    this.icon,
    this.trailing,
  });

  final String id;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
}

class SingleSelectCardList extends StatelessWidget {
  const SingleSelectCardList({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelect,
  });

  final List<SingleSelectCardOption> options;
  final String? selectedId;
  final void Function(String id) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options
          .map((opt) => _OptionCard(
                option: opt,
                isSelected: opt.id == selectedId,
                onTap: () => onSelect(opt.id),
              ))
          .toList(),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final SingleSelectCardOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.space3),
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (option.icon != null) ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? cs.primary.withValues(alpha: 0.12)
                      : cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  option.icon,
                  size: 20,
                  color: isSelected ? cs.primary : cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.label,
                      style: AppTextStyles.bodyMd(cs.onSurface)),
                  if (option.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(option.subtitle!,
                        style:
                            AppTextStyles.bodySm(cs.onSurfaceVariant)),
                  ],
                ],
              ),
            ),
            if (option.trailing != null)
              option.trailing!
            else if (isSelected)
              Icon(Icons.check_circle, color: cs.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
