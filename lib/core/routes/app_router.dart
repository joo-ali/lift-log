import 'package:flutter/material.dart';
import 'package:lift_log/features/auth/presentation/login_screen.dart';
import 'package:lift_log/features/auth/presentation/register_screen.dart';
import 'package:lift_log/features/onboarding/onboarding_screen.dart';
import 'package:lift_log/features/profile/profile_screen.dart';
import 'package:lift_log/features/progress/progress_screen.dart';
import 'package:lift_log/features/splash/presentation/splash_screen.dart';
import 'package:lift_log/features/workout/workout_screen.dart';
import 'package:lift_log/features/main/presentation/main_layout.dart';
import 'package:lift_log/features/workout/presentation/add_workout_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String workout = '/workout';
  static const String progress = '/progress';
  static const String profile = '/profile';
  static const String addWorkout = '/add-workout';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const MainLayout());
      case workout:
        return MaterialPageRoute(builder: (_) => const WorkoutScreen());
      case progress:
        return MaterialPageRoute(builder: (_) => const ProgressScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case addWorkout:
        return MaterialPageRoute(builder: (_) => const AddWorkoutScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
