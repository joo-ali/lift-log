import 'package:flutter_screenutil/flutter_screenutil.dart';

class Responsive {
  static double get screenWidth => ScreenUtil().screenWidth;
  static double get screenHeight => ScreenUtil().screenHeight;

  static double setWidth(double width) => width.w;
  static double setHeight(double height) => height.h;
  static double setFontSize(double size) => size.sp;
}
