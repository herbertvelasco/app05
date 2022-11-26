import 'dart:io';
import 'package:app05/models/task_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBAdmin {
  Database? myDatabase;
  //singleton
  static final DBAdmin db = DBAdmin._();
  DBAdmin._();
  Future<Database?> chekDatabase() async {
    if (myDatabase != null) {
      return myDatabase;
    }
    myDatabase = await initDatabase();
    return myDatabase;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "TaskDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database dbx, int version) async {
      await dbx.execute(
          "CREATE TABLE task(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, status TEXT)");
    });
  }

  Future<int> insertRawTask(TaskModel model) async {
    Database? db = await chekDatabase();
    int res = await db!.rawInsert(
        "INSERT INTO task(title,description,status) VALUES ('${model.title}','${model.description}','${model.status.toString()}')");
    return res;
  }

  Future<int> insertTask(TaskModel model) async {
    Database? db = await chekDatabase();
    int res = await db!.insert(
      "task",
      {
        "title": model.title,
        "description": model.description,
        "status": model.status,
      },
    );
    return res;
  }

  getRawTasks() async {
    Database? db = await chekDatabase();
    List tasks = await db!.rawQuery("SELECT * FROM task");
    print(tasks);
  }

  Future<List<TaskModel>> getTask() async {
    Database? db = await chekDatabase();
    List<Map<String, dynamic>> tasks = await db!.query("task");
    List<TaskModel> taskModelList =
        tasks.map((e) => TaskModel.deMapAModel(e)).toList();

    // tasks.forEach((element) {
    //   TaskModel task = TaskModel.deMapAModel(element);
    //   taskModelList.add(task);
    // });

    return taskModelList;
  }

  updateRawTask() async {
    Database? db = await chekDatabase();
    int res = await db!.rawUpdate(
        "UPDATE task SET title = 'Ir de compras', description = 'comprar comida', status = 'true' WHERE id = 2");
    print(res);
  }

  updateTask() async {
    Database? db = await chekDatabase();
    int res = await db!.update(
        "task",
        {
          "title": "Ir al cine",
          "description": "El viernes en la tarde",
          "status": "false",
        },
        where: "id = 2");
  }

  deleteRawTask() async {
    Database? db = await chekDatabase();
    int res = await db!.rawDelete("DELETE FROM task WHERE id = 2");
    return res;
  }

  Future<int> deleteTask(int id) async {
    Database? db = await chekDatabase();
    int res = await db!.delete("task", where: "id = $id");
    return res;
  }
}
