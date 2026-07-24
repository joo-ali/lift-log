import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/l10n/app_localizations.dart';

class ProgressStreakCard extends StatelessWidget {
  final int streak;

  const ProgressStreakCard({
    super.key,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: AppColors.primary, size: 24.sp),
          SizedBox(width: 12.w),
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
                  text: ' ${l10n.days}',
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            l10n.streak,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.primary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


