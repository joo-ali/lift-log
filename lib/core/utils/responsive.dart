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
  double get w => this * Responsive._width / 393;
  double get h => this * Responsive._height / 852;
  double get sp => this * (Responsive._width / 393);
  double get r => this * (Responsive._width / 393);

  double callW([dynamic context]) => w;
  double callH([dynamic context]) => h;
  double callSp([dynamic context]) => sp;
  double callR([dynamic context]) => r;
}

extension ResponsiveFunctionExtension on double {
  double call([dynamic context]) => this;
}
