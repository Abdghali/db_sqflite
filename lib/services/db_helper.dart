import 'dart:io';
import 'package:flutter_sqflite/models/task.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  /// singlton
  DBHelper._();
  static final DBHelper dbHelper = DBHelper._();

  Database? myDatabase;
  String? tableName = 'Tasks';

  /// initial database
  initDB() async {
    myDatabase ??= await connectToDB();
  }

  /// create table
  createTable(Database db) async {
    await db.execute(
        'CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT,task_name TEXT,isDone INTEGER)');
  }

  /// connect to db
  Future<Database> connectToDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String dbPath = join(appDocPath, 'task.db');
    Database database = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      createTable(db);
    });
    return database;
  }

// deal with db table
  addTask(Task _task) async {
    try {
      int id = await myDatabase!.insert(tableName!, _task.toJson());
      print(id);
    } on Exception catch (e) {
      print(e);
    }
  }

 Future<List<Task>>  getAllTasks() async {
    List<Task> tasks = [];
    List<Map<String, dynamic>> allTasks = await myDatabase!.query(tableName!);
    allTasks.forEach((element) {
      Task newTask = Task.fromJson(element);
      tasks.add(newTask);
    });

    return tasks;
  }

  

  getTaskById(int? id) {}
  updateTask(Task _task) {}
  deleteTask(int? id) {}
}
