import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class TTextField extends StatelessWidget {
  const TTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.enabled = true,
    this.obscureText = false,
    this.onChanged,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
        const SizedBox(height: AppSpacing.space2),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          enabled: enabled,
          obscureText: obscureText,
          onChanged: onChanged,
          style: AppTextStyles.bodyMd(cs.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMd(
              cs.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: cs.onSurfaceVariant)
                : null,
            filled: true,
            fillColor: cs.surfaceContainerLowest,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space4,
              vertical: AppSpacing.space4,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: cs.error),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
