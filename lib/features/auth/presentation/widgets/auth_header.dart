import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showLogo;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        if (showLogo) ...[
          Container(
            height: 80.r,
            width: 80.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(Icons.fitness_center, color: AppColors.primary, size: 40.sp),
          ),
          SizedBox(height: 32.h),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineLg.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.displayLarge?.color,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMd.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}


