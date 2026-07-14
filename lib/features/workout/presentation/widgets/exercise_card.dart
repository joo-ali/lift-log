import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/data/models/exercise_model.dart';
import 'package:lift_log/data/models/set_entry_model.dart';
import 'package:lift_log/l10n/app_localizations.dart';

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
          ...exercise.sets.asMap().entries.map((entry) => _buildSetRow(context, entry.key, entry.value)),
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

  Widget _buildSetRow(BuildContext context, int setIndex, SetEntryModel set) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 40.w,
            child: Text(
              '${setIndex + 1}',
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _buildInputBox(
            context,
            initialValue: set.weight == 0 ? '' : set.weight.toString(),
            onChanged: (val) {
              final weight = double.tryParse(val) ?? 0;
              onSetUpdated(setIndex, weight, set.reps, set.isDone);
            },
          ),
          SizedBox(width: 10.w),
          _buildInputBox(
            context,
            initialValue: set.reps == 0 ? '' : set.reps.toString(),
            onChanged: (val) {
              final reps = int.tryParse(val) ?? 0;
              onSetUpdated(setIndex, set.weight, reps, set.isDone);
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red[400], size: 20.sp),
            onPressed: () => onSetDeleted(setIndex),
          ),
          GestureDetector(
            onTap: () => onSetUpdated(setIndex, set.weight, set.reps, !set.isDone),
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

  Widget _buildInputBox(BuildContext context, {required String initialValue, required Function(String) onChanged}) {
    final theme = Theme.of(context);
    return Container(
      width: 80.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyLg.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.only(top: 8),
        ),
      ),
    );
  }
}
