import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/data/models/exercise_model.dart';
import 'package:lift_log/data/models/set_entry_model.dart';
import 'package:uuid/uuid.dart';
import 'routine_service.dart';

class RoutineRepository {
  final RoutineService _routineService = RoutineService();

  Future<List<WorkoutModel>> getSuggestedRoutines() async {
    // 1. محاولة جلب البيانات من Firestore (API)
    final remoteRoutines = await _routineService.getRemoteSuggestedRoutines();
    
    if (remoteRoutines.isNotEmpty) {
      return remoteRoutines;
    }

    // 2. Fallback: البيانات المحلية في حال عدم وجود إنترنت أو خطأ في الـ API
    return [
      _buildRoutine('Push Day', 'Chest, Shoulders, Triceps', [
        {'name': 'Bench Press', 'cat': 'Chest', 'w': 40, 'r': 10},
        {'name': 'Overhead Press', 'cat': 'Shoulders', 'w': 20, 'r': 12},
      ]),
      _buildRoutine('Pull Day', 'Back, Biceps', [
        {'name': 'Lat Pulldown', 'cat': 'Back', 'w': 35, 'r': 12},
        {'name': 'Bicep Curls', 'cat': 'Arms', 'w': 10, 'r': 15},
      ]),
      _buildRoutine('Legs Day', 'Quads, Hamstrings', [
        {'name': 'Squat', 'cat': 'Legs', 'w': 50, 'r': 10},
      ]),
      _buildRoutine('Full Body', 'Complete Workout', [
        {'name': 'Deadlift', 'cat': 'Back', 'w': 60, 'r': 5},
        {'name': 'Bench Press', 'cat': 'Chest', 'w': 40, 'r': 10},
        {'name': 'Squat', 'cat': 'Legs', 'w': 50, 'r': 10},
      ]),
    ];
  }

  WorkoutModel _buildRoutine(String title, String category, List<Map<String, dynamic>> exData) {
    return WorkoutModel(
      id: 'suggested_${title.toLowerCase().replaceAll(' ', '_')}',
      title: title,
      date: DateTime.now(),
      userId: 'system',
      exercises: exData.map((e) => ExerciseModel(
        id: const Uuid().v4(),
        name: e['name'],
        category: e['cat'],
        sets: [SetEntryModel(weight: (e['w'] as num).toDouble(), reps: e['r'])],
      )).toList(),
    );
  }
}

