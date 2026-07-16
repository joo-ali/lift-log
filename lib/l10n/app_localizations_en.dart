// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LiftLog';

  @override
  String get welcomeBack => 'Welcome back,';

  @override
  String get loginWelcomeBack => 'Welcome Back!';

  @override
  String get loginSubtitle => 'Login to your account to continue';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get login => 'Login';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get newToGrind => 'New to LiftLog?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Start your journey today';

  @override
  String get fullName => 'Full Name';

  @override
  String get signUp => 'Sign Up';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get todaySession => 'TODAY\'S SESSION';

  @override
  String get continueWorkout => 'Continue Workout';

  @override
  String get weeklyStreak => 'WEEKLY\nSTREAK';

  @override
  String get currentWeight => 'CURRENT\nWEIGHT';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String daysCount(int count) {
    return '$count / 7 days';
  }

  @override
  String get kg => 'kg';

  @override
  String get done => 'Done';

  @override
  String get profile => 'Profile';

  @override
  String get progress => 'Progress';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String get trackGains => 'Track your gains';

  @override
  String get totalWorkouts => 'Total Workouts';

  @override
  String get totalVolume => 'Total Volume';

  @override
  String get days => 'Days';

  @override
  String get volumeProgression => 'Volume Progression';

  @override
  String get addWorkoutsToSeeProgress => 'Add workouts to see progress';

  @override
  String get weightTracking => 'Weight Tracking';

  @override
  String get current => 'Current';

  @override
  String get target => 'Target';

  @override
  String toGoal(String weight, String unit) {
    return '$weight $unit to goal';
  }

  @override
  String get workout => 'Workouts';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get logout => 'Log Out';

  @override
  String get personalRecords => 'Personal Records';

  @override
  String get weightHistory => 'Weight History';

  @override
  String get goalWeight => 'Goal Weight';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get aboutApp => 'About App';

  @override
  String get streak => 'STREAK';

  @override
  String get workoutsCount => 'WORKOUTS';

  @override
  String get workoutHistory => 'Workout History';

  @override
  String get noWorkoutsYet => 'No workouts yet';

  @override
  String get startJourney => 'Start your fitness journey by adding a workout!';

  @override
  String get activeSession => 'ACTIVE SESSION';

  @override
  String startedAt(String time) {
    return 'Started $time';
  }

  @override
  String get addExercise => 'Add Exercise';

  @override
  String get finishWorkout => 'FINISH WORKOUT';

  @override
  String get set => 'SET';

  @override
  String get weight => 'WEIGHT';

  @override
  String get reps => 'REPS';

  @override
  String get addSet => 'Add Set';

  @override
  String get editName => 'Edit Name';

  @override
  String get save => 'Save';

  @override
  String get username => 'Username';

  @override
  String get enterName => 'Enter your name';

  @override
  String get updateGoalWeight => 'Update Goal Weight';

  @override
  String get updateCurrentWeight => 'Update Current Weight';

  @override
  String get weightCurrent => 'Current Weight';

  @override
  String get morningWorkout => 'Morning Workout';

  @override
  String get newExercise => 'New Exercise';

  @override
  String get keepGoing => 'Keep going! You\'re doing great.';
}
