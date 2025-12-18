import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:task_manager/app/app.dart';

void main() {
  testWidgets(
    'TaskManagerApp renders landing shell',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const TaskManagerApp());

      // Verify that core landing UI texts are shown.
      expect(find.text('Task Manager'), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);

      // Verify that no legacy counter text is present.
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsNothing);
    },
  );
}
