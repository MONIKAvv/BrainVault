import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// App typography definitions.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle onboardingTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.25,
  );

  static const TextStyle onboardingSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.45,
    letterSpacing: 0.1,
  );

  static const TextStyle skipButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );

  static const TextStyle homeHeader = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h1({Color? color}) => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.lightTextPrimary,
    height: 1.2,
  );

  static TextStyle h2({Color? color}) => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.lightTextPrimary,
    height: 1.25,
  );

  static TextStyle h3({Color? color}) => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.lightTextPrimary,
    height: 1.3,
  );

  static TextStyle subtitle({Color? color}) => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.lightTextPrimary,
  );

  static TextStyle body({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.lightTextPrimary,
    height: 1.4,
  );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.lightTextSecondary,
  );

  static TextStyle caption({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.lightTextSecondary,
  );

  static TextStyle button({Color? color}) => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: color ?? Colors.white,
  );
}
