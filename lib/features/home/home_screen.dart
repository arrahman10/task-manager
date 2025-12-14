import 'package:flutter/material.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/data/local/local_storage.dart';
import 'package:task_manager/routing/route_names.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await LocalStorage().clearAuthToken();
    if (!context.mounted) return;

    AppSnackbar.show(context, message: 'Logged out (demo)');
    Navigator.pushReplacementNamed(context, RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Home',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Placeholder screen (drawer + tasks UI will be added later).',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => _logout(context),
                    child: const Text('Logout (Demo)'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
