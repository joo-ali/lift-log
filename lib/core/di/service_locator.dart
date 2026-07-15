import 'package:get_it/get_it.dart';
import 'package:lift_log/core/services/firebase_auth_service.dart';
import 'package:lift_log/features/auth/data/auth_repository.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/features/home/data/home_repository.dart';
import 'package:lift_log/features/home/cubit/home_cubit.dart';
import 'package:lift_log/features/workout/data/workout_repository.dart';
import 'package:lift_log/features/workout/data/routine_repository.dart';
import 'package:lift_log/features/workout/cubit/workout_cubit.dart';
import 'package:lift_log/features/progress/data/progress_repository.dart';
import 'package:lift_log/features/progress/cubit/progress_cubit.dart';
import 'package:lift_log/features/profile/cubit/profile_cubit.dart';
import 'package:lift_log/data/data_sources/local/user_local_data_source.dart';
import 'package:lift_log/data/data_sources/local/workout_local_data_source.dart';
import 'package:lift_log/core/theme/theme_cubit.dart';
import 'package:lift_log/core/localization/locale_cubit.dart';

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
  sl.registerLazySingleton(() => RoutineRepository());
  sl.registerLazySingleton(() => ProgressRepository(
        sl<WorkoutLocalDataSource>(),
        sl<UserLocalDataSource>(),
      ));

  // Cubits
  sl.registerFactory(() => AuthCubit(sl<AuthRepository>(), sl<WorkoutRepository>()));
  sl.registerFactory(() => HomeCubit(sl<HomeRepository>(), sl<AuthCubit>()));
  sl.registerFactory(() => WorkoutCubit(
        sl<WorkoutRepository>(),
        sl<RoutineRepository>(),
        sl<AuthCubit>(),
      ));
  sl.registerFactory(() => ProgressCubit(sl<ProgressRepository>(), sl<AuthCubit>()));
  sl.registerFactory(() => ProfileCubit(sl(), sl()));
  sl.registerLazySingleton(() => ThemeCubit());
  sl.registerLazySingleton(() => LocaleCubit());
}
