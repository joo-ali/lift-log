import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

class WorkoutEmptyState extends StatelessWidget {
  const WorkoutEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80.sp,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.noWorkoutsYet,
            style: AppTextStyles.headlineMd.copyWith(color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.startJourney,
            style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
