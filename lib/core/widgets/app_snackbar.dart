import 'package:flutter/material.dart';
import 'package:task_manager/core/widgets/glass_container.dart';

abstract final class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    double bottomOffset = 80,
  }) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.fromLTRB(16, 0, 16, bottomSafeArea + bottomOffset),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      content: GlassContainer(
        radius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        blur: 14,
        opacity: 0.18,
        child: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }
}
