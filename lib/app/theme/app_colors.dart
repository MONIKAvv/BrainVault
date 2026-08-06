import 'package:flutter/material.dart';

/// App color palette matching the sleek purple gradient design system.
class AppColors {
  AppColors._();

  // Background Gradients
  static const Color backgroundTop = Color(0xFF5532BC);
  static const Color backgroundMiddle = Color(0xFF6B45D8);
  static const Color backgroundBottom = Color(0xFF4C2AA9);

  // Surface & Card Colors
  static const Color cardBackground = Color(0x28FFFFFF);
  static const Color cardBorder = Color(0x38FFFFFF);
  static const Color iconBoxBg = Color(0x3DFFFFFF);

  // Brand Accent Colors
  static const Color primaryViolet = Color(0xFF6C4AB6);
  static const Color accentLight = Color(0xFFB882FF);
  static const Color glowCyan = Color(0xFF80E8FF);
  static const Color robotFaceBg = Color(0xFF1D1B46);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFE2D6FF);
  static const Color textMuted = Color(0xAAFFFFFF);

  // Controls & Buttons
  static const Color buttonWhite = Colors.white;
  static const Color iconDark = Color(0xFF532DBE);
  static const Color indicatorActive = Colors.white;
  static const Color indicatorInactive = Color(0x55FFFFFF);

  // Light Theme & Auth / Dashboard Colors
  static const Color lightBackground = Color(0xFFF8F9FD);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF111827);
  static const Color textDarkSecondary = Color(0xFF6B7280);
  static const Color textLink = Color(0xFF6C4AB6);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color inputFieldBg = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF1F2F6);
  static const Color lightTextPrimary = Color(0xFF1E1E2D);
  static const Color lightTextSecondary = Color(0xFF8A8DA6);
  static const Color lightBorder = Color(0xFFE7E7F0);

  // Quick Action Badge Colors
  static const Color quickActionNoteBg = Color(0xFFF4EFFC);
  static const Color quickActionNoteIcon = Color(0xFF7C3AED);
  static const Color quickActionAiBg = Color(0xFFEFF6FF);
  static const Color quickActionAiIcon = Color(0xFF3B82F6);
  static const Color quickActionTaskBg = Color(0xFFECFDF5);
  static const Color quickActionTaskIcon = Color(0xFF10B981);
  static const Color quickActionScanBg = Color(0xFFECFEFF);
  static const Color quickActionScanIcon = Color(0xFF06B6D4);

  // Recent Items Badge Colors
  static const Color noteOrangeBg = Color(0xFFFFF7ED);
  static const Color noteOrangeIcon = Color(0xFFF97316);
  static const Color notePurpleBg = Color(0xFFF5F3FF);
  static const Color notePurpleIcon = Color(0xFF7C3AED);
  static const Color taskRedBg = Color(0xFFFEF2F2);
  static const Color taskRedIcon = Color(0xFFEF4444);

  // Linear Gradient definition
  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundTop, backgroundMiddle, backgroundBottom],
  );

  // Brand / accent swatches (from the design system reference)
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color secondaryPurple = Color(0xFF4834D4);
  static const Color success = Color(0xFF2ECC71);
  static const Color info = Color(0xFF3B9EFF);
  static const Color warning = Color(0xFFFF9F43);
  static const Color error = Color(0xFFEE5253);
  static const Color offWhite = Color(0xFFF1F2F6);
  static const Color slateGray = Color(0xFF747D8C);

  // Dark theme surface tokens
  static const Color darkBackground = Color(0xFF0F0F1A);
  static const Color darkSurface = Color(0xFF1A1A2A);
  static const Color darkSurfaceAlt = Color(0xFF23233A);
  static const Color darkTextPrimary = Color(0xFFF5F5FA);
  static const Color darkTextSecondary = Color(0xFF9698B5);
  static const Color darkBorder = Color(0xFF2C2C42);
}
