abstract class ProgressState {
  const ProgressState();
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final Map<String, dynamic> data;
  const ProgressLoaded(this.data);
}

class ProgressError extends ProgressState {
  final String message;
  const ProgressError(this.message);
}
