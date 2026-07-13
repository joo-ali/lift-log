import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lift_log/features/auth/data/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
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
        emit(AuthSuccess(userCredential.user!));
      } else {
        emit(AuthError("Login failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.loginWithGoogle();
      if (userCredential != null && userCredential.user != null) {
        emit(AuthSuccess(userCredential.user!));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.register(email, password, name: name);
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
