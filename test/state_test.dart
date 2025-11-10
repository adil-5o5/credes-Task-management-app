import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_management_app/app_providers.dart';
import 'package:task_management_app/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('TasksNotifier add() increases task list size', () async {
    final container = ProviderContainer();
    await container.read(dbServiceProvider).init();

    final listId = await container.read(listsRepoProvider).addList('Test List');

    final notifier = container.read(tasksProvider(listId).notifier);

    await notifier.add(Task(listId: listId, title: 'Task 1'));

    final items = container.read(tasksProvider(listId)).value!;
    expect(items.length, 1);
  });
}
