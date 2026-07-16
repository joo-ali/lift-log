import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/utils/responsive.dart';
import 'package:lift_log/features/workout/presentation/widgets/exercise_card.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';
import 'package:lift_log/core/constants/app_colors.dart';
import 'package:lift_log/core/constants/app_text_styles.dart';
import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/data/models/exercise_model.dart';
import 'package:lift_log/data/models/set_entry_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/features/workout/cubit/workout_cubit.dart';
import 'package:lift_log/features/workout/data/routine_repository.dart';

class AddWorkoutScreen extends StatefulWidget {
  final WorkoutModel? workoutToEdit;
  const AddWorkoutScreen({super.key, this.workoutToEdit});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  late TextEditingController _titleController;
  late List<ExerciseModel> _exercises;
  List<WorkoutModel> _suggestedRoutines = [];

  @override
  void initState() {
    super.initState();
    
    if (widget.workoutToEdit != null) {
      _titleController = TextEditingController(text: widget.workoutToEdit!.title);
      _exercises = List<ExerciseModel>.from(widget.workoutToEdit!.exercises);
    } else {
      _titleController = TextEditingController(text: _generateDefaultTitle());
      _exercises = [];
      _loadLastSessionExercises();
    }
    
    _fetchSuggestedRoutines();
    _titleController.addListener(_autoSave);
  }

  Future<void> _fetchSuggestedRoutines() async {
    final routines = await RoutineRepository().getSuggestedRoutines();
    if (mounted) {
      setState(() {
        _suggestedRoutines = routines;
      });
    }
  }

  Future<void> _loadLastSessionExercises() async {
    final workouts = await context.read<WorkoutCubit>().getWorkoutsList();
    final currentTitle = _titleController.text.trim();
    
    if (currentTitle.isEmpty) return;

    try {
      final suggested = _suggestedRoutines.firstWhere(
        (r) => r.title.toLowerCase().contains(currentTitle.toLowerCase()),
      );
      if (_exercises.isEmpty) { 
        setState(() {
          _exercises = suggested.exercises.map((ex) => ExerciseModel(
            id: const Uuid().v4(),
            name: ex.name,
            category: ex.category,
            sets: ex.sets.map((s) => SetEntryModel(weight: s.weight, reps: s.reps)).toList(),
          )).toList();
        });
        _autoSave();
        return;
      }
    } catch (_) {}

    final sortedWorkouts = List<WorkoutModel>.from(workouts)
      ..sort((a, b) => b.date.compareTo(a.date));

    try {
      final lastSimilarWorkout = sortedWorkouts.firstWhere(
        (w) => w.title.toLowerCase() == currentTitle.toLowerCase() && w.id != 'active_workout',
      );

      if (lastSimilarWorkout.exercises.isNotEmpty) {
        setState(() {
          _exercises = lastSimilarWorkout.exercises.map((ex) => ExerciseModel(
            id: const Uuid().v4(),
            name: ex.name,
            category: ex.category,
            sets: ex.sets.map((s) => SetEntryModel(
              weight: s.weight, 
              reps: s.reps,
              isDone: false,
            )).toList(),
          )).toList();
        });
        _autoSave();
      }
    } catch (e) {
      // No similar workout found
    }
  }

  String _generateDefaultTitle() {
    final l10n = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.morningSession;
    if (hour < 17) return l10n.afternoonSession;
    return l10n.eveningSession;
  }

  void _addExercise() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _exercises.add(ExerciseModel(
        id: const Uuid().v4(),
        name: l10n.newExercise,
        category: 'Others',
        sets: [SetEntryModel(weight: 0, reps: 0)],
      ));
    });
    _autoSave();
  }

  void _updateSet(int exIndex, int setIndex, double weight, int reps, bool isDone) {
    setState(() {
      final sets = List<SetEntryModel>.from(_exercises[exIndex].sets);
      sets[setIndex] = SetEntryModel(weight: weight, reps: reps, isDone: isDone);
      _exercises[exIndex] = ExerciseModel(
        id: _exercises[exIndex].id,
        name: _exercises[exIndex].name,
        category: _exercises[exIndex].category,
        sets: sets,
      );
    });
    _autoSave();
  }

  void _deleteSet(int exIndex, int setIndex) {
    setState(() {
      final sets = List<SetEntryModel>.from(_exercises[exIndex].sets);
      sets.removeAt(setIndex);
      _exercises[exIndex] = ExerciseModel(
        id: _exercises[exIndex].id,
        name: _exercises[exIndex].name,
        category: _exercises[exIndex].category,
        sets: sets,
      );
    });
    _autoSave();
  }

  void _addSet(int exerciseIndex) {
    setState(() {
      final sets = List<SetEntryModel>.from(_exercises[exerciseIndex].sets);
      sets.add(SetEntryModel(weight: 0, reps: 0));
      _exercises[exerciseIndex] = ExerciseModel(
        id: _exercises[exerciseIndex].id,
        name: _exercises[exerciseIndex].name,
        category: _exercises[exerciseIndex].category,
        sets: sets,
      );
    });
    _autoSave();
  }

  double _calculateTotalVolume() {
    return _exercises.fold(0, (sum, exercise) => sum + exercise.totalVolume);
  }

  void _autoSave() {
    final authState = context.read<AuthCubit>().state;
    String? userId;
    if (authState is AuthSuccess) {
      userId = authState.user?.uid;
    } else if (authState is AuthOfflineSuccess) {
      userId = authState.user.id;
    }
    
    userId ??= FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final workout = WorkoutModel(
      id: widget.workoutToEdit?.id ?? 'active_workout',
      title: _titleController.text,
      date: widget.workoutToEdit?.date ?? DateTime.now(),
      exercises: _exercises,
      userId: userId,
    );
    context.read<WorkoutCubit>().saveActiveWorkout(workout);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.appName.toUpperCase(),
          style: AppTextStyles.headlineMd.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        l10n.activeSession,
                        style: AppTextStyles.labelLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _titleController,
                    onChanged: (val) {
                      if (_exercises.isEmpty) {
                        _loadLastSessionExercises();
                      }
                    },
                    style: AppTextStyles.headlineLg.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: l10n.activeSession,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.fitness_center, size: 16.r, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        "Total Volume: ${_calculateTotalVolume().toStringAsFixed(0)} kg",
                        style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  if (_suggestedRoutines.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _suggestedRoutines.map((routine) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: _routineChip(routine.title),
                          );
                        }).toList(),
                      ),
                    ),
                  SizedBox(height: 15.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      return ExerciseCard(
                        index: index,
                        exercise: _exercises[index],
                        onNameChanged: (val) {
                          _exercises[index] = ExerciseModel(
                            id: _exercises[index].id,
                            name: val,
                            category: _exercises[index].category,
                            sets: _exercises[index].sets,
                          );
                          _autoSave();
                        },
                        onAddSet: () => _addSet(index),
                        onSetUpdated: (setIndex, weight, reps, isDone) => _updateSet(index, setIndex, weight, reps, isDone),
                        onSetDeleted: (setIndex) => _deleteSet(index, setIndex),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  OutlinedButton.icon(
                    onPressed: _addExercise,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addExercise),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ElevatedButton.icon(
          onPressed: () {
            final authState = context.read<AuthCubit>().state;
            String? userId;
            if (authState is AuthSuccess) {
              userId = authState.user?.uid;
            } else if (authState is AuthOfflineSuccess) {
              userId = authState.user.id;
            }
            
            userId ??= FirebaseAuth.instance.currentUser?.uid;
            if (userId == null) return;

            final workout = WorkoutModel(
              id: widget.workoutToEdit?.id ?? const Uuid().v4(),
              title: _titleController.text,
              date: widget.workoutToEdit?.date ?? DateTime.now(),
              exercises: _exercises,
              userId: userId,
            );
            if (widget.workoutToEdit != null) {
              context.read<WorkoutCubit>().updateWorkout(workout);
            } else {
              context.read<WorkoutCubit>().addWorkout(workout);
              context.read<WorkoutCubit>().clearActiveWorkout();
            }
            Navigator.pop(context);
          },
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          label: Text(
            l10n.finishWorkout,
            style: AppTextStyles.bodyLg.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: Size(double.infinity, 60.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
          ),
        ),
      ),
    );
  }

  Widget _routineChip(String title) {
    final isSelected = _titleController.text.toLowerCase() == title.toLowerCase();
    return GestureDetector(
      onTap: () {
        setState(() {
          _titleController.text = title;
        });
        _loadLastSessionExercises();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          title,
          style: AppTextStyles.labelLg.copyWith(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


