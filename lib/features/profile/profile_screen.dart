import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lift_log/core/widgets/custom_dialog.dart';
import 'package:lift_log/core/widgets/custom_text_field.dart';
import 'package:lift_log/features/profile/cubit/profile_state.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_goal_card.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_info_widget.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_stats_grid.dart';
import 'package:lift_log/features/profile/presentation/widgets/profile_top_bar.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/di/service_locator.dart';
import 'package:lift_log/features/profile/cubit/profile_cubit.dart';
import 'package:lift_log/l10n/app_localizations.dart';

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
                      // Logout Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                            foregroundColor: Colors.redAccent,
                            elevation: 0,
                            minimumSize: Size(double.infinity, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () async {
                            await context.read<ProfileCubit>().logout();
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.logout,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
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
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentName);
    final profileCubit = context.read<ProfileCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog(
        title: l10n.editName,
        actionText: l10n.save,
        onActionPressed: () {
          profileCubit.updateProfile(name: controller.text.trim());
          Navigator.pop(dialogContext);
        },
        content: CustomTextField(
          label: l10n.username,
          hint: l10n.enterName,
          icon: Icons.person_outline,
          controller: controller,
        ),
      ),
    );
  }

  void _showUpdateWeightDialog(BuildContext context, double currentWeight, {required bool isTarget}) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentWeight.toString());
    final profileCubit = context.read<ProfileCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => CustomDialog(
        title: isTarget ? l10n.updateGoalWeight : l10n.updateCurrentWeight,
        actionText: l10n.save,
        onActionPressed: () {
          final newWeight = double.tryParse(controller.text) ?? currentWeight;
          if (isTarget) {
            profileCubit.updateGoalWeight(newWeight);
          } else {
            profileCubit.updateCurrentWeight(newWeight);
          }
          Navigator.pop(dialogContext);
        },
        content: CustomTextField(
          label: isTarget ? l10n.goalWeight : l10n.weightCurrent,
          hint: '0.0',
          icon: Icons.monitor_weight_outlined,
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: l10n.kg,
        ),
      ),
    );
  }
}
