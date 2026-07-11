import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lift_log/core/routes/app_router.dart';
import 'package:lift_log/core/services/hive_service.dart';
import 'package:lift_log/features/onboarding/presentation/widgets/onboarding_navigation.dart';
import 'package:lift_log/features/onboarding/presentation/widgets/onboarding_welcome_page.dart';
import 'package:lift_log/features/onboarding/presentation/widgets/onboarding_weight_input_page.dart';

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

  void _handleNext() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  const SingleChildScrollView(child: OnboardingWelcomePage()),
                  SingleChildScrollView(
                    child: OnboardingWeightInputPage(
                      currentWeightController: _currentWeightController,
                      targetWeightController: _targetWeightController,
                    ),
                  ),
                ],
              ),
            ),
            OnboardingNavigation(
              currentPage: _currentPage,
              totalPages: 2,
              onNext: _handleNext,
            ),
          ],
        ),
      ),
    );
  }
}
