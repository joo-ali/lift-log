import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class OnboardingWelcomePage extends StatelessWidget {
  const OnboardingWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.r, vertical: 60.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fitness_center, size: 100.sp, color: AppColors.primary),
          SizedBox(height: 40.h),
          Text(
            'Welcome to Lift Log',
            style: AppTextStyles.headlineLg.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Text(
            'Track your workouts and reach your fitness goals with ease.',
            style: AppTextStyles.bodyMd.copyWith(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
