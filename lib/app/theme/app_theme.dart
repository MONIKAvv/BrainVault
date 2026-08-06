import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Central theme builder for BrainVault
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundBottom,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryViolet,
        surface: AppColors.backgroundMiddle,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: 'Roboto',
    );
  }

  static ThemeData get lightTheme => darkTheme;
}
