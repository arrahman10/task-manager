import 'package:flutter/material.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/routing/app_router.dart';
import 'package:task_manager/routing/route_names.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,

      // Global theme (glass-style, gradient background, Roboto typography).
      theme: AppTheme.light(),

      // Start from splash route.
      initialRoute: RouteNames.splash,

      // Centralized route generator.
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
