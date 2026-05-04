import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 't_button.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.message = 'Algo salió mal. Por favor intenta de nuevo.',
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: cs.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, size: 32, color: cs.error),
            ),
            const SizedBox(height: AppSpacing.space5),
            Text(
              'Ocurrió un error',
              style: AppTextStyles.titleMd(cs.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              message,
              style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.space6),
              TButton(
                label: 'Intentar de nuevo',
                onPressed: onRetry,
                variant: TButtonVariant.secondary,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
