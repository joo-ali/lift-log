import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/features/workout/data/workout_repository.dart';
import 'package:lift_log/features/workout/data/routine_repository.dart';
import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final WorkoutRepository _workoutRepository;
  final RoutineRepository _routineRepository;
  final AuthCubit _authCubit;
  StreamSubscription? _authSubscription;

  WorkoutCubit(this._workoutRepository, this._routineRepository, this._authCubit) : super(WorkoutInitial()) {
    _authSubscription = _authCubit.stream.listen((authState) {
      if (authState is AuthSuccess || authState is AuthOfflineSuccess) {
        fetchWorkouts();
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  String? get _userId {
    final authState = _authCubit.state;
    if (authState is AuthSuccess) {
      return authState.user?.uid;
    } else if (authState is AuthOfflineSuccess) {
      return authState.user.id;
    }
    return null;
  }

  Future<void> fetchWorkouts() async {
    String? userId = _userId ?? FirebaseAuth.instance.currentUser?.uid;

    emit(WorkoutLoading());
    try {
      // بنجيب الاقتراحات أولاً لأنها بيانات عامة مش محتاجة Login
      final suggestions = await _routineRepository.getSuggestedRoutines();
      
      List<WorkoutModel> workouts = [];
      // لو اليوزر مسجل دخول، نجيب الـ History بتاعه
      if (userId != null) {
        workouts = await _workoutRepository.getWorkouts(userId);
      }

      emit(WorkoutLoaded(workouts, suggestedRoutines: suggestions));
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> addWorkout(WorkoutModel workout) async {
    try {
      await _workoutRepository.saveWorkout(workout);
      if (workout.userId == _userId) {
        fetchWorkouts();
      }
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> deleteWorkout(String id) async {
    try {
      await _workoutRepository.deleteWorkout(id, userId: _userId);
      fetchWorkouts();
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    try {
      await _workoutRepository.saveWorkout(workout);
      if (workout.userId == _userId) {
        fetchWorkouts();
      }
    } catch (e) {
      emit(WorkoutError(e.toString()));
    }
  }

  Future<List<WorkoutModel>> getWorkoutsList() async {
    final userId = _userId;
    if (userId == null) return [];
    return await _workoutRepository.getWorkouts(userId);
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
