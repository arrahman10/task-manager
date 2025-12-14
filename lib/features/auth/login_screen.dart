import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/routing/route_names.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleDemoLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, RouteNames.home);

    AppSnackbar.show(
      context,
      message: 'Logged in as demo user. Full login flow will be added later.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets safePadding = MediaQuery.of(context).padding;

    return Scaffold(
      body: ScreenBackground(
        child: SafeArea(
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Login',
                      style: AppTypography.h1,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Placeholder screen (UI will be added later).',
                      style: AppTypography.body,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: (safePadding.bottom > 0 ? safePadding.bottom : 24),
                child: Builder(
                  builder: (innerContext) {
                    return PrimaryButton(
                      label: 'Continue (Demo)',
                      onPressed: () => _handleDemoLogin(innerContext),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
