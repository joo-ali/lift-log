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
  @HiveField(4)
  final String userId;

  WorkoutModel({
    required this.id,
    required this.title,
    required this.date,
    required this.exercises,
    required this.userId,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) => WorkoutModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        date: DateTime.parse(json['date']),
        userId: json['userId'] ?? '',
        exercises: (json['exercises'] as List)
            .map((i) => ExerciseModel.fromJson(i))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'userId': userId,
        'exercises': exercises.map((i) => i.toJson()).toList(),
      };

  Map<String, dynamic> toJson() => toMap();

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate;
    if (map['date'] is String) {
      parsedDate = DateTime.parse(map['date']);
    } else if (map['date'] is DateTime) {
      parsedDate = map['date'];
    } else if (map['date'] != null && map['date'].runtimeType.toString().contains('Timestamp')) {
      parsedDate = (map['date'] as dynamic).toDate();
    } else {
      parsedDate = DateTime.now();
    }

    return WorkoutModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: parsedDate,
      userId: map['userId'] ?? '',
      exercises: (map['exercises'] as List? ?? [])
          .map((i) => ExerciseModel.fromJson(Map<String, dynamic>.from(i)))
          .toList(),
    );
  }

  double get totalVolume {
    return exercises.fold(0, (sum, exercise) => sum + exercise.totalVolume);
  }
}
