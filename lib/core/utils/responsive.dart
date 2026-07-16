import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Responsive {
  /// الحصول على عرض الشاشة بدون context (للمناقشة: نستخدم PlatformDispatcher للحصول على أبعاد النافذة الأساسية)
  static double get _width {
    final view = ui.PlatformDispatcher.instance.views.first;
    return view.physicalSize.width / view.devicePixelRatio;
  }

  /// الحصول على طول الشاشة بدون context
  static double get _height {
    final view = ui.PlatformDispatcher.instance.views.first;
    return view.physicalSize.height / view.devicePixelRatio;
  }

  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
}

extension ResponsiveExtension on num {
  /// Width scaling: 20.w
  double get w => this * Responsive._width / 393;

  /// Height scaling: 20.h
  double get h => this * Responsive._height / 852;

  /// Font scaling: 16.sp
  double get sp => this * (Responsive._width / 393);

  /// Radius scaling: 12.r
  double get r => this * (Responsive._width / 393);
}

