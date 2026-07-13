import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lift_log/core/services/hive_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box _settingsBox = Hive.box(HiveService.settingsBox);
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.dark) {
    _loadTheme();
  }

  void _loadTheme() {
    final String? savedTheme = _settingsBox.get(_themeKey);
    if (savedTheme != null) {
      emit(savedTheme == 'light' ? ThemeMode.light : ThemeMode.dark);
    } else {
      // إذا لم يوجد ثيم محفوظ (أول مرة فتح للتطبيق)، نجعل الافتراضي dark
      emit(ThemeMode.dark);
    }
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _settingsBox.put(_themeKey, newMode == ThemeMode.light ? 'light' : 'dark');
    emit(newMode);
  }
}
