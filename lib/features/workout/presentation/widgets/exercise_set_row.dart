import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/data/models/set_entry_model.dart';

import 'package:lift_log/core/widgets/custom_input_box.dart';

class ExerciseSetRow extends StatelessWidget {
  final int index;
  final SetEntryModel set;
  final Function(double, int, bool) onUpdate;
  final VoidCallback onDelete;

  const ExerciseSetRow({
    super.key,
    required this.index,
    required this.set,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 40.w,
            child: Text(
              '${index + 1}',
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          CustomInputBox(
            initialValue: set.weight == 0 ? '' : set.weight.toString(),
            onChanged: (val) {
              final weight = double.tryParse(val) ?? 0;
              onUpdate(weight, set.reps, set.isDone);
            },
          ),
          SizedBox(width: 10.w),
          CustomInputBox(
            initialValue: set.reps == 0 ? '' : set.reps.toString(),
            onChanged: (val) {
              final reps = int.tryParse(val) ?? 0;
              onUpdate(set.weight, reps, set.isDone);
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red[400], size: 20.sp),
            onPressed: onDelete,
          ),
          GestureDetector(
            onTap: () => onUpdate(set.weight, set.reps, !set.isDone),
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: set.isDone ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: set.isDone ? AppColors.primary : Colors.grey.withValues(alpha: 0.3),
                ),
              ),
              child: set.isDone ? Icon(Icons.check, color: Colors.white, size: 16.sp) : null,
            ),
          ),
        ],
      ),
    );
  }
}


