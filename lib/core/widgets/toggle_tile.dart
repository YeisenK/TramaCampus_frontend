import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class ToggleTile extends StatelessWidget {
  const ToggleTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: cs.onSurfaceVariant),
      ),
      title: Text(label, style: AppTextStyles.bodyMd(cs.onSurface)),
      subtitle: subtitle != null ? Text(subtitle!, style: AppTextStyles.labelSm(cs.onSurfaceVariant)) : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: cs.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4, vertical: AppSpacing.space1),
    );
  }
}
