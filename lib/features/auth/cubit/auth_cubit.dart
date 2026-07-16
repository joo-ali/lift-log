import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lift_log/data/models/user_model.dart';
import 'package:lift_log/features/auth/data/auth_repository.dart';
import 'package:lift_log/features/workout/data/workout_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final WorkoutRepository _workoutRepository;

  AuthCubit(this._authRepository, this._workoutRepository) : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // مزامنة التمارين في الخلفية عند فتح التطبيق
        _workoutRepository.syncWorkoutsFromCloud(user.uid);
        emit(AuthSuccess(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.login(email, password);
      if (userCredential != null && userCredential.user != null) {
        // سحب التمارين فور تسجيل الدخول الناجح
        await _workoutRepository.syncWorkoutsFromCloud(userCredential.user!.uid);
        emit(AuthSuccess(userCredential.user!));
      } else {
        emit(AuthError("Login failed"));
      }
    } catch (e) {
      if (e.toString().contains('network-request-failed')) {
        emit(AuthNetworkError("No internet connection. Accessing offline data..."));
        final localUser = await _authRepository.getCurrentUser();
        if (localUser != null) {
          emit(AuthOfflineSuccess(localUser));
        }
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> register(
    String email,
    String password,
    String name, {
    double? currentWeight,
    double? targetWeight,
  }) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.register(
        email,
        password,
        name: name,
        currentWeight: currentWeight,
        targetWeight: targetWeight,
      );
      if (userCredential != null && userCredential.user != null) {
        emit(AuthSuccess(userCredential.user!));
      } else {
        emit(AuthError("Registration failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(Unauthenticated());
  }
}
