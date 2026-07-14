import 'package:hive/hive.dart';

part 'set_entry_model.g.dart';

@HiveType(typeId: 0)
class SetEntryModel extends HiveObject {
  @HiveField(0)
  final double weight;
  @HiveField(1)
  final int reps;
  @HiveField(2)
  final bool isDone;

  SetEntryModel({
    required this.weight,
    required this.reps,
    this.isDone = false,
  });

  factory SetEntryModel.fromJson(Map<String, dynamic> json) => SetEntryModel(
        weight: (json['weight'] ?? 0.0).toDouble(),
        reps: json['reps'] ?? 0,
        isDone: json['isDone'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'reps': reps,
        'isDone': isDone,
      };
}
