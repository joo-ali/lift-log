import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/features/progress/data/progress_repository.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'progress_state.dart';
export 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final ProgressRepository _progressRepository;
  final AuthCubit _authCubit;
  StreamSubscription? _authSubscription;

  ProgressCubit(this._progressRepository, this._authCubit) : super(ProgressInitial()) {
    _authSubscription = _authCubit.stream.listen((authState) {
      if (authState is AuthSuccess || authState is AuthOfflineSuccess) {
        loadProgress();
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  String? get _userId {
    final authState = _authCubit.state;
    if (authState is AuthSuccess) {
      return authState.user?.uid;
    } else if (authState is AuthOfflineSuccess) {
      return authState.user.id;
    }
    return null;
  }

  Future<void> loadProgress() async {
    String? userId = _userId;

    if (userId == null) {
      userId = FirebaseAuth.instance.currentUser?.uid;
    }

    if (userId == null) {
      emit(ProgressError("User not authenticated"));
      return;
    }

    emit(ProgressLoading());
    try {
      final data = await _progressRepository.getProgressData(userId);
      emit(ProgressLoaded(data));
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }
}
