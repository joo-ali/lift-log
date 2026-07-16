import 'package:flutter/material.dart';

extension ResponsiveExtension on num {
  /// Width scaling
  double w(BuildContext context) => this * MediaQuery.of(context).size.width / 393;

  /// Height scaling
  double h(BuildContext context) => this * MediaQuery.of(context).size.height / 852;

  /// Font size scaling
  double sp(BuildContext context) => this * (MediaQuery.of(context).size.width / 393);

  /// Radius scaling
  double r(BuildContext context) => this * (MediaQuery.of(context).size.width / 393);
}

// Global helper for simpler access if needed
class Responsive {
  static double width(BuildContext context, double p) => MediaQuery.of(context).size.width * (p / 100);
  static double height(BuildContext context, double p) => MediaQuery.of(context).size.height * (p / 100);
}

