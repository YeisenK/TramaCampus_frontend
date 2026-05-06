import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: isDone ? cs.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isDone ? cs.primary : cs.outlineVariant,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: isDone
                  ? Icon(Icons.check, size: 10, color: AppColors.lightOnPrimary)
                  : null,
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      task.code,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: cs.primary,
                        letterSpacing: 0.3,
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
                const SizedBox(height: 2),
                Text(
                  task.title,
                  style: AppTextStyles.bodyMd(cs.onSurface).copyWith(
                    decoration: isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: isDone ? cs.onSurfaceVariant : cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHigh,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        task.assigneeName.isNotEmpty
                            ? task.assigneeName[0]
                            : '?',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space2),
                    Text(
                      task.assigneeName,
                      style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                    ),
                    const Spacer(),
                    Text(
                      task.due,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: isHighPriority
                            ? cs.primary
                            : cs.onSurfaceVariant,
                        fontWeight: isHighPriority
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
