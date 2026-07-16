import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/features/workout/presentation/widgets/workout_empty_state.dart';
import 'package:lift_log/features/workout/presentation/widgets/workout_header.dart';
import 'package:lift_log/features/workout/presentation/widgets/workout_history_card.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/features/workout/cubit/workout_cubit.dart';
import 'package:lift_log/features/workout/presentation/add_workout_screen.dart';
import 'package:lift_log/core/routes/app_router.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.addWorkout),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WorkoutHeader(),
              SizedBox(height: 24.h),
              
              // قسم الـ Suggested Splits من الـ API
              Text(
                "Suggested Routines", // ممكن نستخدم l10n بعدين
                style: AppTextStyles.headlineMd.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 150.h, // زودنا الارتفاع عشان نمنع الـ Overflow
                child: BlocBuilder<WorkoutCubit, WorkoutState>(
                  builder: (context, state) {
                    if (state is WorkoutLoaded && state.suggestedRoutines.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(vertical: 8.h), // مساحة للـ Shadow
                        itemCount: state.suggestedRoutines.length,
                        itemBuilder: (context, index) {
                          final routine = state.suggestedRoutines[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddWorkoutScreen(workoutToEdit: routine),
                                ),
                              );
                            },
                            child: Container(
                              width: 190.w, // عرض مناسب
                              margin: EdgeInsets.only(right: 16.w),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    routine.title,
                                    style: AppTextStyles.bodyLg.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    "${routine.exercises.length} Exercises",
                                    style: AppTextStyles.labelSm.copyWith(color: Colors.white70),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Text(
                                          "Quick Start",
                                          style: TextStyle(color: Colors.white, fontSize: 10.sp),
                                        ),
                                      ),
                                      Icon(Icons.play_circle_fill, color: Colors.white, size: 32.sp),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: Text(
                        "Loading routines...",
                        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      ),
                    );
                  },
                ),
              ),

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

