import '../../../data/models/workout_model.dart';
import '../../../data/data_sources/local/workout_local_data_source.dart';

class WorkoutRepository {
  final WorkoutLocalDataSource _localDataSource;

  WorkoutRepository(this._localDataSource);

  Future<List<WorkoutModel>> getWorkouts() async {
    return await _localDataSource.getWorkouts();
  }

  Future<void> saveWorkout(WorkoutModel workout) async {
    await _localDataSource.saveWorkout(workout);
  }

  Future<void> deleteWorkout(String id) async {
    await _localDataSource.deleteWorkout(id);
  }

  Future<void> saveActiveWorkout(WorkoutModel workout) async {
    await _localDataSource.saveActiveWorkout(workout);
  }

  Future<WorkoutModel?> getActiveWorkout() async {
    return await _localDataSource.getActiveWorkout();
  }

  Future<void> deleteActiveWorkout() async {
    await _localDataSource.deleteActiveWorkout();
  }
}
