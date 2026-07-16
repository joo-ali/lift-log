# 👥 توزيع مهام فريق عمل مشروع Lift Log (ملفات الكود)

هذا الدليل يحدد الملفات البرمجية التي سيقوم كل عضو بمناقشتها، لضمان تغطية كاملة لمبادئ Clean Architecture و Responsive Design.

---

## 🏗️ 1. مازن (Mazen) - [Home & Data Architecture]
**المسؤولية:** إدارة تدفق البيانات من السيرفر والمزامنة مع الـ UI الرئيسي.

### 📄 الملفات للمناقشة:
*   **UI:** `lib/features/home/presentation/home_screen.dart`
*   **Logic:** `lib/features/home/cubit/home_cubit.dart`
*   **Data:** `lib/features/home/data/home_repository.dart`
*   **Models:** `lib/data/models/user_model.dart`
*   **Widgets:** `lib/features/home/presentation/widgets/` (Today Session Card & Activity Items).

---

## 📊 2. كيرو (Kero) - [Workout Engine & Analytics]
**المسؤولية:** محرك التمارين، تسجيل الجلسات، والرسوم البيانية المعقدة.

### 📄 الملفات للمناقشة:
*   **UI:** `lib/features/workout/workout_screen.dart` & `add_workout_screen.dart`
*   **Analytics:** `lib/features/progress/progress_screen.dart`
*   **Custom Painting:** `lib/core/widgets/custom_line_chart.dart`
*   **Remote Data:** `lib/features/workout/data/routine_repository.dart` (REST APIs)
*   **Models:** `workout_model.dart` & `exercise_model.dart`.

---

## 🔐 3. يوسف (Yousef) - [Authentication & Routing]
**المسؤولية:** تأمين التطبيق، الربط مع Firebase، وإدارة التنقل (Navigation Flow).

### 📄 الملفات للمناقشة:
*   **UI:** `lib/features/auth/presentation/login_screen.dart`
*   **Logic:** `lib/features/auth/cubit/auth_cubit.dart`
*   **Service:** `lib/core/services/firebase_auth_service.dart`
*   **Routing:** `lib/core/routes/app_router.dart`
*   **Widgets:** `auth_header.dart` من مجلد الـ Auth.

---

## 📝 4. زياد (Ziad) - [User Onboarding & Form Logic]
**المسؤولية:** شاشات التسجيل، التحقق من صحة البيانات (Validation)، والـ Repository الخاص بالمستخدم.

### 📄 الملفات للمناقشة:
*   **UI:** `lib/features/auth/presentation/register_screen.dart`
*   **Data:** `lib/features/auth/data/auth_repository.dart`
*   **Utility:** `lib/core/utils/validators.dart` (التحقق من الإيميل وقوة كلمة المرور).
*   **Widgets:** `social_button.dart` & `label_divider.dart`.

---

## 👤 5. عبده (Abdo) - [Profile & Globalization]
**المسؤولية:** إدارة حساب المستخدم، اللغات (Localization)، والثيم (Dark/Light Mode).

### 📄 الملفات للمناقشة:
*   **UI:** `lib/features/profile/profile_screen.dart`
*   **Logic:** `lib/features/profile/cubit/profile_cubit.dart`
*   **Persistence:** `lib/core/theme/theme_cubit.dart` & `locale_cubit.dart` (Hive storage).
*   **Localization:** `lib/l10n/` (ملفات الترجمة العربي والإنجليزي).
*   **Widgets:** `profile_info_widget.dart` & `profile_goal_card.dart`.

---

## 🛠️ تقنيات مشتركة (The Core)
تم استخدام هذه الأدوات في جميع الملفات المذكورة أعلاه:
*   **ScreenUtil:** لضمان أن جميع أبعاد الـ `h`, `w`, `r`, `sp` متناسبة مع كل الشاشات.
*   **Hive:** للتخزين المحلي فوري السرعة (Zero Latency).
*   **GetIt (sl):** للـ Dependency Injection لضمان سهولة الاختبار والصيانة.
