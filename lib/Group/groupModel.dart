import 'dart:math';
import 'package:roommates/Task/database_demo.dart';
import 'package:get/get.dart';



class GroupModel {

  String? id;
  bool? parentMode;
  List<String>? tasks;  //list of task ids for this group
  List<String>? users;  //list of UsersIDs in this group
  List<String>? parentUsers;


  GroupModel({
    this.id,
    this.parentMode,
    this.tasks,
    this.users,
    this.parentUsers
  });

  GroupModel.fromJson(Map<String, dynamic> json) {
    parentUsers = json['parentUsers'];
    id = json['id'].toString();
    parentMode = json['parentMode'];
    tasks = json['tasks'];
    users = json['users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parentMode'] = parentMode;
    data['tasks'] = tasks;
    data['users'] = users;
    data['parentUsers'] = parentUsers;
    return data;
  }

  static Future<String> groupGenerator() async {
    final db = Get.put(DBHelper());
    // generates a random 5 digit number (groupID)
    String groupID = "";
    var random = Random();
    for (var i = 0; i < 5; i++) {
      groupID = groupID + random.nextInt(9).toString();
    }
    //check if that groupID is already being used

    //if groupID already exists, generate a new one
    if (await db.groupIDExists(groupID)) {
      groupID = await groupGenerator();
    }

    //else return the group id
    return groupID;
  }
}