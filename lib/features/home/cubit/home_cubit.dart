import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final data = await _homeRepository.getHomeData();
      emit(HomeLoaded(data));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
