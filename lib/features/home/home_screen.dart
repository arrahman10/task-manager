import 'package:flutter/material.dart';
import 'package:task_manager/core/widgets/app_drawer.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/screen_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppSnackbar.show(
        context,
        message: 'Welcome to Home.',
        bottomOffset: 24,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Home')),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Placeholder screen (drawer + tasks UI will be added later).',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
