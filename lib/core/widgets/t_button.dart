import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Button height per size.
enum TButtonSize {
  xs, // 32px — icon-only or tight inline actions
  sm, // 40px — inline actions
  md, // 48px — standard action
  lg, // 56px — primary CTA (default)
}

extension _TButtonSizeHeight on TButtonSize {
  double get height => switch (this) {
    TButtonSize.xs => 32,
    TButtonSize.sm => 40,
    TButtonSize.md => 48,
    TButtonSize.lg => 56,
  };
}

class TButton extends StatelessWidget {
  const TButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = TButtonVariant.primary,
    this.size = TButtonSize.lg,
    this.isFullWidth = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final TButtonVariant variant;
  final TButtonSize size;
  final bool isFullWidth;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: size.height,
      child: switch (variant) {
        TButtonVariant.primary => _GradientButton(
          label: label,
          icon: icon,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
        ),
        TButtonVariant.secondary => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: cs.onSurface,
            side: BorderSide(color: cs.outlineVariant),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          child: _ButtonContent(
            label: label,
            icon: icon,
            isLoading: isLoading,
            color: cs.onSurface,
          ),
        ),
        TButtonVariant.ghost => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: cs.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          child: _ButtonContent(
            label: label,
            icon: icon,
            isLoading: isLoading,
            color: cs.primary,
          ),
        ),
      },
    );
  }
}

enum TButtonVariant { primary, secondary, ghost }

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          decoration: BoxDecoration(
            gradient: onPressed == null
                ? null
                : AppColors.ctaGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            color: onPressed == null
                ? Colors.grey.withValues(alpha: 0.3)
                : null,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: _ButtonContent(
            label: label,
            icon: icon,
            isLoading: isLoading,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.isLoading,
    required this.color,
    this.icon,
  });

  final String label;
  final bool isLoading;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(color: color, strokeWidth: 2),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: color),
          const SizedBox(width: AppSpacing.space2),
        ],
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.titleMd(color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
