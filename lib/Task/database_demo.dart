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


  Future<List<String>> getGroupChatTitles(String uID) async {
    final userRef = await _db.collection("Users").doc(uID).get();
    var array = userRef.data()?['chatRooms'];
    print("Groupchat ids" + array.toString());
    List<String> titles = [];
    for(int i = 0; i < array.length; i++)
      {
        final chatRef = await _db.collection("chat_rooms").doc(array[i]).get();
        titles.add(chatRef.data()!['title'].toString());
      }
    print("Group chat titles" + titles.toString());
    return titles;
  }

  ///
  /// This method gets the groupID of a given user
  ///
  Future<String> getGroupID(String uID) async
  {

    final docref = await _db.collection('Users').doc(uID).get();
    String gID = docref.data()?['groupID'];
    return gID;
  }

  ///
  /// This method returns the list of userNames of the users in a group given a userID
  ///
  Future<List<String>> getUsersInGroupID(String uID) async{
    String gID = await getGroupID(uID);
    final groupref = await _db.collection("Group").doc(gID).get();
    var array = groupref.data()?['users'];
    List<String> usersIDs = List<String>.from(array);
    List<String> userNames = [];
    for (var user in usersIDs){
      final userRef = await _db.collection("Users").doc(user).get();
      userNames.add(userRef.data()!['UserName'].toString());
    }
    print("Usernames are " + userNames.toString());
    return userNames;
  }
  ///
  /// This method returns the list of usersIds of the users in a group given a userID
  ///
  Future<List<String>> getUsersIDsInGroup(String uID) async {
    String gID = await getGroupID(uID);
    final groupref = await _db.collection("Group").doc(gID).get();
    var array = groupref.data()?['users'];
    List<String> usersIDs = List<String>.from(array);
    return usersIDs;
  }

  ///
  /// This method creates a chat_room with the sender, as well as list of receivers, and title
  ///
  createChatRoom(String senderID, List<String> receiverIDs, String title) async{
    //create a list of ids and sort to get them in a deterministic order
    List<String> ids = List.from(receiverIDs);
    ids.add(senderID);
    ids.sort();

    String chatID = ids.join("");

    //create the new chatroom in fireStore with the created chatID and title
    print("chatroom id :" + chatID);
    await _db.collection("chat_rooms").doc(chatID).set({"title" : title});

    // add the chatID to all users list of chatrooms they are in
    final userRef = _db.collection("Users").doc(senderID);
    List<String> chatid = [chatID];
    userRef.update({'chatRooms': FieldValue.arrayUnion(chatid)});
    for(int i = 0; i < receiverIDs.length; i++)
      {
        final user = _db.collection('Users').doc(receiverIDs[i]);
        user.update({'chatRooms': FieldValue.arrayUnion(chatid)});
      }
    //await _fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
    //final chatRef = _db.collection('chat_rooms').doc(chatID);
    //chatRef.update({'Title' : title});

    //add empty collection of messages in the chatRoom
    //chatRef.collection('messages');
  }
  
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
      groupref.update({'users': FieldValue.arrayUnion(user)});

      //now make sure the groupID of the user matches the group they are now in
      final userRef = _db.collection("Users").doc(uID);
      userRef.update({'groupID': groupID});
  }

  ///
  /// Adds a new group to the DB
  ///
  createGroup(GroupModel group,String uID) async {
    await _db.collection("Group").doc(group.id).set(group.toJson());


    final userRef = _db.collection("users").doc(uID);
    userRef.update({"groupID": group.id});
  }

  ///
  /// This method sends a message
  ///
  sendMessage() async {

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