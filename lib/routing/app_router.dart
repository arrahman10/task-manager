import 'package:flutter/material.dart';
import 'package:task_manager/features/auth/login_screen.dart';
import 'package:task_manager/features/home/home_screen.dart';
import 'package:task_manager/features/profile/profile_screen.dart';
import 'package:task_manager/features/splash/splash_screen.dart';
import 'package:task_manager/routing/route_names.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
