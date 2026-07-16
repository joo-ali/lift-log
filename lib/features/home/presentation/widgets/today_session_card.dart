import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/l10n/app_localizations.dart';

class TodaySessionCard extends StatelessWidget {
  final String nextWorkout;
  final String? exercises;

  const TodaySessionCard({
    super.key,
    required this.nextWorkout,
    this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.todaySession,
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey, size: 16.sp),
                  SizedBox(width: 4.w),
                  Text('Flexible', style: AppTextStyles.labelSm.copyWith(color: Colors.grey)),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            nextWorkout,
            style: AppTextStyles.headlineLg.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Icon(Icons.fitness_center, color: Colors.grey, size: 20.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  exercises ?? 'Start a new routine to see exercises',
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/add-workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                l10n.continueWorkout,
                style: AppTextStyles.bodyLg.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


