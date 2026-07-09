import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/data/models/user_model.dart';
import '../../auth/data/auth_repository.dart';
import '../../home/data/home_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;
  final HomeRepository _homeRepository;

  ProfileCubit(this._authRepository, this._homeRepository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      var user = await _authRepository.getCurrentUser();
      
      // إذا لم يوجد مستخدم محلي، نحاول جلبه من Firebase (لحماية التطبيق من الخطأ)
      if (user == null) {
        final fbUser = FirebaseAuth.instance.currentUser;
        if (fbUser != null) {
          user = UserModel(
            id: fbUser.uid,
            email: fbUser.email ?? "",
            name: fbUser.displayName ?? fbUser.email?.split('@')[0] ?? "Athlete",
          );
          await _authRepository.updateUser(user);
        }
      }

      if (user != null) {
        final workouts = await _homeRepository.getWorkouts();
        final streak = _homeRepository.calculateStreak(workouts);
        emit(ProfileLoaded(
          user: user,
          workoutCount: workouts.length,
          streak: streak,
        ));
      } else {
        emit(const ProfileError('User not logged in'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateGoalWeight(double targetWeight) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      try {
        final updatedUser = currentState.user.copyWith(targetWeight: targetWeight);
        await _authRepository.updateUser(updatedUser);
        emit(currentState.copyWith(user: updatedUser));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> updateCurrentWeight(double currentWeight) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      try {
        final updatedUser = currentState.user.copyWith(currentWeight: currentWeight);
        await _authRepository.updateUser(updatedUser);
        emit(currentState.copyWith(user: updatedUser));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> updateProfile({String? name, String? profilePic}) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      try {
        final updatedUser = currentState.user.copyWith(
          name: name,
          profilePic: profilePic,
        );
        await _authRepository.updateUser(updatedUser);
        emit(currentState.copyWith(user: updatedUser));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }
}
