import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/data/models/user_model.dart';
import 'package:lift_log/features/auth/data/auth_repository.dart';
import 'package:lift_log/features/home/data/home_repository.dart';
import 'package:lift_log/features/profile/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;
  final HomeRepository _homeRepository;

  ProfileCubit(this._authRepository, this._homeRepository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      var user = await _authRepository.getCurrentUser();
      final fbUser = FirebaseAuth.instance.currentUser;

      // إذا لم يوجد مستخدم محلي ولكن المستخدم مسجل دخول في Firebase
      if (user == null && fbUser != null) {
        // نحاول جلب البيانات من Firestore أولاً
        final cloudDoc = await FirebaseFirestore.instance.collection('users').doc(fbUser.uid).get();
        if (cloudDoc.exists && cloudDoc.data() != null) {
          final cloudUser = UserModel.fromMap(cloudDoc.data()!);
          user = cloudUser;
          await _authRepository.updateUser(cloudUser);
        } else {
          // إذا لم توجد بيانات في السحاب، ننشئ بروفايل جديد
          final newUser = UserModel(
            id: fbUser.uid,
            email: fbUser.email ?? "",
            name: fbUser.displayName ?? fbUser.email?.split('@')[0] ?? "Athlete",
          );
          user = newUser;
          await _authRepository.updateUser(newUser);
        }
      }

      if (user != null) {
        final allWorkouts = await _homeRepository.getWorkouts();
        final workouts = allWorkouts.where((w) => w.userId == user!.id).toList();
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
