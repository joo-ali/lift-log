import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/features/home/data/home_repository.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  final AuthCubit _authCubit;
  StreamSubscription? _authSubscription;

  HomeCubit(this._homeRepository, this._authCubit) : super(HomeInitial()) {
    // بنسمع لتغييرات الـ Auth. لو اليوزر اتغير أو دخل، بنحدث الهوم فوراً
    _authSubscription = _authCubit.stream.listen((authState) {
      if (authState is AuthSuccess || authState is AuthOfflineSuccess) {
        loadHomeData();
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

  Future<void> loadHomeData() async {
    String? userId = _userId;
    
    if (userId == null) {
      userId = FirebaseAuth.instance.currentUser?.uid;
    }

    if (userId == null) {
      emit(HomeError("User not authenticated"));
      return;
    }

    emit(HomeLoading());
    try {
      final data = await _homeRepository.getHomeData(userId);
      emit(HomeLoaded(data));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
