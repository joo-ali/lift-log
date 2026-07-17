import 'package:flutter/material.dart';
import 'package:lift_log/features/auth/presentation/login_screen.dart';
import 'package:lift_log/features/splash/presentation/splash_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}
