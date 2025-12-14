import 'package:flutter/material.dart';

class AppTypography {
  static const String fontFamily = 'Roboto';

  static TextTheme textTheme() {
    return const TextTheme(
      headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    ).apply(fontFamily: fontFamily);
  }
}
