import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background gradient (inspired by your sample DashboardScreen)
  static const Color backgroundTop = Color(0xFFF1F2FF);
  static const Color backgroundMid = Color(0xFFE7E6FF);
  static const Color backgroundBottom = Color(0xFFE3E1FF);

  static const Color background = backgroundMid;
  static const Color surface = Colors.white;

  // Primary brand color (accent blue)
  static const Color primary = Color(0xFF1F4DFF);
  static const Color primarySoft = Color(0xFFE3E1FF);

  // Text colors
  static const Color textPrimary = Color(0xFF1B1B1F);
  static const Color textSecondary = Color(0xFF6D6D7A);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Button text on primary background
  static const Color buttonTextOnPrimary = Colors.white;

  // Divider / subtle borders
  static const Color divider = Color(0xFFE5E7EB);
  static const Color borderSubtle = Color(0x33FFFFFF);

  // Glass panel tint & border (panelTint, panelBorder from sample)
  static const Color glassTint = Color(0xFFF7F6FF);
  static const Color glassBorder = Color(0xFFE8E7FF);

  // Glow blobs (background decorative circles)
  static const Color glowBlueSoft = Color(0xFFB7C8FF);
  static const Color glowPurpleSoft = Color(0xFFD3BEFF);
  static const Color glowBlueDeep = Color(0xFFC7D3FF);

  // Snackbar colors
  static const Color snackbarInfo = Color(0xFF2563EB);
  static const Color snackbarSuccess = Color(0xFF16A34A);
  static const Color snackbarError = Color(0xFFDC2626);
  static const Color snackbarText = Colors.white;

  // Loader colors
  static const Color loaderTrack = Color(0x33FFFFFF);
  static const Color loaderProgress = Colors.white;

  // Icon defaults
  static const Color iconPrimary = Color(0xFF4B5563);
}
