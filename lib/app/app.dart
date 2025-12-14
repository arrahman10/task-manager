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
      theme: AppTheme.light(),
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
