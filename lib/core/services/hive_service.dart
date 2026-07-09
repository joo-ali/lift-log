import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/set_entry_model.dart';
import '../../data/models/exercise_model.dart';
import '../../data/models/workout_model.dart';
import '../../data/models/user_model.dart';

class HiveService {
  static const String workoutBox = 'workouts_box';
  static const String settingsBox = 'settings_box';
  static const String userBox = 'user_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters (Generated classes)
    Hive.registerAdapter(SetEntryModelAdapter());
    Hive.registerAdapter(ExerciseModelAdapter());
    Hive.registerAdapter(WorkoutModelAdapter());
    Hive.registerAdapter(UserModelAdapter());

    // Open Boxes
    await Hive.openBox<WorkoutModel>(workoutBox);
    await Hive.openBox<UserModel>(userBox);
    await Hive.openBox(settingsBox);
  }
}
