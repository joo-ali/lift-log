import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_log/features/profile/cubit/profile_state.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_goal_card.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_info_widget.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_settings_list.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_stats_grid.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_top_bar.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
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
                      ProfileTopBar(
                        onBack: () => Navigator.pop(context),
                        onEdit: () => _showEditProfileDialog(context, state.user.name),
                      ),
                      SizedBox(height: 25.h),
                      ProfileInfoWidget(
                        user: state.user,
                        onPickImage: () => _pickImage(context.read<ProfileCubit>()),
                      ),
                      SizedBox(height: 25.h),
                      ProfileStatsGrid(
                        workoutCount: state.workoutCount,
                        streak: state.streak,
                      ),
                      SizedBox(height: 25.h),
                      ProfileGoalCard(
                        currentWeight: state.user.currentWeight,
                        targetWeight: state.user.targetWeight,
                        onUpdateCurrent: () => _showUpdateWeightDialog(context, state.user.currentWeight, isTarget: false),
                        onUpdateTarget: () => _showUpdateWeightDialog(context, state.user.targetWeight, isTarget: true),
                      ),
                      SizedBox(height: 25.h),
                      ProfileSettingsList(
                        onLogout: () async {
                          await context.read<ProfileCubit>().logout();
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                          }
                        },
                      ),
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

  Future<void> _pickImage(ProfileCubit cubit) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
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
}
