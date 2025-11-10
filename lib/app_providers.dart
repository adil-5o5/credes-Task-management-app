import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'database.dart';
import 'models.dart';
import 'list/lists_repository.dart';
import 'task/tasks_repository.dart';

final dbServiceProvider = Provider((ref) => DatabaseService());

final listsRepoProvider = Provider((ref) {
  return ListsRepository(ref.read(dbServiceProvider));
});

final tasksRepoProvider = Provider((ref) {
  return TasksRepository(ref.read(dbServiceProvider));
});

final filterProvider = StateProvider<String>((ref) => 'all');
final sortAscProvider = StateProvider<bool>((ref) => true);
final searchQueryProvider = StateProvider<String>((ref) => '');

class ListsNotifier extends StateNotifier<AsyncValue<List<TaskList>>> {
  final ListsRepository repo;

  ListsNotifier(this.repo) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    try {
      final data = await repo.getLists();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(String title) async {
    await repo.addList(title);
    await load();
  }

  Future<void> rename(int id, String title) async {
    await repo.renameList(id, title);
    await load();
  }

  Future<void> remove(int id) async {
    await repo.deleteList(id);
    await load();
  }
}

final listsProvider =
    StateNotifierProvider<ListsNotifier, AsyncValue<List<TaskList>>>((ref) {
      return ListsNotifier(ref.read(listsRepoProvider));
    });

class TasksNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TasksRepository repo;
  final int listId;

  TasksNotifier(this.repo, this.listId) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    try {
      final data = await repo.getTasks(listId: listId);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(Task t) async {
    await repo.addTask(t);
    await load();
  }

  Future<void> update(Task t) async {
    await repo.updateTask(t);
    await load();
  }

  Future<void> toggle(int id, String newStatus) async {
    await repo.updateStatus(id, newStatus);
    await load();
  }

  Future<void> remove(int id) async {
    await repo.deleteTask(id);
    await load();
  }

  Future<void> apply(String filter, bool asc, String q) async {
    final data = await repo.getTasks(
      listId: listId,
      status: filter == 'all' ? null : filter,
      sortDueAsc: asc,
      query: q.isEmpty ? null : q,
    );
    state = AsyncValue.data(data);
  }
}

final tasksProvider =
    StateNotifierProvider.family<TasksNotifier, AsyncValue<List<Task>>, int>((
      ref,
      listId,
    ) {
      return TasksNotifier(ref.read(tasksRepoProvider), listId);
    });
