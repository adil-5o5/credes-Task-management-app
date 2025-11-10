import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database? _db;
  Database get db => _db!;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'credes_tasks.db');

    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE lists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            listId INTEGER NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            dueDate INTEGER,
            priority INTEGER NOT NULL DEFAULT 1,
            status TEXT NOT NULL DEFAULT 'todo',
            FOREIGN KEY (listId) REFERENCES lists(id)
          );
        ''');
      },
      onUpgrade: (db, from, to) async {
        if (from < 2) {
          await db.execute(
            "ALTER TABLE tasks ADD COLUMN priority INTEGER NOT NULL DEFAULT 1;",
          );
        }
      },
    );
  }
}
