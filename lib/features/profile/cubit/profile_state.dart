import 'package:equatable/equatable.dart';
import 'package:lift_log/data/models/user_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final int workoutCount;
  final int streak;

  const ProfileLoaded({
    required this.user,
    required this.workoutCount,
    required this.streak,
  });

  ProfileLoaded copyWith({
    UserModel? user,
    int? workoutCount,
    int? streak,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      workoutCount: workoutCount ?? this.workoutCount,
      streak: streak ?? this.streak,
    );
  }

  @override
  List<Object?> get props => [user, workoutCount, streak];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

