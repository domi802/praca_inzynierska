import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  static const String _localeKey = 'locale';
  static const String _themeModeKey = 'theme_mode';
  
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load locale
    final localeCode = prefs.getString(_localeKey) ?? 'pl';
    final locale = Locale(localeCode);
    
    // Load theme mode
    final themeModeString = prefs.getString(_themeModeKey) ?? 'system';
    final themeMode = _stringToThemeMode(themeModeString);
    
    emit(state.copyWith(
      locale: locale,
      themeMode: themeMode,
    ));
  }
  
  Future<void> changeLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    emit(state.copyWith(locale: locale));
  }
  
  Future<void> changeThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _themeModeToString(themeMode));
    emit(state.copyWith(themeMode: themeMode));
  }
  
  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
  
  ThemeMode _stringToThemeMode(String string) {
    switch (string) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
