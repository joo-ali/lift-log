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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _currentWeightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess || state is AuthOfflineSuccess) {
          // بمجرد ما يخلص تسجيل، بيدخله الهوم علطول زي ما طلبت
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
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
                  AuthHeader(
                    title: l10n.registerTitle,
                    subtitle: l10n.registerSubtitle,
                    showLogo: false,
                  ),
                  SizedBox(height: 40.h),
                  CustomTextField(
                    label: l10n.fullName,
                    hint: 'Alex J. Murphy',
                    icon: Icons.person_outline,
                    controller: _nameController,
                    enabled: state is! AuthLoading, // بنقفل الحقول وقت التحميل
                  ),
                  SizedBox(height: 20.h),
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
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: l10n.currentWeight,
                          hint: '0.0',
                          icon: Icons.scale_outlined,
                          controller: _currentWeightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          enabled: state is! AuthLoading,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: CustomTextField(
                          label: l10n.goalWeight,
                          hint: '0.0',
                          icon: Icons.track_changes_outlined,
                          controller: _targetWeightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          enabled: state is! AuthLoading,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  CustomButton(
                    text: l10n.signUp,
                    isLoading: state is AuthLoading,
                    onPressed: state is AuthLoading 
                      ? null 
                      : () {
                          if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                            context.read<AuthCubit>().register(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              _nameController.text.trim(),
                              currentWeight: double.tryParse(_currentWeightController.text) ?? 0.0,
                              targetWeight: double.tryParse(_targetWeightController.text) ?? 0.0,
                            );
                          }
                        },
                  ),
                  SizedBox(height: 24.h),
                  AuthFooter(
                    text: l10n.alreadyHaveAccount,
                    actionText: l10n.login,
                    onActionTap: state is AuthLoading ? null : () => Navigator.pop(context),
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
