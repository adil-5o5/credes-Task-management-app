import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/task/task_editor.dart';

void main() {
  testWidgets('TaskEditor blocks empty title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TaskEditor(listId: 1)));

    await tester.tap(find.text('Add'));
    await tester.pump();

    expect(find.text('Required'), findsOneWidget);
  });
}
