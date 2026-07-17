import 'package:flutter/material.dart';

extension ResponsiveExtension on num {
  double w(BuildContext context) => this * MediaQuery.of(context).size.width / 393;

  double h(BuildContext context) => this * MediaQuery.of(context).size.height / 852;

  double sp(BuildContext context) => this * (MediaQuery.of(context).size.width / 393);

  double r(BuildContext context) => this * (MediaQuery.of(context).size.width / 393);
}

class Responsive {
  static double width(BuildContext context, double p) => MediaQuery.of(context).size.width * (p / 100);
  static double height(BuildContext context, double p) => MediaQuery.of(context).size.height * (p / 100);
}
