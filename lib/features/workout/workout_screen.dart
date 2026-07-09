import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'cubit/workout_cubit.dart';
import 'presentation/add_workout_screen.dart';
import '../../../data/models/workout_model.dart';
import '../../../data/models/exercise_model.dart';

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
              _buildHeader(context),
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
                        return _buildEmptyState(context);
                      }
                      return ListView.builder(
                        itemCount: state.workouts.length,
                        itemBuilder: (context, index) {
                          final workout = state.workouts[state.workouts.length - 1 - index];
                          return _buildWorkoutHistoryCard(context, workout);
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'LiftLog',
          style: AppTextStyles.headlineMd.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80.sp, color: Colors.grey.withValues(alpha: 0.3)),
          SizedBox(height: 16.h),
          Text(
            l10n.noWorkoutsYet,
            style: AppTextStyles.headlineMd.copyWith(color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.startJourney,
            style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutHistoryCard(BuildContext context, WorkoutModel workout) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddWorkoutScreen(workoutToEdit: workout),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16.r),
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
                Expanded(
                  child: Text(
                    workout.title,
                    style: AppTextStyles.headlineMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  DateFormat('MMM dd').format(workout.date),
                  style: AppTextStyles.labelSm.copyWith(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: workout.exercises.take(3).map((e) => _buildExerciseTag(context, e)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseTag(BuildContext context, ExerciseModel exercise) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        exercise.name,
        style: AppTextStyles.labelSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
      ),
    );
  }
}
