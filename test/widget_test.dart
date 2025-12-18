import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:task_manager/app/app.dart';

void main() {
  testWidgets(
    'TaskManagerApp shows splash screen while bootstrapping',
    (WidgetTester tester) async {
      // Build the app and trigger a frame.
      await tester.pumpWidget(const TaskManagerApp());

      // Verify that the splash title is visible.
      expect(find.text('Task Manager'), findsOneWidget);

      // Verify that the loader from the splash is rendered.
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    },
  );
}
