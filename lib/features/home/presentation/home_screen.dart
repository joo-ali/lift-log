import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/di/service_locator.dart';
import 'package:lift_log/core/theme/theme_cubit.dart';
import 'package:lift_log/features/home/cubit/home_cubit.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadHomeData(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              if (state is HomeError) {
                return Center(child: Text(state.message, style: TextStyle(color: theme.colorScheme.onSurface)));
              }
              if (state is HomeLoaded) {
                final data = state.data;
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      SizedBox(height: 25.h),
                      _buildTodaySessionCard(context, data['nextWorkout']),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(child: _buildWeeklyStreakCard(context, data['streak'])),
                          SizedBox(width: 15.w),
                          Expanded(child: _buildCurrentWeightCard(context, data['currentWeight'] ?? 0)),
                        ],
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        l10n.recentActivity,
                        style: AppTextStyles.headlineMd.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      ...(data['recentWorkouts'] as List).map((w) {
                        return _buildActivityItem(
                          context,
                          w.title,
                          l10n.done,
                          '${w.totalVolume.toStringAsFixed(0)} ${l10n.kg}',
                        );
                      }),
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

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        String userName = 'Athlete';
        if (state is HomeLoaded) {
          userName = state.data['userName'] ?? 'Athlete';
        }
        return Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(Icons.person, color: AppColors.primary, size: 28.sp),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcomeBack,
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                ),
                Text(
                  userName,
                  style: AppTextStyles.headlineMd.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              icon: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (theme.brightness == Brightness.light)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                  ],
                ),
                child: Icon(
                  theme.brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
                  color: theme.colorScheme.onSurface,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodaySessionCard(BuildContext context, String nextWorkout) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.todaySession,
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey, size: 16.sp),
                  SizedBox(width: 4.w),
                  Text('10:00 AM', style: AppTextStyles.labelSm.copyWith(color: Colors.grey)),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            nextWorkout,
            style: AppTextStyles.headlineLg.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Icon(Icons.fitness_center, color: Colors.grey, size: 20.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Squats, Leg Press, Lunges + 2 more',
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/add-workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                l10n.continueWorkout,
                style: AppTextStyles.bodyLg.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStreakCard(BuildContext context, int streak) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.weeklyStreak,
            style: AppTextStyles.labelLg.copyWith(color: Colors.grey, fontSize: 10.sp),
          ),
          SizedBox(height: 10.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: streak.toString(),
                  style: AppTextStyles.headlineLg.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' / ${l10n.daysCount(streak).split(' / ').last}',
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          LinearProgressIndicator(
            value: streak / 7,
            backgroundColor: theme.brightness == Brightness.dark ? Colors.black : Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            borderRadius: BorderRadius.circular(10),
            minHeight: 6.h,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeightCard(BuildContext context, dynamic weight) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.scale, color: Colors.grey, size: 18.sp),
              Text(
                l10n.currentWeight,
                style: AppTextStyles.labelLg.copyWith(color: Colors.grey, fontSize: 10.sp),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: weight.toString(),
                  style: AppTextStyles.headlineLg.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' ${l10n.kg}',
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            l10n.keepGoing,
            style: AppTextStyles.labelSm.copyWith(color: AppColors.primary, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, String title, String subtitle, String weight) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark ? Colors.black : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.fitness_center, color: AppColors.primary, size: 20.sp),
          ),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLg.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(subtitle, style: AppTextStyles.bodyMd.copyWith(color: Colors.grey)),
            ],
          ),
          const Spacer(),
          Text(
            weight,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
