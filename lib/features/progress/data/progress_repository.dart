import 'package:lift_log/data/data_sources/local/workout_local_data_source.dart';
import 'package:lift_log/data/data_sources/local/user_local_data_source.dart';
import 'package:lift_log/data/models/workout_model.dart';

class ProgressRepository {
  final WorkoutLocalDataSource _workoutLocalDataSource;
  final UserLocalDataSource _userLocalDataSource;

  ProgressRepository(this._workoutLocalDataSource, this._userLocalDataSource);

  Future<Map<String, dynamic>> getProgressData(String userId) async {
    final allWorkouts = await _workoutLocalDataSource.getWorkouts();
    final workouts = allWorkouts.where((w) => w.userId == userId).toList();
    final user = await _userLocalDataSource.getUser();
    
    double totalVolume = 0;
    Map<String, double> personalRecords = {};

    // Sort workouts by date ascending for the chart
    workouts.sort((a, b) => a.date.compareTo(b.date));

    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        double exerciseVolume = 0;
        for (var set in exercise.sets) {
          // تأكد من وجود قيم صالحة للحساب
          final weight = set.weight;
          final reps = set.reps;
          double volume = weight * reps;
          exerciseVolume += volume;
          
          // تحديث الـ PR بناءً على أثقل وزن تم رفعه لهذا التمرين
          if (!personalRecords.containsKey(exercise.name) || weight > personalRecords[exercise.name]!) {
            personalRecords[exercise.name] = weight;
          }
        }
        totalVolume += exerciseVolume;
      }
    }

    // Calculating streak using the logic in HomeRepository (re-using if possible or duplicating)
    // Since ProgressRepository doesn't have HomeRepository instance easily, we can use a helper or duplicate simple logic
    int streak = _calculateStreak(workouts);

    return {
      'totalWorkouts': workouts.length,
      'totalVolume': totalVolume,
      'personalRecords': personalRecords,
      'workouts': workouts, 
      'streak': streak,
      'currentWeight': user?.currentWeight ?? 0.0,
      'targetWeight': user?.targetWeight ?? 0.0,
    };
  }

  int _calculateStreak(List<WorkoutModel> workouts) {
    if (workouts.isEmpty) return 0;
    final workoutDates = workouts
        .map((w) => DateTime(w.date.year, w.date.month, w.date.day))
        .toSet()
        .toList();
    workoutDates.sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime checkDate = today;
    if (!workoutDates.contains(today)) {
      checkDate = today.subtract(const Duration(days: 1));
    }
    for (var date in workoutDates) {
      if (date.isAtSameMomentAs(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(checkDate)) {
        break;
      }
    }
    return streak;
  }
}
