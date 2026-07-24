import 'package:hive/hive.dart';
import 'set_entry_model.dart';

part 'exercise_model.g.dart';

@HiveType(typeId: 1)
class ExerciseModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final List<SetEntryModel> sets;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.sets,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      sets: (json['sets'] as List? ?? [])
          .map((i) => SetEntryModel.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'sets': sets.map((i) => i.toJson()).toList(),
    };
  }

  double get totalVolume {
    return sets.fold(0, (sum, set) => sum + (set.weight * set.reps));
  }
}

