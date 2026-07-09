import 'package:get_it/get_it.dart';
import '../services/firebase_auth_service.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/home/data/home_repository.dart';
import '../../features/home/cubit/home_cubit.dart';
import '../../features/workout/data/workout_repository.dart';
import '../../features/workout/cubit/workout_cubit.dart';
import '../../features/progress/data/progress_repository.dart';
import '../../features/progress/cubit/progress_cubit.dart';
import '../../features/profile/cubit/profile_cubit.dart';
import '../../data/data_sources/local/user_local_data_source.dart';
import '../../data/data_sources/local/workout_local_data_source.dart';
import '../theme/theme_cubit.dart';
import '../localization/locale_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());

  sl.registerLazySingleton(() => UserLocalDataSource());
  sl.registerLazySingleton(() => WorkoutLocalDataSource());

  // Repositories
  sl.registerLazySingleton(() => AuthRepository(
        sl<FirebaseAuthService>(),
        sl<UserLocalDataSource>(),
      ));
  sl.registerLazySingleton(() => HomeRepository(
        sl<WorkoutLocalDataSource>(),
        sl<UserLocalDataSource>(),
      ));
  sl.registerLazySingleton(() => WorkoutRepository(sl<WorkoutLocalDataSource>()));
  sl.registerLazySingleton(() => ProgressRepository(
        sl<WorkoutLocalDataSource>(),
        sl<UserLocalDataSource>(),
      ));

  // Cubits
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => HomeCubit(sl()));
  sl.registerFactory(() => WorkoutCubit(sl()));
  sl.registerFactory(() => ProgressCubit(sl()));
  sl.registerFactory(() => ProfileCubit(sl(), sl()));
  sl.registerLazySingleton(() => ThemeCubit());
  sl.registerLazySingleton(() => LocaleCubit());
}
