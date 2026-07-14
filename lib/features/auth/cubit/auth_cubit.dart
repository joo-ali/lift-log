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

        final userModel = await _authRepository.getLocalUser();
        if (userModel != null && !userModel.isOnboarded) {
          emit(AuthOnboardingRequired(user));
        } else {
          emit(AuthSuccess(user));
        }
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
        
        final userModel = await _authRepository.getLocalUser();
        if (userModel != null && !userModel.isOnboarded) {
          emit(AuthOnboardingRequired(userCredential.user!));
        } else {
          emit(AuthSuccess(userCredential.user!));
        }
      } else {
        emit(AuthError("Login failed"));
      }
    } catch (e) {
      // لو الغلط بسبب النت، بنطلع رسالة مميزة
      if (e.toString().contains('network-request-failed')) {
        emit(AuthNetworkError("No internet connection. Accessing offline data..."));
        // نحاول ندخل أوفلاين لو في بيانات متسيفة
        final localUser = await _authRepository.getLocalUser();
        if (localUser != null) {
          emit(AuthOfflineSuccess(localUser));
        }
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.loginWithGoogle();
      if (userCredential != null && userCredential.user != null) {
        // سحب التمارين فور تسجيل الدخول بـ Google
        await _workoutRepository.syncWorkoutsFromCloud(userCredential.user!.uid);

        final userModel = await _authRepository.getLocalUser();
        if (userModel != null && !userModel.isOnboarded) {
          emit(AuthOnboardingRequired(userCredential.user!));
        } else {
          emit(AuthSuccess(userCredential.user!));
        }
      } else {
        emit(AuthError("Google login failed"));
      }
    } catch (e) {
      if (e.toString().contains('network-request-failed')) {
        emit(AuthNetworkError("No internet connection. Accessing offline data..."));
        final localUser = await _authRepository.getLocalUser();
        if (localUser != null) {
          emit(AuthOfflineSuccess(localUser));
        }
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.register(email, password, name: name);
      if (userCredential != null && userCredential.user != null) {
        // بعد التسجيل مباشرة بنطلب Onboarding
        emit(AuthOnboardingRequired(userCredential.user!));
      } else {
        emit(AuthError("Registration failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> completeOnboarding(double weight, int age) async {
    emit(AuthLoading());
    try {
      await _authRepository.updateOnboardingData(weight, age);
      // نتحقق من وجود المستخدم الحالي
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        emit(AuthSuccess(firebaseUser));
      } else {
        // في حالة الأوفلاين أو عدم وجود جلسة فعالة
        final localUser = await _authRepository.getLocalUser();
        if (localUser != null) {
          emit(AuthOfflineSuccess(localUser));
        }
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
