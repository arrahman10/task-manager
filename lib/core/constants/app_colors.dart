import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Base surfaces
  static const Color background = Color(0xFFF2F7FF);
  static const Color surface = Colors.white;

  // Primary brand colors (inspired by Deco-style aqua)
  static const Color primary = Color(0xFF18C1F3);
  static const Color primaryDark = Color(0xFF0091C9);
  static const Color primarySoft = Color(0xFFE1F7FF);

  // Text colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Button text
  static const Color buttonTextOnPrimary = Colors.white;

  // Borders / dividers
  static const Color divider = Color(0xFFE5E7EB);
  static const Color borderSubtle = Color(0x33FFFFFF);

  // Glass / blur surfaces
  static const Color glassTint = Color(0xCCFFFFFF); // 80% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white

  // Snackbar colors
  static const Color snackbarInfo = Color(0xFF00B2FF); // Info (blue)
  static const Color snackbarSuccess = Color(0xFF00C853); // Success (green)
  static const Color snackbarError = Color(0xFFFF5252); // Error (red)
  static const Color snackbarText = Color(0xFFFFFFFF); // Text (white)

  // Loader
  static const Color loaderTrack = Color(0x33FFFFFF);
  static const Color loaderProgress = Colors.white;

  // Icons
  static const Color iconPrimary = Color(0xFF4B5563);
}
