import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import 'package:lift_log/firebase_options.dart';
import 'package:lift_log/core/routes/app_router.dart';
import 'package:lift_log/core/theme/app_theme.dart';
import 'package:lift_log/core/theme/theme_cubit.dart';
import 'package:lift_log/core/localization/locale_cubit.dart';
import 'package:lift_log/core/services/hive_service.dart';
import 'package:lift_log/core/di/service_locator.dart';
import 'package:lift_log/features/auth/cubit/auth_cubit.dart';
import 'package:lift_log/features/home/cubit/home_cubit.dart';
import 'package:lift_log/features/workout/cubit/workout_cubit.dart';
import 'package:lift_log/features/progress/cubit/progress_cubit.dart';
import 'package:lift_log/features/profile/cubit/profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Initialize Firebase first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Initialize Hive BEFORE Service Locator
  await HiveService.init();

  // 3. Setup Service Locator
  await setupServiceLocator();

  runApp(const LiftLogApp());
}

class LiftLogApp extends StatelessWidget {
  const LiftLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => sl<ThemeCubit>()),
        BlocProvider<LocaleCubit>(create: (context) => sl<LocaleCubit>()),
        BlocProvider<AuthCubit>(create: (context) => sl<AuthCubit>()..appStarted()),
        BlocProvider<HomeCubit>(create: (context) => sl<HomeCubit>()),
        BlocProvider<WorkoutCubit>(create: (context) => sl<WorkoutCubit>()),
        BlocProvider<ProgressCubit>(create: (context) => sl<ProgressCubit>()),
        BlocProvider<ProfileCubit>(create: (context) => sl<ProfileCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return ScreenUtilInit(
                designSize: const Size(393, 852),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return MaterialApp(
                    title: 'Lift Log',
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeMode,
                    locale: locale,
                    supportedLocales: const [
                      Locale('en'),
                      Locale('ar'),
                    ],
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    onGenerateRoute: AppRouter.generateRoute,
                    initialRoute: AppRouter.splash,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
