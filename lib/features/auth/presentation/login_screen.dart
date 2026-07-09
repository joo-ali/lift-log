import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_router.dart';

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
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, AppRouter.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 60.h),
                Container(
                  height: 80.r,
                  width: 80.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(Icons.fitness_center, color: AppColors.primary, size: 40.sp),
                ),
                SizedBox(height: 32.h),
                Text(
                  l10n.loginWelcomeBack,
                  style: AppTextStyles.headlineLg.copyWith(
                    fontWeight: FontWeight.bold, 
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.loginSubtitle,
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.black54),
                ),
                SizedBox(height: 48.h),
                _buildTextField(
                  label: l10n.email,
                  hint: 'athlete@liftlog.com',
                  icon: Icons.email_outlined,
                  controller: _emailController,
                ),
                SizedBox(height: 20.h),
                _buildTextField(
                  label: l10n.password,
                  hint: '********',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
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
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                context.read<AuthCubit>().login(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: state is AuthLoading
                            ? SizedBox(
                                height: 20.r,
                                width: 20.r,
                                child: const CircularProgressIndicator(
                                  color: Colors.white, 
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                l10n.login,
                                style: AppTextStyles.labelLg.copyWith(color: Colors.white),
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        l10n.orContinueWith, 
                        style: AppTextStyles.labelSm.copyWith(color: Colors.black38),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildSocialButton(
                        'Google',
                        'assets/icons/google.png', // Assuming you have these
                        onTap: () => context.read<AuthCubit>().loginWithGoogle(),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildSocialButton(
                        'Apple',
                        'assets/icons/apple.png', 
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${l10n.newToGrind} ", 
                      style: AppTextStyles.bodyMd.copyWith(color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRouter.register),
                      child: Text(
                        l10n.createAccount,
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.primary, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: AppTextStyles.labelSm.copyWith(
            color: Colors.black87, 
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          obscureText: isPassword && _obscurePassword,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black26),
            prefixIcon: Icon(icon, color: Colors.black45),
            suffixIcon: isPassword 
                ? IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.black45,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(String label, String iconPath, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using icons instead of images if paths don't exist yet
            Icon(label == 'Google' ? Icons.g_mobiledata : Icons.apple, size: 28.sp),
            SizedBox(width: 12.w),
            Text(
              label, 
              style: AppTextStyles.bodyMd.copyWith(
                fontWeight: FontWeight.bold, 
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
