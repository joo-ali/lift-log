import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class OnboardingWeightInputPage extends StatelessWidget {
  final TextEditingController currentWeightController;
  final TextEditingController targetWeightController;

  const OnboardingWeightInputPage({
    super.key,
    required this.currentWeightController,
    required this.targetWeightController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.r, vertical: 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Your Goals',
            style: AppTextStyles.headlineLg.copyWith(color: Colors.black),
          ),
          SizedBox(height: 10.h),
          Text(
            'Tell us about your weight goals.',
            style: AppTextStyles.bodyMd.copyWith(color: Colors.black54),
          ),
          SizedBox(height: 40.h),
          _WeightField(label: 'Current Weight (kg)', controller: currentWeightController),
          SizedBox(height: 20.h),
          _WeightField(label: 'Target Weight (kg)', controller: targetWeightController),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class _WeightField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _WeightField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLg.copyWith(color: Colors.black87)),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            hintText: '0.0',
          ),
        ),
      ],
    );
  }
}
