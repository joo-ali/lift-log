import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? unit;
  final IconData? icon;
  final double? progress;
  final bool isVertical;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.unit,
    this.icon,
    this.progress,
    this.isVertical = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
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
        child: isVertical ? _buildVerticalLayout(theme) : _buildHorizontalLayout(theme),
      ),
    );
  }

  Widget _buildVerticalLayout(ThemeData theme) {
    return Column(
      children: [
        if (icon != null) ...[
          Icon(icon, color: AppColors.primary, size: 28.sp),
          SizedBox(height: 12.h),
        ],
        Text(
          value,
          style: AppTextStyles.headlineLg.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: AppTextStyles.labelSm.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null) Icon(icon, color: Colors.grey, size: 18.sp),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.labelLg.copyWith(
                  color: Colors.grey,
                  fontSize: 10.sp,
                ),
                textAlign: icon != null ? TextAlign.right : TextAlign.left,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: AppTextStyles.headlineLg.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unit != null)
                TextSpan(
                  text: ' $unit',
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                ),
            ],
          ),
        ),
        if (progress != null) ...[
          SizedBox(height: 15.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.brightness == Brightness.dark ? Colors.black : Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(10),
            minHeight: 6.h,
          ),
        ],
        if (subtitle != null) ...[
          SizedBox(height: 10.h),
          Text(
            subtitle!,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.primary,
              fontSize: 10.sp,
            ),
          ),
        ],
      ],
    );
  }
}
