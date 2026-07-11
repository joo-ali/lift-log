import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_colors.dart';

class OnboardingNavigation extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;

  const OnboardingNavigation({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(
              totalPages,
              (index) => Container(
                margin: EdgeInsets.only(right: 8.w),
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index ? AppColors.primary : Colors.grey[300],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text(currentPage == totalPages - 1 ? 'Get Started' : 'Next'),
          ),
        ],
      ),
    );
  }
}
