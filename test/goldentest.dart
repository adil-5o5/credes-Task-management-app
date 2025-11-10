import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget sampleTile(bool done) {
  return MaterialApp(
    home: Material(
      child: ListTile(
        leading: Checkbox(value: done, onChanged: (_) {}),
        title: Text(
          'Sample Task',
          style: TextStyle(
            decoration: done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: const Text('2025-11-09 • Med'),
      ),
    ),
  );
}

void main() {
  testWidgets('Golden: Task tile light mode', (tester) async {
    await tester.pumpWidget(sampleTile(false));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/task_tile_light.png'),
    );
  });
}
