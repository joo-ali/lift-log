import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/features/progress/presentation/widgets/personal_record_item.dart';
import 'package:lift_log/features/progress/presentation/widgets/progress_header.dart';
import 'package:lift_log/features/progress/presentation/widgets/progress_streak_card.dart';
import 'package:lift_log/features/progress/presentation/widgets/volume_progression_chart.dart';
import 'package:lift_log/features/progress/presentation/widgets/weight_tracking_card.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/widgets/section_title.dart';
import 'package:lift_log/core/widgets/empty_state_widget.dart';
import 'package:lift_log/core/widgets/stat_card.dart';
import 'package:lift_log/features/progress/cubit/progress_cubit.dart';
import 'package:lift_log/core/di/service_locator.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => sl<ProgressCubit>()..loadProgress(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<ProgressCubit, ProgressState>(
            builder: (context, state) {
              if (state is ProgressLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              if (state is ProgressError) {
                return Center(child: Text(state.message, style: TextStyle(color: theme.colorScheme.onSurface)));
              }
              if (state is ProgressLoaded) {
                final data = state.data;
                final l10n = AppLocalizations.of(context)!;
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProgressHeader(),
                      SizedBox(height: 30.h),
                      SectionTitle(title: l10n.yourProgress),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.trackGains,
                        style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                      ),
                      SizedBox(height: 25.h),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: l10n.totalWorkouts,
                              value: data['totalWorkouts'].toString(),
                              icon: Icons.calendar_today_outlined,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: StatCard(
                              title: l10n.totalVolume,
                              value: (data['totalVolume'] / 1000).toStringAsFixed(1) + 'k',
                              unit: l10n.kg,
                              icon: Icons.fitness_center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      ProgressStreakCard(streak: data['streak'] ?? 0),
                      SizedBox(height: 30.h),
                      VolumeProgressionChart(
                        workouts: List<WorkoutModel>.from(data['workouts'] ?? []),
                      ),
                      SizedBox(height: 30.h),
                      SectionTitle(title: l10n.personalRecords),
                      SizedBox(height: 15.h),
                      if ((data['personalRecords'] as Map).isEmpty)
                        const EmptyStateWidget(
                          message: "No personal records yet. Keep lifting!",
                        )
                      else
                        ...(data['personalRecords'] as Map<String, double>).entries.map((e) {
                          return PersonalRecordItem(
                            icon: Icons.fitness_center,
                            title: e.key,
                            subtitle: '1RM',
                            value: e.value.toString(),
                            unit: l10n.kg,
                          );
                        }),
                      SizedBox(height: 30.h),
                      WeightTrackingCard(
                        currentWeight: data['currentWeight'] ?? 0.0,
                        targetWeight: data['targetWeight'] ?? 0.0,
                      ),
                      SizedBox(height: 20.h),
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
