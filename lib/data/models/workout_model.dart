import 'package:hive/hive.dart';
import 'exercise_model.dart';

part 'workout_model.g.dart';

@HiveType(typeId: 2)
class WorkoutModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final List<ExerciseModel> exercises;

  WorkoutModel({
    required this.id,
    required this.title,
    required this.date,
    required this.exercises,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) => WorkoutModel(
        id: json['id'],
        title: json['title'],
        date: DateTime.parse(json['date']),
        exercises: (json['exercises'] as List)
            .map((i) => ExerciseModel.fromJson(i))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'exercises': exercises.map((i) => i.toJson()).toList(),
      };

  double get totalVolume {
    return exercises.fold(0, (sum, exercise) => sum + exercise.totalVolume);
  }
}
