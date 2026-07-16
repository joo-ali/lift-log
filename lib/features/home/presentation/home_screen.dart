import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/di/service_locator.dart';
import 'package:lift_log/features/home/cubit/home_cubit.dart';
import 'package:lift_log/core/widgets/section_title.dart';
import 'package:lift_log/core/widgets/empty_state_widget.dart';
import 'package:lift_log/core/widgets/stat_card.dart';
import 'package:lift_log/features/home/presentation/widgets/activity_item.dart';
import 'package:lift_log/features/home/presentation/widgets/header_widget.dart';
import 'package:lift_log/features/home/presentation/widgets/today_session_card.dart';
import 'package:lift_log/l10n/app_localizations.dart';

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
                      HeaderWidget(userName: data['userName'] ?? 'Athlete'),
                      SizedBox(height: 25.h),
                      TodaySessionCard(
                        nextWorkout: data['nextWorkout'],
                        exercises: data['nextWorkoutExercises'],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: l10n.weeklyStreak,
                              value: data['streak'].toString(),
                              unit: '/ ${l10n.daysCount(7).split(' / ').last}',
                              progress: (data['streak'] as int) / 7,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: StatCard(
                              title: l10n.currentWeight,
                              value: data['currentWeight'].toString(),
                              unit: l10n.kg,
                              icon: Icons.scale,
                              subtitle: '${l10n.target}: ${data['targetWeight']} ${l10n.kg}',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.h),
                      SectionTitle(title: l10n.recentActivity),
                      SizedBox(height: 15.h),
                      if ((data['recentWorkouts'] as List).isEmpty)
                        EmptyStateWidget(
                          message: "No workouts yet. Start your journey!",
                        )
                      else
                        ...(data['recentWorkouts'] as List).map((w) {
                          return ActivityItem(
                            title: w.title,
                            subtitle: l10n.done,
                            weight: '${w.totalVolume.toStringAsFixed(0)} ${l10n.kg}',
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
}
