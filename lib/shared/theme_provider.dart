import 'package:flutter/material.dart';

/// Theme mode provider using ChangeNotifier for reactive state.
class ThemeProvider extends ChangeNotifier {
  ThemeProvider._();

  static final ThemeProvider _instance = ThemeProvider._();
  static ThemeProvider get instance => _instance;

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
