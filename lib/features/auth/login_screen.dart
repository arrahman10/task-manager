import 'package:flutter/material.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/routing/route_names.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                const SizedBox(height: 12),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Placeholder screen (UI will be added later).',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      AppSnackbar.show(
                        context,
                        message: 'Demo: navigating to Home',
                      );
                      Navigator.pushReplacementNamed(context, RouteNames.home);
                    },
                    child: const Text('Continue (Demo)'),
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
