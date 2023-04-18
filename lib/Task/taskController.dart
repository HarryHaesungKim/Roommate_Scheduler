import 'package:get/get.dart';
import 'package:roommates/Task/taks.dart';

class taskController extends GetxController {
  //this will hold the data and update the ui

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  final RxList<Task> taskList = List<Task>.empty().obs;

  // add data to table
  //second brackets means they are named optional parameters
  Future<void> addTask({required Task task}) async {
  }

  // get all the data from table
  void getTasks() async {
  }

  // delete data from table
  void deleteTask(Task task) async {
  }

  // update data int table
  void markTaskCompleted(int? id) async {
  }
}
