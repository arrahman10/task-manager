import 'package:flutter/material.dart';
import 'package:task_manager/session/session_manager.dart';
import 'package:task_manager/core/widgets/glass_container.dart';
import 'package:task_manager/core/widgets/screen_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = SessionManager.userName ?? 'Demo User';
    final email = SessionManager.userEmail ?? 'demo@taskmanager.app';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GlassContainer(
            radius: 24,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $name'),
                const SizedBox(height: 8),
                Text('Email: $email'),
                const SizedBox(height: 16),
                const Text('Placeholder screen (UI will be added later).'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
