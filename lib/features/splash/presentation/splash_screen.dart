import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/core/routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startNavigationLogic();
  }

  void _startNavigationLogic() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final authState = context.read<AuthCubit>().state;
    
    if (authState is AuthSuccess || authState is AuthOfflineSuccess) {
      Navigator.pushReplacementNamed(context, AppRouter.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 150.w,
              height: 150.h,
            ),
            SizedBox(height: 24.h),
            Text(
              'Lift Log',
              style: AppTextStyles.displayLg.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontSize: 32.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'TRACK YOUR GAINS',
              style: AppTextStyles.labelSm.copyWith(
                color: isDark ? Colors.white70 : Colors.black54,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 60.h),
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}

