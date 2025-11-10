import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_management_app/database.dart';
import 'package:task_management_app/list/lists_repository.dart';
import 'package:task_management_app/models.dart';
import 'package:task_management_app/task/tasks_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('Repository add & fetch tasks', () async {
    final db = DatabaseService();
    await db.init();

    final lists = ListsRepository(db);
    final tasks = TasksRepository(db);

    final listId = await lists.addList('Work');
    expect(listId, isNonZero);

    await tasks.addTask(Task(listId: listId, title: 'Implement Repo'));
    final fetched = await tasks.getTasks(listId: listId);

    expect(fetched.length, 1);
    expect(fetched.first.title, 'Implement Repo');
  });
}
