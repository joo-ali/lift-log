import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/data/data_sources/local/workout_local_data_source.dart';

class WorkoutRepository {
  final WorkoutLocalDataSource _localDataSource;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  WorkoutRepository(this._localDataSource);

  Future<void> syncWorkoutsFromCloud(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .get();

      for (var doc in snapshot.docs) {
        final workout = WorkoutModel.fromMap(doc.data());
        await _localDataSource.saveWorkout(workout);
      }
    } catch (e) {
      print("Error syncing workouts: $e");
    }
  }

  Future<List<WorkoutModel>> getWorkouts(String userId) async {
    final workouts = await _localDataSource.getWorkouts();
    return workouts.where((w) => w.userId == userId).toList();
  }

  Future<void> saveWorkout(WorkoutModel workout) async {
    await _localDataSource.saveWorkout(workout);
    // رفع التمرين للسحاب لضمان المزامنة
    try {
      if (workout.userId.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(workout.userId)
            .collection('workouts')
            .doc(workout.id)
            .set(workout.toMap());
      }
    } catch (e) {
      print("Error uploading workout: $e");
    }
  }

  Future<void> deleteWorkout(String id, {String? userId}) async {
    await _localDataSource.deleteWorkout(id);
    if (userId != null && userId.isNotEmpty && id != 'active_workout') {
      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('workouts')
            .doc(id)
            .delete();
      } catch (e) {
        print("Error deleting workout from cloud: $e");
      }
    }
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

