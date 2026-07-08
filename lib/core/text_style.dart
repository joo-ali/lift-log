import 'package:flutter/material.dart';
import 'package:lift_log/core/colors_manager.dart';

class TextStyleManager {
  static const String fontFamily = 'Montserrat';

  static const TextStyle displayLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w800,
    height: 56 / 48,
    letterSpacing: -0.02 * 48,
    color: ColorsManager.secondary,
  );

  static const TextStyle headlineLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.01 * 32,
    color: ColorsManager.secondary,
  );

  static const TextStyle headlineLgMobile = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    color: ColorsManager.secondary,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    color: ColorsManager.secondary,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: ColorsManager.secondary,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: ColorsManager.secondary,
  );

  static const TextStyle labelLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 16 / 14,
    letterSpacing: 0.05 * 14,
    color: ColorsManager.secondary,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: ColorsManager.secondary,
  );
}
