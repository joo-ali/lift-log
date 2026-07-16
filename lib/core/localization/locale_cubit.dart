import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lift_log/core/services/hive_service.dart';

class LocaleCubit extends Cubit<Locale> {
  final Box _settingsBox = Hive.box(HiveService.settingsBox);
  static const String _localeKey = 'app_locale';

  LocaleCubit() : super(const Locale('ar')) {
    _loadLocale();
  }

  void _loadLocale() {
    final String? savedLocale = _settingsBox.get(_localeKey);
    if (savedLocale != null) {
      emit(Locale(savedLocale));
    }
  }

  void setLocale(Locale locale) {
    _settingsBox.put(_localeKey, locale.languageCode);
    emit(locale);
  }

  void toggleLocale() {
    final newLocale = state.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    setLocale(newLocale);
  }
}
