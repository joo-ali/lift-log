import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('1- Starting Firebase');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('2- Firebase finished');

    debugPrint('3- Starting Hive');
    await HiveService.init();
    debugPrint('4- Hive finished');

    debugPrint('5- Starting service locator');
    await setupServiceLocator();
    debugPrint('6- Service locator finished');

    runApp(
      kReleaseMode
          ? const LiftLogApp()
          : DevicePreview(
              enabled: true,
              builder: (context) => const LiftLogApp(),
            ),
    );
  } catch (error, stackTrace) {
    debugPrint('STARTUP ERROR: $error');
    debugPrintStack(stackTrace: stackTrace);

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SelectableText(
                'Startup error:\n$error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
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
              return MaterialApp(
                locale: locale,
                builder: kReleaseMode ? null : DevicePreview.appBuilder,
                title: 'Lift Log',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
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
      ),
    );
  }
}
