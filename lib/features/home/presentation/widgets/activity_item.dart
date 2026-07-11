import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String weight;

  const ActivityItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark ? Colors.black : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.fitness_center, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLg.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(subtitle, style: AppTextStyles.bodyMd.copyWith(color: Colors.grey)),
            ],
          ),
          const Spacer(),
          Text(
            weight,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
