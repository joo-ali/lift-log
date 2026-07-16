part of 'workout_cubit.dart';

abstract class WorkoutState {}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutLoaded extends WorkoutState {
  final List<WorkoutModel> workouts;
  final List<WorkoutModel> suggestedRoutines;
  WorkoutLoaded(this.workouts, {this.suggestedRoutines = const []});
}

class WorkoutError extends WorkoutState {
  final String message;
  WorkoutError(this.message);
}

