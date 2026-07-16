import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/data/models/exercise_model.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import 'package:lift_log/features/workout/presentation/widgets/exercise_set_row.dart';

class ExerciseCard extends StatelessWidget {
  final int index;
  final ExerciseModel exercise;
  final Function(String) onNameChanged;
  final VoidCallback onAddSet;
  final Function(int, double, int, bool) onSetUpdated;
  final Function(int) onSetDeleted;

  const ExerciseCard({
    super.key,
    required this.index,
    required this.exercise,
    required this.onNameChanged,
    required this.onAddSet,
    required this.onSetUpdated,
    required this.onSetDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200.w,
                    child: TextFormField(
                      initialValue: exercise.name,
                      onChanged: onNameChanged,
                      style: AppTextStyles.headlineMd.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Text(
                    '${exercise.category} · Barbell', // Category and equipment placeholder
                    style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              Icon(Icons.more_vert, color: Colors.grey, size: 20.sp),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              _headerCell(l10n.set, 40.w),
              _headerCell('${l10n.weight} (${l10n.kg})'.toUpperCase(), 80.w),
              _headerCell(l10n.reps.toUpperCase(), 80.w),
              const Spacer(),
              _headerCell(l10n.done.toUpperCase(), 50.w),
            ],
          ),
          SizedBox(height: 10.h),
          ...exercise.sets.asMap().entries.map((entry) => ExerciseSetRow(
                index: entry.key,
                set: entry.value,
                onUpdate: (weight, reps, isDone) => onSetUpdated(entry.key, weight, reps, isDone),
                onDelete: () => onSetDeleted(entry.key),
              )),
          SizedBox(height: 15.h),
          GestureDetector(
            onTap: onAddSet,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.2),
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.grey, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(l10n.addSet, style: AppTextStyles.bodyMd.copyWith(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(String label, double width) {
    return SizedBox(
      width: width,
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
