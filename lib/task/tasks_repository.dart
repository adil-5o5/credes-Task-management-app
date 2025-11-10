import '../database.dart';
import '../models.dart';

class TasksRepository {
  final DatabaseService dbs;

  TasksRepository(this.dbs);

  Future<List<Task>> getTasks({
    required int listId,
    String? status,
    bool sortDueAsc = true,
    String? query,
  }) async {
    final where = ['listId = ?'];
    final args = [listId];

    if (status != null) {
      where.add('status = ?');
      args.add(status as int);
    }

    if (query != null) {
      where.add('title LIKE ?');
      args.add('%$query%' as int);
    }

    final rows = await dbs.db.query(
      'tasks',
      where: where.join(' AND '),
      whereArgs: args,
      orderBy:
          'CASE WHEN dueDate IS NULL THEN 1 ELSE 0 END, dueDate ${sortDueAsc ? 'ASC' : 'DESC'}',
    );

    return rows.map(Task.fromMap).toList();
  }

  Future<List<Map<String, Object?>>> globalSearchByTitle(String q) async {
    return dbs.db.rawQuery(
      '''
      SELECT tasks.id, tasks.title, tasks.dueDate, tasks.status, lists.title AS listTitle
      FROM tasks JOIN lists ON tasks.listId = lists.id
      WHERE tasks.title LIKE ?
      ORDER BY tasks.dueDate IS NULL, tasks.dueDate ASC
    ''',
      ['%$q%'],
    );
  }

  Future<int> addTask(Task t) => dbs.db.insert('tasks', t.toMap());

  Future<int> updateTask(Task t) =>
      dbs.db.update('tasks', t.toMap(), where: 'id=?', whereArgs: [t.id]);

  Future<int> updateStatus(int id, String status) => dbs.db.update(
    'tasks',
    {'status': status},
    where: 'id=?',
    whereArgs: [id],
  );

  Future<int> deleteTask(int id) =>
      dbs.db.delete('tasks', where: 'id=?', whereArgs: [id]);
}
