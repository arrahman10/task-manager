import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/app_loader.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/routing/route_names.dart';
import 'package:task_manager/session/session_manager.dart';

/// Splash screen responsible for bootstrapping the app.
///
/// Checks whether a local session token exists and redirects
/// to either the home screen or the login screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Give a short delay so the splash is visible.
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final bool hasSession = await SessionManager.hasValidSession();
    if (!mounted) return;

    final String nextRoute = hasSession ? RouteNames.home : RouteNames.login;

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Task Manager',
                style: AppTypography.h1,
              ),
              SizedBox(height: 16),
              AppLoader(),
            ],
          ),
        ),
      ),
    );
  }
}
