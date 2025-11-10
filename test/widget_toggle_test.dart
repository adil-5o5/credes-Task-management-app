import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_management_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  testWidgets('Toggling task checkbox updates UI', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MyApp(showOnboarding: true)),
    );
    await tester.pumpAndSettle();

    // Add list
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'List X');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Open list
    await tester.tap(find.text('List X'));
    await tester.pumpAndSettle();

    // Add task
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Demo Task');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Toggle checkbox
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    // Check UI changed
    final text = tester.widget<Text>(find.text('Demo Task'));
    expect(text.style?.decoration, TextDecoration.lineThrough);
  });
}
