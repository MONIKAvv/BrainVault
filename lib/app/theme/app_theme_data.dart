import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full light & dark ThemeData for BrainVault.
class AppThemeData {
  AppThemeData._();

  // ── helpers ─────────────────────────────────────────────────────────────────
  static CardThemeData _cardTheme(Color surface, Color border) => CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border, width: 1),
        ),
        margin: EdgeInsets.zero,
      );

  static AppBarTheme _appBarTheme(
          Color bg, Color fg, Color shadow, Color iconColor) =>
      AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        shadowColor: shadow,
        elevation: 0,
        iconTheme: IconThemeData(color: iconColor),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
        centerTitle: false,
      );

  // ── Light Theme ─────────────────────────────────────────────────────────────
  static ThemeData get light {
    const bg = AppColors.lightBackground;
    const surface = AppColors.lightSurface;
    const surfaceAlt = AppColors.lightSurfaceAlt;
    const textPrimary = AppColors.lightTextPrimary;
    const textSecondary = AppColors.lightTextSecondary;
    const border = AppColors.lightBorder;
    const primary = AppColors.primaryPurple;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: AppColors.secondaryPurple,
        surface: surface,
        onSurface: textPrimary,
        onPrimary: Colors.white,
        surfaceContainerHighest: surfaceAlt,
        outline: border,
      ),
      cardTheme: _cardTheme(surface, border),
      appBarTheme: _appBarTheme(bg, textPrimary, Colors.transparent, textPrimary),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? primary : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? primary.withValues(alpha: 0.5)
              : border,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      dividerColor: border,
      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 13,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          color: textSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: textSecondary),
      ),
    );
  }

  // ── Dark Theme ──────────────────────────────────────────────────────────────
  static ThemeData get dark {
    const bg = AppColors.darkBackground;
    const surface = AppColors.darkSurface;
    const surfaceAlt = AppColors.darkSurfaceAlt;
    const textPrimary = AppColors.darkTextPrimary;
    const textSecondary = AppColors.darkTextSecondary;
    const border = AppColors.darkBorder;
    const primary = AppColors.primaryPurple;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: AppColors.secondaryPurple,
        surface: surface,
        onSurface: textPrimary,
        onPrimary: Colors.white,
        surfaceContainerHighest: surfaceAlt,
        outline: border,
      ),
      cardTheme: _cardTheme(surface, border),
      appBarTheme: _appBarTheme(bg, textPrimary, Colors.transparent, textPrimary),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? primary : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? primary.withValues(alpha: 0.5)
              : border,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      dividerColor: border,
      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 13,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          color: textSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: textSecondary),
      ),
    );
  }
}
