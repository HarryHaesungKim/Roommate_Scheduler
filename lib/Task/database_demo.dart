import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roommates/Task/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  final _db = FirebaseFirestore.instance;
  //static final int _version = 1;
  //static final String _tableName = 'tasks';

  ///
  /// This method creates a task in the database given the input Task.
  ///
  createTask(Task task) async {
    //add the task to the database
    await _db.collection("Tasks").add(task.toJson()).whenComplete(() =>
    //success tell user
        Get.snackbar("Success!",
        "Task has been created.")).
    catchError((error, stackTrace) {
      // something went wrong. tell user
      Get.snackbar("ERROR", "Whoops, something went wrong.");
    });
  }

  getTasks() async {
    List<Map<String, dynamic>> tasks = [];
    _db.collection("Tasks").get().then(
        (querySnapshot) {
          for (var task in querySnapshot.docs)
            {
              tasks.add(task.data());
            }
        }
    );
    return tasks;
  }

  markTaskDone(int? taskid) async {
    final docref = _db.collection("Tasks").doc(taskid.toString());
    docref.update({"isCompleted": 1});
  }

  deleteTask(Task task) async {
    _db.collection("Tasks").doc(task.id.toString()).delete();

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