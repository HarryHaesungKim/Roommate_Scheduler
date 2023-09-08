import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roommates/Task/task.dart';

import '../Group/groupModel.dart';

class DBHelper {
  final _db = FirebaseFirestore.instance;
  //static final int _version = 1;
  //static final String _tableName = 'tasks';


  ///
  /// This method checks and returns whether the given group id already
  /// exists inside of the group collection
  ///
  groupIDExists(String groupID) async {
    //get the document with the id groupID
    final docref = _db.collection("Group").doc(groupID);
    // if the document exists, that means the id is being used, return true
    final doc = await docref.get();
    return doc.exists;
  }

  ///
  /// This method adds a user to an existing group in the DB
  ///
  addUserToGroup(String groupID, String uID) async {
      // add user to a list
      List<String> user = [uID];
      // union current list of users in group with user we just made into a list
      // this simply adds the user to the list of users in the group
      final groupref = _db.collection("Group").doc(groupID);
      groupref.update({'Users': FieldValue.arrayUnion(user)});

      //now make sure the groupID of the user matches the group they are now in
      final userRef = _db.collection("Users").doc(uID);
      userRef.update({"groupID": groupID});
  }


  ///
  /// This method sends a message
  ///
  sendMessage() async {

  }

  ///
  /// This method creates a Group in the firestore database
  ///
  createGroup(GroupModel group) async {
    await _db.collection("Group").add(group.toJson());
  }

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

  getUsers() async {
    List<Map<String, dynamic>> names = [];
    await _db.collection("Users").get().then(
            (querySnapshot) {
          for (var user in querySnapshot.docs)
          {
            names.add(user.data());
          }
        }
    );
    return names;
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
}