import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';

class AppTypography {
  AppTypography._();

  // Global font family
  static const String fontFamily = 'Roboto';

  // Headline – large title, like app name in splash
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 1.3,
    letterSpacing: 0.2,
    color: AppColors.textPrimary,
  );

  // Body text – normal paragraph text
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // Caption / helper / hint text
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.3,
    color: AppColors.textMuted,
  );

  // Button text – primary actions
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    letterSpacing: 0.3,
    color: AppColors.buttonTextOnPrimary,
  );

  // Global TextTheme mapping
  static const TextTheme textTheme = TextTheme(
    titleLarge: h1, // e.g., big titles
    bodyMedium: body, // normal body text
    bodySmall: caption, // helper/small text
    labelLarge: button, // button text
  );
}
