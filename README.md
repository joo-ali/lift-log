# 🏋️ Lift Log - Modern Fitness Tracker

**Lift Log** هو تطبيق أندرويد متكامل لمتابعة التمارين الرياضية، مصمم بأحدث تقنيات Flutter لتقديم تجربة مستخدم سريعة، متجاوبة، وتعمل بدون إنترنت (Offline-First).

---

## 🚀 التقنيات المستخدمة (Tech Stack)

*   **Framework:** Flutter (Modern Color APIs & ScreenUtil for responsiveness).
*   **Architecture:** Clean Architecture with Repository Pattern.
*   **State Management:** BLoC / Cubit.
*   **Local Database:** Hive (Zero Latency Storage).
*   **Remote Database:** Firebase Firestore & Authentication.
*   **API:** REST APIs for suggested routines.
*   **Design:** Custom Painter for advanced analytics and charts.

---

## 👥 فريق العمل والمساهمات (Team & Reports)

تم تقسيم المشروع هندسياً لضمان أعلى جودة وأفضل أداء. يمكنك الإطلاع على التقارير التقنية المفصلة لكل جزء من الروابط التالية:

1.  **[Home & Workout Engine (Mazen & Kero)](./MAZEN_KERO.md)**: محرك التمارين، الرسوم البيانية، وهيكلة البيانات الأساسية.
2.  **[Authentication & Security (Yousef & Ziad)](./YOUSEF_ZIAD.md)**: نظام الحماية، الربط مع Firebase، والتحقق من البيانات.
3.  **[Profile & Globalization (Abdo)](./ABDO.md)**: إدارة الحساب، اللغات (Localization)، والثيم (Dark/Light Mode).

*للاطلاع على توزيع الملفات بالتفصيل، راجع: **[TEAM_MEMBERS.md](./TEAM_MEMBERS.md)***

---

## 🛠️ كيف تبدأ (Getting Started)

1.  تأكد من تثبيت Flutter (نسخة 3.27.0 أو أحدث).
2.  قم بتنفيذ الأمر `flutter pub get` لتحميل المكتبات.
3.  شغل المشروع باستخدام `flutter run`.

---

## 📱 مميزات التطبيق (Features)

*   **Responsive UI:** واجهة مستخدم تتكيف مع جميع أحجام الشاشات.
*   **Offline Support:** سجل تمارينك حتى لو مفيش إنترنت.
*   **Dynamic Charts:** تتبع تقدمك من خلال رسوم بيانية تفاعلية.
*   **Multi-Language:** دعم كامل للغتين العربية والإنجليزية.
*   **Dark Mode:** ثيم ليلي مريح للعين يحفظ في الإعدادات.

---

## 📐 الهيكل الهندسي (Project Structure)
نتبع نظام الـ **Feature-first** لسهولة التوسع:
```text
lib/
 ├── core/          # المكونات المشتركة (Theme, Routes, Widgets)
 ├── data/          # الموديلات والـ Data Sources العالمية
 ├── features/      # الميزات (Auth, Home, Workout, Profile)
 │    └── [feature]/
 │         ├── cubit/
 │         ├── data/
 │         └── presentation/
 └── main.dart      # نقطة انطلاق التطبيق
```
