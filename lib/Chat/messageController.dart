import 'package:get/get.dart';
import 'package:roommates/Task/database_demo.dart';
import 'package:roommates/Task/task.dart';
import 'package:roommates/Task/database_demo.dart';

class messageController extends GetxController{
  //this will hold the data and update the ui
  final _db = Get.put(DBHelper());

  ///
  /// This method sends a message to the specified user(s)
  /// writes a message in the database
  ///
  sendMessage()
  {

  }

  ///
  /// This method gets messages from user
  /// reads from database
  ///
  getMessages()
  {

  }

}