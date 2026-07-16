import 'package:flutter/material.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class WorkoutHeader extends StatelessWidget {
  const WorkoutHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'LiftLog',
          style: AppTextStyles.headlineMd.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        // Removed settings icon as per request to simplify UI
      ],
    );
  }
}

