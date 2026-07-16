import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/widgets/custom_button.dart';
import 'package:lift_log/core/widgets/custom_text_field.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/features/auth/presentation/widgets/auth_header.dart';
import 'package:lift_log/features/auth/presentation/widgets/auth_footer.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/core/routes/app_router.dart';

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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess || state is AuthOfflineSuccess) {
          if (state is AuthOfflineSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Working in Offline Mode"),
                backgroundColor: Colors.orange,
              ),
            );
          }
          Navigator.pushReplacementNamed(context, AppRouter.home);
        } else if (state is AuthNetworkError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.orange),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 60.h),
                AuthHeader(
                  title: l10n.loginWelcomeBack,
                  subtitle: l10n.loginSubtitle,
                ),
                SizedBox(height: 48.h),
                CustomTextField(
                  label: l10n.email,
                  hint: 'athlete@liftlog.com',
                  icon: Icons.email_outlined,
                  controller: _emailController,
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
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      l10n.forgotPassword,
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: l10n.login,
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        context.read<AuthCubit>().login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                      },
                    );
                  },
                ),
                SizedBox(height: 48.h),
                AuthFooter(
                  text: l10n.newToGrind,
                  actionText: l10n.createAccount,
                  onActionTap: () => Navigator.pushNamed(context, AppRouter.register),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
