// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'ليفت لوج';

  @override
  String get welcomeBack => 'حمدلله على السلامة،';

  @override
  String get loginWelcomeBack => 'مرحباً بعودتك!';

  @override
  String get loginSubtitle => 'قم بتسجيل الدخول إلى حسابك للمتابعة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get newToGrind => 'جديد في ليفت لوج؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get registerSubtitle => 'ابدأ رحلتك اليوم';

  @override
  String get fullName => 'الاسم بالكامل';

  @override
  String get signUp => 'تسجيل جديد';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get todaySession => 'تمرينة اليوم';

  @override
  String get continueWorkout => 'استكمال التمرين';

  @override
  String get weeklyStreak => 'التتابع\nالأسبوعي';

  @override
  String get currentWeight => 'الوزن\nالحالي';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String daysCount(int count) {
    return '$count / 7 أيام';
  }

  @override
  String get kg => 'كجم';

  @override
  String get done => 'تم';

  @override
  String get profile => 'الحساب الشخصي';

  @override
  String get progress => 'Progress';

  @override
  String get yourProgress => 'تقدمك';

  @override
  String get trackGains => 'تابع نتائجك';

  @override
  String get totalWorkouts => 'إجمالي التمارين';

  @override
  String get totalVolume => 'إجمالي الأحمال';

  @override
  String get days => 'أيام';

  @override
  String get volumeProgression => 'تطور الأحمال';

  @override
  String get addWorkoutsToSeeProgress => 'أضف تمارين لمتابعة تقدمك';

  @override
  String get weightTracking => 'متابعة الوزن';

  @override
  String get current => 'الحالي';

  @override
  String get target => 'المستهدف';

  @override
  String toGoal(String weight, String unit) {
    return 'متبقي $weight $unit للهدف';
  }

  @override
  String get workout => 'التمارين';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get personalRecords => 'الأرقام القياسية';

  @override
  String get weightHistory => 'سجل الوزن';

  @override
  String get goalWeight => 'الوزن المستهدف';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get aboutApp => 'عن التطبيق';

  @override
  String get streak => 'التتابع';

  @override
  String get workoutsCount => 'التمارين';

  @override
  String get workoutHistory => 'سجل التمارين';

  @override
  String get noWorkoutsYet => 'لا توجد تمارين بعد';

  @override
  String get startJourney => 'ابدأ رحلتك الرياضية بإضافة تمرين!';

  @override
  String get activeSession => 'جلسة نشطة';

  @override
  String startedAt(String time) {
    return 'بدأت $time';
  }

  @override
  String get addExercise => 'إضافة تمرين';

  @override
  String get finishWorkout => 'إنهاء التمرين';

  @override
  String get set => 'مجموعة';

  @override
  String get weight => 'وزن';

  @override
  String get reps => 'عدات';

  @override
  String get addSet => 'إضافة مجموعة';

  @override
  String get editName => 'تعديل الاسم';

  @override
  String get save => 'حفظ';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get enterName => 'أدخل اسمك';

  @override
  String get updateGoalWeight => 'تحديث الوزن المستهدف';

  @override
  String get updateCurrentWeight => 'تحديث الوزن الحالي';

  @override
  String get weightCurrent => 'الوزن الحالي';

  @override
  String get morningWorkout => 'تمرين صباحي';

  @override
  String get newExercise => 'تمرين جديد';

  @override
  String get keepGoing => 'استمر! أنت تبلي بلاءً حسناً.';
}
