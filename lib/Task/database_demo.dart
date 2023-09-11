import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roommates/Task/task.dart';

class DBHelper {
  final _db = FirebaseFirestore.instance;
  //static final int _version = 1;
  //static final String _tableName = 'tasks';

  ///
  /// This method creates a task in the database given the input Task.
  ///
  createTask(Task task) async {

    await _db.collection("Tasks").add(task.toJson()).then((value)
    =>
        _db.collection("Tasks").doc(value.id).update({"id": value.id.toString()})).whenComplete(() =>
        Get.snackbar("Success!",
           "Task has been created.")).
    catchError((error, stackTrace) {
       //something went wrong. tell user
      Get.snackbar("ERROR", "Whoops, something went wrong.");
    });
    //add the task to the database

  }

  ///
  ///  This method returns all the tasks currently in the database
  ///
  getTasks() async {
    List<Map<String, dynamic>> tasks = [];
    await _db.collection("Tasks").get().then(
        (querySnapshot) {
          for (var task in querySnapshot.docs)
            {
              if(!task.data().containsKey("dummy")) {
                tasks.add(task.data());
              }
            }
        }
    );
    return tasks;
  }

  markTaskDone(String? taskid) async {
    final docref = _db.collection("Tasks").doc(taskid.toString());
    docref.update({"isCompleted": 1}).whenComplete(() =>
        Get.snackbar("Completed",
            "Task marked as complete.")).
    catchError((error, stackTrace) {
      //something went wrong. tell user
      Get.snackbar("ERROR", "Whoops, something went wrong.");
    });
  }

  deleteTask(Task task) async {
    _db.collection("Tasks").doc(task.id).delete().whenComplete(() =>
        Get.snackbar("Success!",
            "Task has been deleted.")).
    catchError((error, stackTrace) {
      //something went wrong. tell user
      Get.snackbar("ERROR", "Whoops, something went wrong.");
    });
  }

  // static Future<void> initDb() async {
  //   if (_db != null) {
  //     debugPrint("not null db");
  //     return;
  //   }
  //   try {
  //     String _path = await getDatabasesPath() + 'tasks.db';
  //     debugPrint("in database path");
  //     _db = await openDatabase(
  //       _path,
  //       version: _version,
  //       onCreate: (db, version) {
  //         debugPrint("creating a new one");
  //         return db.execute(
  //           "CREATE TABLE $_tableName("
  //               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
  //               "title STRING, note TEXT, date STRING, "
  //               "startTime STRING, endTime STRING, "
  //               "remind INTEGER, repeat STRING, "
  //               "color INTEGER, "
  //               "isCompleted INTEGER)",
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // static Future<int> insert(Task task) async {
  //     print("insert function called");
  //     return _db!.insert(_tableName, task.toJson());
  //
  // }
  // static Future<int> delete(Task task) async =>
  //     await _db!.delete(_tableName, where: 'id = ?',
  //         whereArgs: [task.id]);
  //
  // static Future<List<Map<String, dynamic>>> query() async {
  //   print("query function called");
  //   return _db!.query(_tableName);
  // }
  // static Future<int> update(int? id) async {
  //   print("update function called");
  //   return await _db!.rawUpdate('''
  //   UPDATE tasks
  //   SET isCompleted = ?
  //   WHERE id = ?
  //   ''', [1, id]);
  // }
}