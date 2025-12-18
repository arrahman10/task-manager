import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';

enum AppSnackbarType {
  info,
  success,
  error,
}

abstract class AppSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    AppSnackbarType type = AppSnackbarType.info,
    double bottomOffset = 24,
    Duration duration = const Duration(seconds: 3),
  }) {
    final ThemeData theme = Theme.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();

    Color background;
    IconData icon;
    const Color textColor = AppColors.snackbarText;

    switch (type) {
      case AppSnackbarType.info:
        background = AppColors.snackbarInfo;
        icon = Icons.info_outline;
        break;
      case AppSnackbarType.success:
        background = AppColors.snackbarSuccess;
        icon = Icons.check_circle_outline;
        break;
      case AppSnackbarType.error:
        background = AppColors.snackbarError;
        icon = Icons.error_outline;
        break;
    }

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.fromLTRB(16, 0, 16, bottomOffset),
        duration: duration,
        content: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: 18,
                color: textColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
