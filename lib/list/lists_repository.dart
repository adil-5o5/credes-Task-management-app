import '../database.dart';
import '../models.dart';

class ListsRepository {
  final DatabaseService dbs;

  ListsRepository(this.dbs);

  Future<List<TaskList>> getLists() async {
    final rows = await dbs.db.query('lists', orderBy: 'id DESC');
    return rows.map(TaskList.fromMap).toList();
  }

  Future<int> addList(String title) async {
    return dbs.db.insert('lists', {'title': title});
  }

  Future<int> renameList(int id, String title) async {
    return dbs.db.update(
      'lists',
      {'title': title},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<int> deleteList(int id) async {
    await dbs.db.delete('tasks', where: 'listId=?', whereArgs: [id]);
    return dbs.db.delete('lists', where: 'id=?', whereArgs: [id]);
  }
}
