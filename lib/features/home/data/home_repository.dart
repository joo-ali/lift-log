import '../../../data/data_sources/local/workout_local_data_source.dart';
import '../../../data/data_sources/local/user_local_data_source.dart';
import '../../../data/models/workout_model.dart';

class HomeRepository {
  final WorkoutLocalDataSource _workoutLocalDataSource;
  final UserLocalDataSource _userLocalDataSource;

  HomeRepository(this._workoutLocalDataSource, this._userLocalDataSource);

  Future<Map<String, dynamic>> getHomeData() async {
    final workouts = await _workoutLocalDataSource.getWorkouts();
    final user = await _userLocalDataSource.getUser();
    final activeWorkout = await _workoutLocalDataSource.getActiveWorkout();
    
    // ترتيب التمارين من الأحدث للأقدم
    workouts.sort((a, b) => b.date.compareTo(a.date));
    
    final lastActivity = workouts.isNotEmpty 
        ? "${workouts.first.title} (${_formatDate(workouts.first.date)})" 
        : 'No activity yet';
    
    // اسم الجلسة: إما التمرين النشط حالياً أو اسم مقترح بناءً على الوقت
    final String nextWorkoutTitle = activeWorkout?.title ?? _generateDefaultTitle();
    
    return {
      'userName': user?.name ?? 'Athlete',
      'lastActivity': lastActivity,
      'nextWorkout': nextWorkoutTitle, 
      'streak': calculateStreak(workouts),
      'recentWorkouts': workouts.take(3).toList(),
      'currentWeight': user?.weight ?? 0.0,
    };
  }

  String _generateDefaultTitle() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning Session';
    if (hour < 17) return 'Afternoon Session';
    return 'Evening Session';
  }

  int calculateStreak(List<WorkoutModel> workouts) {
    if (workouts.isEmpty) return 0;

    // استخراج التواريخ الفريدة فقط بدون الوقت
    final workoutDates = workouts
        .map((w) => DateTime(w.date.year, w.date.month, w.date.day))
        .toSet()
        .toList();
    
    workoutDates.sort((a, b) => b.compareTo(a)); // من الأحدث للأقدم

    int streak = 0;
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime checkDate = today;

    // لو مفيش تمرين النهاردة، بنبدأ نشيك من إمبارح
    if (!workoutDates.contains(today)) {
      checkDate = today.subtract(const Duration(days: 1));
    }

    for (var date in workoutDates) {
      if (date.isAtSameMomentAs(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(checkDate)) {
        break; // الـ Streak انقطع
      }
    }

    return streak;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    return "${date.day}/${date.month}";
  }

  Future<List<WorkoutModel>> getWorkouts() async {
    return await _workoutLocalDataSource.getWorkouts();
  }
}
