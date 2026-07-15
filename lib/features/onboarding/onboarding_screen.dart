import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:lift_log/core/routes/app_router.dart';
import 'package:lift_log/core/services/hive_service.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/features/onboarding/presentation/widgets/onboarding_navigation.dart';
import 'package:lift_log/features/onboarding/presentation/widgets/onboarding_info_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // حفظ الحالة محلياً فوراً لضمان عدم تكرار الأونبوردينج
      final settingsBox = Hive.box(HiveService.settingsBox);
      settingsBox.put('seenOnboarding', true);
      context.read<AuthCubit>().completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess || state is AuthOfflineSuccess) {
          Navigator.pushReplacementNamed(context, AppRouter.home);
        } else if (state is Unauthenticated) {
          Navigator.pushReplacementNamed(context, AppRouter.login);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  children: const [
                    OnboardingInfoPage(
                      icon: Icons.fitness_center,
                      title: 'Welcome to Lift Log',
                      description: 'Your ultimate companion for strength training and muscle building.',
                    ),
                    OnboardingInfoPage(
                      icon: Icons.auto_awesome,
                      title: 'Smart Routines',
                      description: 'Choose from expert-designed splits or easily repeat your own successful sessions.',
                    ),
                    OnboardingInfoPage(
                      icon: Icons.cloud_sync,
                      title: 'Cloud Synchronization',
                      description: 'Your workout history is always safe and synced across all your devices.',
                    ),
                  ],
                ),
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return OnboardingNavigation(
                    currentPage: _currentPage,
                    totalPages: 3,
                    onNext: _handleNext,
                    isLoading: state is AuthLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
