import 'package:flutter/material.dart';
import 'package:task_manager/app/app.dart';
import 'package:task_manager/core/storage/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  runApp(const TaskManagerApp());
}
