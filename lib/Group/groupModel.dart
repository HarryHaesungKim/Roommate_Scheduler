import 'dart:math';
import 'package:roommates/Task/database_demo.dart';
import 'package:get/get.dart';



class GroupModel {

  String? id;
  bool? parentMode;
  List<String>? tasks;  //list of task ids for this group
  List<String>? users;  //list of UsersIDs in this group


  GroupModel({
    this.id,
    this.parentMode,
    this.tasks,
    this.users
  });

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    parentMode = json['parentMode'];
    tasks = json['tasks'];
    users = json['users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentMode'] = this.parentMode;
    data['tasks'] = this.tasks;
    data['users'] = this.users;
    return data;
  }

  String groupGenerater() {
    final _db = Get.put(DBHelper());
    // generates a random 5 digit number (groupID)
    String groupID = "";
    var random = new Random();
    for (var i = 0; i < 5; i++) {
      groupID = groupID + random.nextInt(9).toString();
    }
    //check if that groupID is already being used

    //if groupID already exists, generate a new one
    if (_db.groupIDExists(groupID)) {
      groupID = groupGenerater();
    }

    //else return the group id
    return groupID;
  }
}