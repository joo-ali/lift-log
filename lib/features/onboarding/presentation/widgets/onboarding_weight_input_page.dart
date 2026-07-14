import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';

class OnboardingWeightInputPage extends StatelessWidget {
  final TextEditingController currentWeightController;
  final TextEditingController targetWeightController;
  final TextEditingController ageController;

  const OnboardingWeightInputPage({
    super.key,
    required this.currentWeightController,
    required this.targetWeightController,
    required this.ageController,
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
            'Tell us more about you',
            style: AppTextStyles.headlineLg.copyWith(color: Colors.black),
          ),
          SizedBox(height: 10.h),
          Text(
            'This helps us calculate your progress accurately.',
            style: AppTextStyles.bodyMd.copyWith(color: Colors.black54),
          ),
          SizedBox(height: 40.h),
          _InputField(label: 'Age', controller: ageController, hint: 'e.g. 25'),
          SizedBox(height: 20.h),
          _InputField(label: 'Current Weight (kg)', controller: currentWeightController, hint: '0.0'),
          SizedBox(height: 20.h),
          _InputField(label: 'Target Weight (kg)', controller: targetWeightController, hint: '0.0'),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const _InputField({
    required this.label,
    required this.controller,
    required this.hint,
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
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
