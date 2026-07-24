import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lift_log/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.surfaceDark,
        onSurface: Colors.white,
        secondary: AppColors.primaryContainer,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFFFCF9F9),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: Color(0xFF1A1A1A),
        secondary: AppColors.primary,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.05)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFCF9F9),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1A1A1A)),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
    );
  }
}
