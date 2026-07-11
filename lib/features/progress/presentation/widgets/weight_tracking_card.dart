import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

class WeightTrackingCard extends StatelessWidget {
  final double currentWeight;
  final double targetWeight;

  const WeightTrackingCard({
    super.key,
    required this.currentWeight,
    required this.targetWeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    double progress = (targetWeight > 0) ? (currentWeight / targetWeight) : 0.0;
    if (progress > 1.0) progress = 1.0;

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.scale_outlined, color: Colors.grey, size: 20.sp),
                  SizedBox(width: 10.w),
                  Text(
                    l10n.weightTracking,
                    style: AppTextStyles.headlineMd.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
              if (currentWeight > 0 && targetWeight > 0)
                Text(
                  l10n.toGoal((targetWeight - currentWeight).abs().toStringAsFixed(1), l10n.kg), 
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWeightInfo(context, l10n.current, currentWeight.toStringAsFixed(1), l10n.kg),
              _buildWeightInfo(context, l10n.target, targetWeight.toStringAsFixed(1), l10n.kg, alignRight: true),
            ],
          ),
          SizedBox(height: 15.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.brightness == Brightness.dark ? Colors.black : Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8.h,
          ),
        ],
      ),
    );
  }

  Widget _buildWeightInfo(BuildContext context, String label, String val, String unit, {bool alignRight = false}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSm.copyWith(color: Colors.grey)),
        SizedBox(height: 4.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: val,
                style: AppTextStyles.headlineMd.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: AppTextStyles.labelSm.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
