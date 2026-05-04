import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class ConfirmModal {
  ConfirmModal._();

  /// Shows a glass-blur bottom sheet with confirm/cancel actions.
  /// Returns `true` if confirmed, `false` if cancelled, `null` if dismissed.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirmar',
    String cancelLabel = 'Cancelar',
    bool destructive = false,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ConfirmSheet(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        destructive: destructive,
      ),
    );
  }
}

class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.destructive,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xl),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: cs.surfaceContainerLowest.withValues(alpha: 0.92),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.space6,
            AppSpacing.space6,
            AppSpacing.space6,
            AppSpacing.space6 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.space5),
              Text(title, style: AppTextStyles.titleMd(cs.onSurface)),
              const SizedBox(height: AppSpacing.space2),
              Text(message, style: AppTextStyles.bodyMd(cs.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.space6),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cs.onSurface,
                        side: BorderSide(color: cs.outlineVariant),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.space4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text(
                        cancelLabel,
                        style: AppTextStyles.titleMd(cs.onSurface),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: destructive ? cs.error : cs.primary,
                        foregroundColor: destructive
                            ? cs.onError
                            : cs.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.space4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        confirmLabel,
                        style: AppTextStyles.titleMd(
                          destructive ? cs.onError : cs.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
