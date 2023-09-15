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
  /// This method adds a task to the database for this group
  ///
  Future<void> createTask1(String groupID, Task task) async  {
    await _db.collection("Group").doc(groupID).collection("tasks").add(task.toJson()).then((value)
    =>
        _db.collection("Group").doc(groupID).collection("tasks").doc(value.id).update({"id": value.id.toString()})).whenComplete(() =>
        Get.snackbar("Success!",
            "Task has been created.")).
    catchError((error, stackTrace) {
      //something went wrong. tell user
      Get.snackbar("ERROR", "Whoops, something went wrong.");
    });
  }

  ///
  /// This method returns the list of tasks for a group given a groupID
  ///
  getTasks1(String groupID) async {
    List<Map<String, dynamic>> tasks = [];
    print("groupID is " + groupID);
    final ref = await _db.collection("Group").doc(groupID).collection("tasks").get().then(
            (querySnapshot) {
              for (var task in querySnapshot.docs) {
                if (!task.data().containsKey("dummy")) {
                  tasks.add(task.data());
                }
              }
            }
              );
    return tasks;
  }

  ///
  /// Given a uID and chatroomid get all userIDs that are not uID
  ///
  List<String> getUsersInChatID(String uID, String chatID) {

    List<String> users = chatID.split("_");
    int index = 0;
    for(int i = 0; i < users.length; i++)
      {
        if(users[i] == uID)
          {
            index = i;
          }
      }

    users.removeAt(index);
    return users;
  }

  ///
  /// This method takes a userID and from that returns a list of groupChat titles that user is in
  ///
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
  /// This method returns a map of groupchatids and titles
  ///
  Future<Map<String, String>> getGroupChatInfo(String uID) async {
    final userRef = await _db.collection("Users").doc(uID).get();
    var array = userRef.data()?['chatRooms'];
    List<String> titles = [];
    for(int i = 0; i < array.length; i++)
    {
      final chatRef = await _db.collection("chat_rooms").doc(array[i]).get();
      titles.add(chatRef.data()!['title'].toString());
    }
    Map<String, String> groupInfo = {};
    for(int i = 0; i < array.length; i++)
      {
        //groupInfo.assign(array[i], titles[i]);
        groupInfo[array[i]] = titles[i];
      }
    print("arr" + array.toString());
    print("titles" + titles.toString());
    print("arr leng" + array.length.toString());
    print("db group info" + groupInfo.toString());
    return groupInfo;
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
    //print("Usernames are " + userNames.toString());
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

    String chatID = ids.join("_");

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


    final userRef = _db.collection("Users").doc(uID);
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


  markTaskDone(String groupID, String? taskid) async {
    final docref = _db.collection("Group").doc(groupID).collection("tasks").doc(taskid);
    docref.update({"isCompleted": 1}).whenComplete(() =>
        Get.snackbar("Completed",
            "Task marked as complete.")).
    catchError((error, stackTrace) {
      //something went wrong. tell user
      Get.snackbar("ERROR", "Whoops, something went wrong.");
    });
  }

  deleteTask(String groupID, Task task) async {
    _db.collection("Group").doc(groupID).collection("tasks").doc(task.id).delete().whenComplete(() =>
        Get.snackbar("Success!",
            "Task has been deleted.")).
    catchError((error, stackTrace) {
      //something went wrong. tell user
      Get.snackbar("ERROR", "Whoops, something went wrong.");
    });
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