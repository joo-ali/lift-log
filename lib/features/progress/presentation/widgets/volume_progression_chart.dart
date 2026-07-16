import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/l10n/app_localizations.dart';

import 'package:lift_log/core/widgets/custom_line_chart.dart';

class VolumeProgressionChart extends StatelessWidget {
  final List<WorkoutModel> workouts;

  const VolumeProgressionChart({
    super.key,
    required this.workouts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final recentWorkouts = workouts.length > 7 ? workouts.sublist(workouts.length - 7) : workouts;
    final List<double> volumes = recentWorkouts.map((w) => w.totalVolume).toList();
    final labels = recentWorkouts.map((w) => DateFormat('E', locale).format(w.date)).toList();

    return Container(
      constraints: BoxConstraints(minHeight: 200.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.volumeProgression,
            style: AppTextStyles.headlineMd.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30.h),
          if (volumes.isEmpty)
            Center(
              child: Text(
                l10n.addWorkoutsToSeeProgress,
                style: const TextStyle(color: Colors.grey),
              ),
            )
          else
            SizedBox(
              height: 150.h,
              child: Stack(
                children: [
                  CustomLineChart(
                    data: volumes,
                    color: AppColors.primary,
                    height: 150.h,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: labels.map((day) {
                        return Text(
                          day,
                          style: AppTextStyles.labelSm.copyWith(color: Colors.grey),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
