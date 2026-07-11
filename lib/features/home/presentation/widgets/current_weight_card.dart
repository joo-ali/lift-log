import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/l10n/app_localizations.dart';

class CurrentWeightCard extends StatelessWidget {
  final dynamic weight;

  const CurrentWeightCard({
    super.key,
    required this.weight,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.scale, color: Colors.grey, size: 18.sp),
              Text(
                l10n.currentWeight,
                style: AppTextStyles.labelLg.copyWith(color: Colors.grey, fontSize: 10.sp),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: weight.toString(),
                  style: AppTextStyles.headlineLg.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' ${l10n.kg}',
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            l10n.keepGoing,
            style: AppTextStyles.labelSm.copyWith(color: AppColors.primary, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
