import 'package:hive_flutter/hive_flutter.dart';
import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/core/services/hive_service.dart';

class WorkoutLocalDataSource {
  Box<WorkoutModel> get _workoutBox => Hive.box<WorkoutModel>(HiveService.workoutBox);

  Future<List<WorkoutModel>> getWorkouts() async {
    return _workoutBox.values.toList();
  }

  Future<void> saveWorkout(WorkoutModel workout) async {
    await _workoutBox.put(workout.id, workout);
  }

  Future<void> deleteWorkout(String id) async {
    await _workoutBox.delete(id);
  }

  Future<void> saveActiveWorkout(WorkoutModel workout) async {
    await _workoutBox.put('active_workout', workout);
  }

  Future<WorkoutModel?> getActiveWorkout() async {
    return _workoutBox.get('active_workout');
  }

  Future<void> deleteActiveWorkout() async {
    await _workoutBox.delete('active_workout');
  }

  Future<void> clearWorkouts() async {
    await _workoutBox.clear();
  }
}
