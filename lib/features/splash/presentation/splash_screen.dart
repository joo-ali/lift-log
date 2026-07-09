import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_router.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:lift_log/core/services/hive_service.dart';

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

    final settingsBox = Hive.box(HiveService.settingsBox);
    final bool seenOnboarding = settingsBox.get('seenOnboarding', defaultValue: false);

    if (!seenOnboarding) {
      Navigator.pushReplacementNamed(context, AppRouter.onboarding);
      return;
    }

    final state = context.read<AuthCubit>().state;
    _handleNavigation(state);
  }

  void _handleNavigation(AuthState state) {
    if (!mounted) return;
    
    if (state is AuthSuccess) {
      Navigator.pushReplacementNamed(context, AppRouter.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {},
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lift Log',
                style: AppTextStyles.displayLg.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 42.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'TRACK YOUR GAINS',
                style: AppTextStyles.labelSm.copyWith(
                  color: isDark ? Colors.white70 : Colors.black54,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
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
      ),
    );
  }
}
