import 'package:flutter/material.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/core/constants/app_typography.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const _AppShell(),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenBackground(
        child: SafeArea(
          child: _LandingContent(),
        ),
      ),
    );
  }
}

class _LandingContent extends StatelessWidget {
  const _LandingContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Task Manager',
              style: AppTypography.h1,
            ),
            const SizedBox(height: 8),
            Text(
              'Glass-style dashboard, gradient background, and core theme are ready.\n'
              'Next commits will add authentication, profile, and task features.',
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Get started',
              onPressed: () {
                // Will be wired to real flow in upcoming commits.
              },
            ),
          ],
        ),
      ),
    );
  }
}
