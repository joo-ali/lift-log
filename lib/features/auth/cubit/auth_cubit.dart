import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/core/services/firebase_auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuthService _firebaseAuthService;

  AuthCubit(this._firebaseAuthService) : super(AuthInitial());

  void appStarted() {
    final user = _firebaseAuthService.currentUser;
    emit(user == null ? Unauthenticated() : AuthSuccess(user));
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      final credential = await _firebaseAuthService.signIn(email, password);
      final user = credential.user;

      if (user == null) {
        emit(AuthError('Login failed.'));
        return;
      }

      emit(AuthSuccess(user));
    } on FirebaseAuthException catch (error) {
      emit(AuthError(_messageFor(error.code)));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> logout() async {
    await _firebaseAuthService.signOut();
    emit(Unauthenticated());
  }

  String _messageFor(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'Check your internet connection.';
      default:
        return 'Login failed. Please try again.';
    }
  }
}
