import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/features/auth/forgot_password_screen.dart';
import 'package:task_manager/features/auth/login_screen.dart';
import 'package:task_manager/features/auth/register_screen.dart';
import 'package:task_manager/features/splash/splash_screen.dart';
import 'package:task_manager/routing/route_names.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
        );

      case RouteNames.login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
        );

      case RouteNames.register:
        return MaterialPageRoute<void>(
          builder: (_) => const RegisterScreen(),
        );

      case RouteNames.forgotPassword:
        return MaterialPageRoute<void>(
          builder: (_) => const ForgotPasswordScreen(),
        );

      // Home এখনো implement হয়নি, তাই glass placeholder।
      case RouteNames.home:
        return MaterialPageRoute<void>(
          builder: (_) => const _PlaceholderScreen(
            title: 'Home',
            message:
                'Home dashboard will be implemented after the task features.',
          ),
        );

      // Profile screen ও future step এ আসবে।
      case RouteNames.profile:
        return MaterialPageRoute<void>(
          builder: (_) => const _PlaceholderScreen(
            title: 'Profile',
            message:
                'Profile screen will be implemented after auth integration.',
          ),
        );

      // Fallback route
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const _PlaceholderScreen(
            title: 'Not found',
            message: 'The requested page does not exist.',
          ),
        );
    }
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ScreenBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: AppTypography.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
