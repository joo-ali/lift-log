import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lift_log/features/progress/data/progress_repository.dart';

import 'progress_state.dart';
export 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final ProgressRepository _progressRepository;

  ProgressCubit(this._progressRepository) : super(ProgressInitial());

  Future<void> loadProgress() async {
    emit(ProgressLoading());
    try {
      final data = await _progressRepository.getProgressData();
      emit(ProgressLoaded(data));
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }
}
