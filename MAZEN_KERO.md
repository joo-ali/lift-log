# 📝 الشرح التفصيلي لكود "مازن وكيرو" (سطر بسطر)

هذا الملف هو المرجع البرمجي لشغل مازن وكيرو، بنشرح فيه المنطق البرمجي (Logic) لكل سطر مهم.

---

## 1. الشاشة الرئيسية (`home_screen.dart`)

هنا بنعرض حالة البطل اليومية:

*   `BlocProvider(create: (context) => sl<HomeCubit>()..loadHomeData())`: 
    *   **السطر ده:** بيكريت الـ Cubit وبنستخدم `..` (cascade operator) عشان ننادي ميثود `loadHomeData` أول ما الشاشة تفتح علطول.
*   `if (state is HomeLoading)`: 
    *   **السطر ده:** بنتشيك على حالة الـ UI، لو لسه بنحمل داتا بنعرض `CircularProgressIndicator` بلون الـ Primary.
*   `final data = state.data;`: 
    *   **السطر ده:** لما الداتا بتوصل بنجاح، بنخزنها في متغير `data` عشان نعرف نوصل لكل قيمة فيها بسهولة (زي الـ Streak والـ Weight).
*   `StatCard(value: data['streak'].toString(), progress: (data['streak'] as int) / 7)`: 
    *   **السطر ده:** بنحول الـ Streak لنص، وبنقسم قيمته على 7 عشان نحدد نسبة امتلاء الشريط الأخضر (Progress Bar).

---

## 2. إدارة التمارين (`workout_repository.dart`)

ده المخزن اللي مازن وكيرو كتبوه عشان يحفظوا التمارين:

*   `final Box<WorkoutModel> _workoutBox = Hive.box<WorkoutModel>('workouts');`:
    *   **السطر ده:** بنفتح صندوق Hive اسمه 'workouts' وبنحدد إنه مش هيشيل غير موديل `WorkoutModel`.
*   `await _workoutBox.put(workout.id, workout);`:
    *   **السطر ده:** بنستخدم الـ ID بتاع التمرين كـ "Key" وبنخزن الـ Object كله كـ "Value". ده بيضمن إننا لو عدلنا التمرين ميتكررش، يتمسح القديم ويتحط الجديد مكانه.
*   `return _workoutBox.values.where((w) => w.userId == currentUserId).toList();`:
    *   **السطر ده:** بنعمل Filter لكل التمارين المتسيفة، وبناخد بس التمارين اللي الـ `userId` بتاعها هو نفس الـ ID بتاع الشخص اللي فاتح الأبلكيشن (Data Isolation).

---

## 3. الرسم البياني (`custom_line_chart.dart`)

الـ Logic اللي كيرو عمله عشان يرسم التقدم:

*   `final paint = Paint()..color = color..strokeWidth = 3..style = PaintingStyle.stroke;`:
    *   **السطر ده:** بنجهز "الفرشة" اللي هنرسم بيها، بنحدد اللون والسمك (3 بكسل) وبنقوله إننا عايزين نرسم "إطار" (stroke) مش نملا الشكل.
*   `double x = i * (size.width / (data.length - 1));`:
    *   **السطر ده:** بنحسب مكان النقطة على محور X بالعرض، بنقسم عرض الشاشة على عدد النقط عشان يتوزعوا بالتساوي.
*   `double y = size.height - (data[i] / maxData) * size.height;`:
    *   **السطر ده:** بنحسب الارتفاع (محور Y). بنطرح القيمة من `size.height` لأن الـ Coordinate system في Flutter بيبدأ من فوق لتحت.

---

## 4. مكون تسجيل المجموعات (`exercise_set_row.dart`)

*   `CustomInputBox(initialValue: '0', onChanged: (val) => ...)`:
    *   **السطر ده:** بنستخدم المكون الموحد اللي مازن عمله، وبنبعت له "Callback function" تنادي الـ Cubit كل ما المستخدم يكتب رقم جديد عشان يحفظه "لحظياً".

---

**ملاحظة:** تم استخدام `.w` و `.h` في كل المسافات (SizedBox) والـ Padding لضمان إن شغل مازن وكيرو يفضل شكله "جامد" على أي موبايل.
