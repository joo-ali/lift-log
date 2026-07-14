import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/routes/app_router.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
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
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final weight = double.tryParse(_currentWeightController.text) ?? 0.0;
      final age = int.tryParse(_ageController.text) ?? 0;
      context.read<AuthCubit>().completeOnboarding(weight, age);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, AppRouter.home);
        }
      },
      child: Scaffold(
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
                        ageController: _ageController,
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
      ),
    );
  }
}
