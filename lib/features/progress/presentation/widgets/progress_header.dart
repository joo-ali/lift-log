import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(Icons.person, color: AppColors.primary, size: 20.sp),
        ),
        Text(
          'LiftLog',
          style: AppTextStyles.headlineMd.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 40), // Placeholder to maintain alignment after removing settings icon
      ],
    );
  }
}


