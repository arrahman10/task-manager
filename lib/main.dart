import 'package:flutter/material.dart';
import 'package:task_manager/app/app.dart';
import 'package:task_manager/core/storage/local_storage.dart';

Future<void> main() async {
  // Ensure Flutter engine is initialized before using plugins.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences-backed local storage.
  await LocalStorage.init();

  // Start the root application widget.
  runApp(const TaskManagerApp());
}
