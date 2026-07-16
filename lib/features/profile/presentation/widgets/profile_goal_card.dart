import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/l10n/app_localizations.dart';

class ProfileGoalCard extends StatelessWidget {
  final double currentWeight;
  final double targetWeight;
  final VoidCallback onUpdateCurrent;
  final VoidCallback onUpdateTarget;

  const ProfileGoalCard({
    super.key,
    required this.currentWeight,
    required this.targetWeight,
    required this.onUpdateCurrent,
    required this.onUpdateTarget,
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
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.track_changes, color: Colors.grey, size: 24.sp),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.goalWeight,
                    style: AppTextStyles.labelSm.copyWith(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: onUpdateTarget,
                    child: Text(
                      '$targetWeight ${l10n.kg}',
                      style: AppTextStyles.bodyLg.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.currentWeight,
                    style: AppTextStyles.labelSm.copyWith(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: onUpdateCurrent,
                    child: Text(
                      '$currentWeight ${l10n.kg}',
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          LinearProgressIndicator(
            value: targetWeight > 0 ? (currentWeight / targetWeight).clamp(0.0, 1.0) : 0,
            backgroundColor: theme.brightness == Brightness.dark ? Colors.black : Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8.h,
          ),
        ],
      ),
    );
  }
}


