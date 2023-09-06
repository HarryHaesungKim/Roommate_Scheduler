import 'dart:math';
import 'package:roommates/Task/database_demo.dart';
import 'package:get/get.dart';

groupGenerater(){

  final _db = Get.put(DBHelper());
  // generates a random 5 digit number (groupID)
  var groupID = "";
  var random = new Random();
  for (var i = 0; i < 5; i++) {
    groupID = groupID + random.nextInt(9).toString();
  }
  //check if that groupID is already being used

  //if groupID already exists, generate a new one
  if(_db.groupIDExists(groupID))
    {

    }

  //else return the group id
  return groupID;
}