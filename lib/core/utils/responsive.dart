import 'dart:ui' as ui;

class Responsive {
  static double get _width {
    final view = ui.PlatformDispatcher.instance.views.first;
    return view.physicalSize.width / view.devicePixelRatio;
  }

  static double get _height {
    final view = ui.PlatformDispatcher.instance.views.first;
    return view.physicalSize.height / view.devicePixelRatio;
  }
}

extension ResponsiveExtension on num {
  // 1. دعم Getter (الشكل القديم): 20.w
  double get w => this * Responsive._width / 393;
  double get h => this * Responsive._height / 852;
  double get sp => this * (Responsive._width / 393);
  double get r => this * (Responsive._width / 393);

  // 2. دعم الـ Method (عشان لو فيه كود فيه context): 20.w(context)
  double callW([dynamic context]) => w;
  double callH([dynamic context]) => h;
  double callSp([dynamic context]) => sp;
  double callR([dynamic context]) => r;
}

// دة "السر" اللي هيخلي .w(context) تشتغل حتى لو كانت w أصلاً getter
extension ResponsiveFunctionExtension on double {
  double call([dynamic context]) => this;
}
