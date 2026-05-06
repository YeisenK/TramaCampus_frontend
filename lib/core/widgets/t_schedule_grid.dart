import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum ScheduleState { free, maybe, busy }

/// 7-column × 8-row weekly availability heat-map.
/// Cells are 20×20 with 4px radius.
/// free → surfaceContainerHigh, maybe → primary@35%, busy → primary@85%.
class TScheduleGrid extends StatelessWidget {
  const TScheduleGrid({
    super.key,
    required this.schedule,
    this.onCellTap,
  });

  /// [schedule] is a 7×8 matrix: [day][hour], 0 = Mon, 6 = Sun, row 0 = 8am.
  final List<List<ScheduleState>> schedule;
  final void Function(int day, int hour)? onCellTap;

  static const _days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
  static const _hours = ['8', '10', '12', '14', '16', '18', '20', '22'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day headers
        Row(
          children: [
            const SizedBox(width: 24), // room for hour labels
            ...List.generate(_days.length, (d) => Expanded(
              child: Center(
                child: Text(
                  _days[d],
                  style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                ),
              ),
            )),
          ],
        ),
        const SizedBox(height: AppSpacing.space1),
        // Grid rows
        ...List.generate(_hours.length, (h) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  _hours[h],
                  style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 4),
              ...List.generate(_days.length, (d) {
                final state = (schedule.length > d && schedule[d].length > h)
                    ? schedule[d][h]
                    : ScheduleState.free;
                return Expanded(
                  child: GestureDetector(
                    onTap: onCellTap != null ? () => onCellTap!(d, h) : null,
                    child: Container(
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: _cellColor(cs, state),
                        borderRadius: BorderRadius.circular(AppRadius.xs / 2),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        )),
      ],
    );
  }

  Color _cellColor(ColorScheme cs, ScheduleState state) {
    return switch (state) {
      ScheduleState.free => cs.surfaceContainerHigh,
      ScheduleState.maybe => cs.primary.withValues(alpha: 0.35),
      ScheduleState.busy => cs.primary.withValues(alpha: 0.85),
    };
  }
}
