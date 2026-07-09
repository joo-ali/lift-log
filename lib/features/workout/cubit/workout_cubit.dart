import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/workout_repository.dart';
import '../../../data/models/workout_model.dart';

part 'workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final WorkoutRepository _workoutRepository;

  WorkoutCubit(this._workoutRepository) : super(WorkoutInitial());

  Future<void> fetchWorkouts() async {
    emit(WorkoutLoading());
    try {
      final workouts = await _workoutRepository.getWorkouts();
      emit(WorkoutLoaded(workouts));
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> addWorkout(WorkoutModel workout) async {
    try {
      await _workoutRepository.saveWorkout(workout);
      fetchWorkouts();
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> deleteWorkout(String id) async {
    try {
      await _workoutRepository.deleteWorkout(id);
      fetchWorkouts();
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    try {
      await _workoutRepository.saveWorkout(workout);
      fetchWorkouts();
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> saveActiveWorkout(WorkoutModel workout) async {
    try {
      await _workoutRepository.saveActiveWorkout(workout);
    } catch (e) {
      // Background save error, maybe just log it
    }
  }

  Future<WorkoutModel?> getActiveWorkout() async {
    return await _workoutRepository.getActiveWorkout();
  }

  Future<void> clearActiveWorkout() async {
    await _workoutRepository.deleteActiveWorkout();
  }
}
