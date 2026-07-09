import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/core/routes/app_router.dart';
import 'package:lift_log/features/auth/data/auth_repository.dart';
import 'package:lift_log/core/di/service_locator.dart';
import 'package:lift_log/core/services/hive_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final TextEditingController _currentWeightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // يضمن أن الشاشة تتفاعل مع لوحة المفاتيح
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  SingleChildScrollView(child: _buildWelcomePage()),
                  SingleChildScrollView(child: _buildWeightInputPage()),
                ],
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
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

  Widget _buildWeightInputPage() {
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
          _buildWeightField('Current Weight (kg)', _currentWeightController),
          SizedBox(height: 20.h),
          _buildWeightField('Target Weight (kg)', _targetWeightController),
          SizedBox(height: 20.h), // مساحة إضافية لمنع التداخل مع الأزرار
        ],
      ),
    );
  }

  Widget _buildWeightField(String label, TextEditingController controller) {
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

  Widget _buildBottomNavigation() {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(
              2,
              (index) => Container(
                margin: EdgeInsets.only(right: 8.w),
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? AppColors.primary : Colors.grey[300],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_currentPage < 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                final settingsBox = Hive.box(HiveService.settingsBox);
                await settingsBox.put('seenOnboarding', true);
                await settingsBox.put('temp_current_weight', double.tryParse(_currentWeightController.text) ?? 0.0);
                await settingsBox.put('temp_target_weight', double.tryParse(_targetWeightController.text) ?? 0.0);
                
                if (mounted) {
                  Navigator.pushReplacementNamed(context, AppRouter.login);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text(_currentPage == 1 ? 'Get Started' : 'Next'),
          ),
        ],
      ),
    );
  }
}
