import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class SelectionSearchBar extends StatelessWidget {
  const SelectionSearchBar({
    super.key,
    required this.controller,
    this.hint = 'Buscar…',
    this.resultCount,
  });

  final TextEditingController controller;
  final String hint;
  final int? resultCount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.space3),
          Icon(Icons.search, size: 20, color: cs.onSurfaceVariant),
          const SizedBox(width: AppSpacing.space2),
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.bodyMd(cs.onSurface),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.space3,
                ),
              ),
            ),
          ),
          if (controller.text.isNotEmpty) ...[
            if (resultCount != null)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.space2),
                child: Text(
                  '$resultCount',
                  style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                ),
              ),
            GestureDetector(
              onTap: controller.clear,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space3),
                child: Icon(Icons.close, size: 18, color: cs.onSurfaceVariant),
              ),
            ),
          ] else
            const SizedBox(width: AppSpacing.space3),
        ],
      ),
    );
  }
}
