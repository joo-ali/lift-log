import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
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
          // Navigate to onboarding to set goals after registration
          Navigator.pushReplacementNamed(context, AppRouter.onboarding);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  l10n.registerTitle,
                  style: AppTextStyles.headlineLg.copyWith(
                    fontWeight: FontWeight.bold, 
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.registerSubtitle,
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.black54),
                ),
                SizedBox(height: 40.h),
                _buildTextField(
                  label: l10n.fullName,
                  hint: 'Alex J. Murphy',
                  icon: Icons.person_outline,
                  controller: _nameController,
                ),
                SizedBox(height: 20.h),
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
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                context.read<AuthCubit>().register(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                      _nameController.text.trim(),
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
                                l10n.signUp,
                                style: AppTextStyles.labelLg.copyWith(color: Colors.white),
                              ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${l10n.alreadyHaveAccount} ", 
                      style: AppTextStyles.bodyMd.copyWith(color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        l10n.login,
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.primary, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
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
}
