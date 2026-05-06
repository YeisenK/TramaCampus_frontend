import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/task.dart';

class TaskRow extends StatelessWidget {
  const TaskRow({super.key, required this.task, this.onToggle});

  final Task task;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDone = task.status == TaskStatus.done;
    final isHighPriority = task.priority == TaskPriority.high && !isDone;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space2,
          vertical: AppSpacing.space3,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _CheckCircle(status: task.status, cs: cs),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMd(cs.onSurface).copyWith(
                            fontWeight: FontWeight.w500,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: isDone
                                ? cs.onSurfaceVariant
                                : cs.onSurface,
                          ),
                        ),
                      ),
                      if (isHighPriority) ...[
                        const SizedBox(width: AppSpacing.space2),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: cs.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        task.code,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurfaceVariant,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        '  ·  ',
                        style: AppTextStyles.labelSm(cs.outlineVariant),
                      ),
                      Flexible(
                        child: Text(
                          task.assigneeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Text(
              task.due,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: isHighPriority
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: isDone
                    ? cs.onSurfaceVariant.withValues(alpha: 0.6)
                    : isHighPriority
                        ? cs.primary
                        : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  const _CheckCircle({required this.status, required this.cs});
  final TaskStatus status;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case TaskStatus.done:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: cs.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(Icons.check, size: 13, color: cs.onPrimary),
        );
      case TaskStatus.inProgress:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: cs.primary, width: 1.6),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: cs.primary,
              shape: BoxShape.circle,
            ),
          ),
        );
      case TaskStatus.todo:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: cs.outlineVariant, width: 1.5),
          ),
        );
    }
  }
}
