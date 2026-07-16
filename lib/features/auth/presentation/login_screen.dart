import 'package:flutter/material.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/routes/app_router.dart';
import 'package:lift_log/core/widgets/custom_button.dart';
import 'package:lift_log/core/widgets/custom_text_field.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/features/auth/presentation/widgets/auth_header.dart';
import 'package:lift_log/features/auth/presentation/widgets/auth_footer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess || state is AuthOfflineSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.home,
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),
                  const AuthHeader(
                    title: 'Welcome Back',
                    subtitle: 'Login to track your progress',
                  ),
                  SizedBox(height: 50.h),
                  CustomTextField(
                    label: l10n.email,
                    hint: 'athlete@liftlog.com',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                    enabled: state is! AuthLoading,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    label: l10n.password,
                    hint: '********',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    controller: _passwordController,
                    onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                    enabled: state is! AuthLoading,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: state is AuthLoading ? null : () {},
                      child: Text(
                        l10n.forgotPassword,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  CustomButton(
                    text: l10n.login,
                    isLoading: state is AuthLoading,
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                              context.read<AuthCubit>().login(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                            }
                          },
                  ),
                  SizedBox(height: 24.h),
                  AuthFooter(
                    text: l10n.dontHaveAccount,
                    actionText: l10n.signUp,
                    onActionTap: state is AuthLoading 
                        ? null 
                        : () => Navigator.pushNamed(context, AppRouter.register),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
