part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User? user; // جعلناه اختياري ليدعم حالات الأوفلاين التامة
  AuthSuccess(this.user);
}



class AuthOfflineSuccess extends AuthState {
  final UserModel user;
  AuthOfflineSuccess(this.user);
}

class AuthNetworkError extends AuthState {
  final String message;
  AuthNetworkError(this.message);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class Unauthenticated extends AuthState {}
