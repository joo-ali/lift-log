import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 4)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String? profilePic;

  @HiveField(4)
  final double currentWeight;

  @HiveField(5)
  final double targetWeight;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profilePic,
    this.currentWeight = 0.0,
    this.targetWeight = 0.0,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    double? currentWeight,
    double? targetWeight,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      currentWeight: currentWeight ?? this.currentWeight,
      targetWeight: targetWeight ?? this.targetWeight,
    );
  }
}
