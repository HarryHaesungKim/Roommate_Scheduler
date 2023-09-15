import 'package:get/get.dart';
import 'package:roommates/Task/database_demo.dart';
import 'package:roommates/Task/task.dart';
import 'package:roommates/Task/database_demo.dart';
import 'package:roommates/Group/groupModel.dart';

class groupController extends GetxController {
  //this will hold the data and update the ui
  final _db = Get.put(DBHelper());

  @override
  void onReady() {
    super.onReady();
  }

  final List<String> userList = List<String>.empty().obs;

  // add data to table
  //second brackets means they are named optional parameters


  // get all the data from table
  Future<bool> doesGroupExist(String groupID) async {
    return await _db.groupIDExists(groupID);
  }

  Future<void> addUserToGroup(String groupID, String uID) async {
    await _db.addUserToGroup(groupID, uID);
  }

  Future<void> createGroup(GroupModel group, String uID) async {
    await _db.createGroup(group, uID);
  }

  Future<List<String>> getUsersInGroup(String uID) async
  {
    return await _db.getUsersInGroupID(uID);
  }

  Future<List<String>> getUserIDsInGroup(String uID) async
  {
    return await  _db.getUsersIDsInGroup(uID);
  }

  Future<String> getGroupIDFromUser(String uID) async {
    return await _db.getGroupID(uID);
  }

}
