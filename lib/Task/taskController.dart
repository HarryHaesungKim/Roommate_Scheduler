import 'package:get/get.dart';
import 'package:roommates/Task/database_demo.dart';
import 'package:roommates/Task/task.dart';
import 'package:roommates/Task/database_demo.dart';

class taskController extends GetxController {
  //this will hold the data and update the ui
  final _db = Get.put(DBHelper());

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  final RxList<Task> taskList = List<Task>.empty().obs;

  // add data to table
  //second brackets means they are named optional parameters
  Future<void> addTask({required Task task}) async {
    await _db.createTask(task);
  }

  // get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await _db.getTasks();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  // delete data from table
  void deleteTask(Task task) async {
     await _db.deleteTask(task);
     getTasks();
   }

  // update data int table
  void markTaskCompleted(int? id) async {
     await _db.markTaskDone(id);
     getTasks();
   }
}
