import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/l10n/app_localizations.dart';

class WeeklyStreakCard extends StatelessWidget {
  final int streak;

  const WeeklyStreakCard({
    super.key,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.weeklyStreak,
            style: AppTextStyles.labelLg.copyWith(color: Colors.grey, fontSize: 10.sp),
          ),
          SizedBox(height: 10.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: streak.toString(),
                  style: AppTextStyles.headlineLg.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' / ${l10n.daysCount(streak).split(' / ').last}',
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          LinearProgressIndicator(
            value: streak / 7,
            backgroundColor: theme.brightness == Brightness.dark ? Colors.black : Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(10),
            minHeight: 6.h,
          ),
        ],
      ),
    );
  }
}


