import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/todoTask.dart';
import '../models/task.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
        await db.execute(
            'CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)');
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert(
          'tasks',
          task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
        .then((value) => taskId = value);
    return taskId;
  }

  Future<void> updateTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id' ");
  }

  Future<void> insertTodoTask(TodoTask todoTask) async {
    Database _db = await database();
    await _db.insert(
      'todo',
      todoTask.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateDescription(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE tasks SET description = '$description' WHERE id = '$id' ");
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description']);
    });
  }

  Future<List<TodoTask>> getTodoTasks(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoTaskMap =
        await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(todoTaskMap.length, (index) {
      return TodoTask(
        id: todoTaskMap[index]['id'],
        title: todoTaskMap[index]['title'],
        taskId: todoTaskMap[index]['taskId'],
        isDone: todoTaskMap[index]['isDone'],
      );
    });
  }

  Future<void> updateTodoIsDone(int id, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id' ");
  }

  Future<void> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id' ");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id' ");
  }
}
