import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lift_log/features/workout/presentation/widgets/workout_empty_state.dart';
import 'package:lift_log/features/workout/presentation/widgets/workout_header.dart';
import 'package:lift_log/features/workout/presentation/widgets/workout_history_card.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'cubit/workout_cubit.dart';
import 'presentation/add_workout_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutCubit>().fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WorkoutHeader(),
              SizedBox(height: 24.h),
              Text(
                l10n.workoutHistory,
                style: AppTextStyles.headlineMd.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<WorkoutCubit, WorkoutState>(
                  builder: (context, state) {
                    if (state is WorkoutLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                    } else if (state is WorkoutLoaded) {
                      if (state.workouts.isEmpty) {
                        return const WorkoutEmptyState();
                      }
                      return ListView.builder(
                        itemCount: state.workouts.length,
                        itemBuilder: (context, index) {
                          final workout = state.workouts[state.workouts.length - 1 - index];
                          return WorkoutHistoryCard(
                            workout: workout,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddWorkoutScreen(workoutToEdit: workout),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else if (state is WorkoutError) {
                      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
