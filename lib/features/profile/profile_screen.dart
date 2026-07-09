import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_log/features/profile/cubit/profile_state.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/localization/locale_cubit.dart';
import 'cubit/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..loadProfile(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }

              if (state is ProfileError) {
                return Center(child: Text(state.message, style: TextStyle(color: theme.colorScheme.onSurface)));
              }

              if (state is ProfileLoaded) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    children: [
                      _buildTopBar(context),
                      SizedBox(height: 25.h),
                      _buildProfileInfo(context, state),
                      SizedBox(height: 25.h),
                      _buildStatsGrid(context, state),
                      SizedBox(height: 25.h),
                      _buildGoalWeightCard(context, state),
                      SizedBox(height: 25.h),
                      _buildSettingsList(context),
                      SizedBox(height: 30.h),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
        ),
        Text(
          l10n.profile,
          style: AppTextStyles.headlineMd.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        GestureDetector(
          onTap: () {
            final state = context.read<ProfileCubit>().state;
            if (state is ProfileLoaded) {
              _showEditProfileDialog(context, state.user.name);
            }
          },
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit_outlined, color: AppColors.primary, size: 20.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(BuildContext context, ProfileLoaded state) {
    final theme = Theme.of(context);
    final cubit = context.read<ProfileCubit>();
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [if (theme.brightness == Brightness.light) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 55.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: CircleAvatar(
                  radius: 52.r,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: state.user.profilePic != null && state.user.profilePic!.isNotEmpty
                      ? (state.user.profilePic!.startsWith('http') 
                          ? NetworkImage(state.user.profilePic!) as ImageProvider
                          : FileImage(File(state.user.profilePic!)))
                      : null,
                  child: state.user.profilePic == null || state.user.profilePic!.isEmpty
                      ? Icon(Icons.person, size: 50.sp, color: Colors.grey)
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _pickImage(cubit),
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 16.sp),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            state.user.name,
            style: AppTextStyles.headlineMd.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            state.user.email,
            style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ProfileCubit cubit) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // لتقليل مساحة الصورة وتحسين الأداء
      );
      
      if (image != null) {
        await cubit.updateProfile(profilePic: image.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _showEditProfileDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    final profileCubit = context.read<ProfileCubit>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your name',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              profileCubit.updateProfile(name: controller.text.trim());
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, ProfileLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.fitness_center,
            value: state.workoutCount.toString(),
            label: l10n.workoutsCount,
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.local_fire_department_outlined,
            value: state.streak.toString(),
            label: l10n.streak,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, {required IconData icon, required String value, required String label}) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [if (theme.brightness == Brightness.light) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28.sp),
          SizedBox(height: 12.h),
          Text(
            value,
            style: AppTextStyles.headlineLg.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalWeightCard(BuildContext context, ProfileLoaded state) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final user = state.user;
    
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [if (theme.brightness == Brightness.light) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.track_changes, color: Colors.grey, size: 24.sp),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.goalWeight,
                    style: AppTextStyles.labelSm.copyWith(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () => _showUpdateWeightDialog(context, user.targetWeight, isTarget: true),
                    child: Text(
                      '${user.targetWeight} ${l10n.kg}',
                      style: AppTextStyles.bodyLg.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.currentWeight,
                    style: AppTextStyles.labelSm.copyWith(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () => _showUpdateWeightDialog(context, user.currentWeight, isTarget: false),
                    child: Text(
                      '${user.currentWeight} ${l10n.kg}',
                      style: AppTextStyles.bodyLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          LinearProgressIndicator(
            value: user.targetWeight > 0 ? (user.currentWeight / user.targetWeight).clamp(0.0, 1.0) : 0,
            backgroundColor: theme.brightness == Brightness.dark ? Colors.black : Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8.h,
          ),
        ],
      ),
    );
  }

  void _showUpdateWeightDialog(BuildContext context, double currentWeight, {required bool isTarget}) {
    final controller = TextEditingController(text: currentWeight.toString());
    final profileCubit = context.read<ProfileCubit>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: Text(isTarget ? 'Update Goal Weight' : 'Update Current Weight'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            suffixText: 'kg',
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newWeight = double.tryParse(controller.text) ?? currentWeight;
              if (isTarget) {
                profileCubit.updateGoalWeight(newWeight);
              } else {
                profileCubit.updateCurrentWeight(newWeight);
              }
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [if (theme.brightness == Brightness.light) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            icon: Icons.settings_outlined,
            title: l10n.settings,
            onTap: () {},
          ),
          Divider(color: theme.brightness == Brightness.dark ? Colors.black26 : Colors.grey[100], height: 1),
          _buildSettingsItem(
            context,
            icon: Icons.language,
            title: l10n.language,
            trailing: BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) {
                return Text(
                  locale.languageCode == 'ar' ? 'العربية' : 'English',
                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary),
                );
              },
            ),
            onTap: () {
              context.read<LocaleCubit>().toggleLocale();
            },
          ),
          Divider(color: theme.brightness == Brightness.dark ? Colors.black26 : Colors.grey[100], height: 1),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return _buildSettingsItem(
                context,
                icon: Icons.dark_mode_outlined,
                title: l10n.darkMode,
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  activeThumbColor: AppColors.primary,
                  onChanged: (value) {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                ),
              );
            },
          ),
          Divider(color: theme.brightness == Brightness.dark ? Colors.black26 : Colors.grey[100], height: 1),
          _buildSettingsItem(
            context,
            icon: Icons.info_outline,
            title: l10n.aboutApp,
            onTap: () {},
          ),
          Divider(color: theme.brightness == Brightness.dark ? Colors.black26 : Colors.grey[100], height: 1),
          _buildSettingsItem(
            context,
            icon: Icons.logout,
            title: l10n.logout,
            titleColor: AppColors.primary,
            iconColor: AppColors.primary,
            showChevron: false,
            onTap: () async {
              await context.read<ProfileCubit>().logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? titleColor,
    Color? iconColor,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.7), size: 22.sp),
      title: Text(
        title,
        style: AppTextStyles.bodyLg.copyWith(color: titleColor ?? theme.colorScheme.onSurface),
      ),
      trailing: trailing ?? (showChevron ? Icon(Icons.chevron_right, color: Colors.grey, size: 20.sp) : null),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
    );
  }
}
