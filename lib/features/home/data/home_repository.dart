import 'package:firebase_auth/firebase_auth.dart';
import 'package:lift_log/data/models/user_model.dart';

import 'package:lift_log/data/data_sources/local/workout_local_data_source.dart';
import 'package:lift_log/data/data_sources/local/user_local_data_source.dart';
import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/features/workout/data/routine_repository.dart';

class HomeRepository {
  final WorkoutLocalDataSource _workoutLocalDataSource;
  final UserLocalDataSource _userLocalDataSource;
  final RoutineRepository _routineRepository = RoutineRepository();

  HomeRepository(this._workoutLocalDataSource, this._userLocalDataSource);

  Future<Map<String, dynamic>> getHomeData(String userId) async {
    final allWorkouts = await _workoutLocalDataSource.getWorkouts();
    final workouts = allWorkouts.where((w) => w.userId == userId).toList();
    var user = await _userLocalDataSource.getUser();
    
    if (user == null) {
      final fbUser = FirebaseAuth.instance.currentUser;
      if (fbUser != null) {
        user = UserModel(
          id: fbUser.uid,
          email: fbUser.email ?? "",
          name: fbUser.displayName ?? fbUser.email?.split('@')[0] ?? "Athlete",
        );
      }
    }

    final activeWorkout = await _workoutLocalDataSource.getActiveWorkout();

    final userActiveWorkout = (activeWorkout != null && activeWorkout.userId == userId) ? activeWorkout : null;

    workouts.sort((a, b) => b.date.compareTo(a.date));

    final nextWorkout = userActiveWorkout ?? await _predictNextWorkout(workouts);
    
    return {
      'userName': user?.name ?? 'Athlete',
      'nextWorkout': nextWorkout.title,
      'nextWorkoutExercises': nextWorkout.exercises.map((e) => e.name).join(', '),
      'streak': calculateStreak(workouts),
      'recentWorkouts': workouts.take(3).toList(),
      'currentWeight': user?.currentWeight ?? 0.0,
      'targetWeight': user?.targetWeight ?? 0.0,
    };
  }

  Future<WorkoutModel> _predictNextWorkout(List<WorkoutModel> history) async {

    final suggestions = await _routineRepository.getSuggestedRoutines();

    if (suggestions.isNotEmpty) {
      if (history.isEmpty) return suggestions.first;
      
      final lastTitle = history.first.title.toLowerCase();
      
      try {
        if (lastTitle.contains('push')) {
          return suggestions.firstWhere((r) => r.title.toLowerCase().contains('pull'), orElse: () => suggestions[0]);
        }
        if (lastTitle.contains('pull')) {
          return suggestions.firstWhere((r) => r.title.toLowerCase().contains('legs'), orElse: () => suggestions[0]);
        }
        // ... باقي منطق التوقع ...
      } catch (e) {
        return suggestions.first;
      }
    }
    
    // لو الـ API مقفول، نستخدم الـ Default
    return suggestions.isNotEmpty ? suggestions.first : _buildFallbackWorkout();
  }

  WorkoutModel _buildFallbackWorkout() {
    return WorkoutModel(
      id: 'default_workout',
      title: _generateDefaultTitle(),
      date: DateTime.now(),
      userId: 'system',
      exercises: [],
    );
  }

  String _generateDefaultTitle() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning Session';
    if (hour < 17) return 'Afternoon Session';
    return 'Evening Session';
  }

  int calculateStreak(List<WorkoutModel> workouts) {
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

