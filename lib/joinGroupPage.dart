import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/Task/taskController.dart';
import 'package:roommates/groceriesPage.dart';
import 'package:roommates/homePage/addTask.dart';
import 'package:roommates/homePage/messagingPage.dart';
import 'package:roommates/mainPage.dart';
import 'package:roommates/theme.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'Group/groupController.dart';


/**
 * This class holds the widget that allows users to join or create a group.
 */
class joinGroupPage extends StatefulWidget {
  joinGroupPage({Key? key}) : super(key: key);

  @override
  State<joinGroupPage> createState() => _joinGroupPage();
}

class _joinGroupPage extends State<joinGroupPage> {

  /// controller for groupid text field
  final _groupIDController = TextEditingController();


  /// groupController
  final _groupController = Get.put(groupController());

  final _uID = FirebaseAuth.instance.currentUser?.uid;

  ///
  /// This method returns whether the groupID is formatted correct
  /// returns whether the group id is a 5 digit number
  ///
  bool isGIDFormatted(String groupID) {
    final fiveDigit = RegExp(r'^\d{5}$');
    return fiveDigit.hasMatch(groupID);
  }

  ///
  /// Method attempts to have user join the group with the specified group code
  ///
  joinGroup(String groupID, String uID) async
  {
    bool groupExist =  await _groupController.doesGroupExist(groupID);
    // first check if the group exists in the db or not
    if(!groupExist)
      {
        Get.snackbar("Error", "This is not a valid group ID, try another or create group");
        return;
      }
    // group exists add user to this group
    _groupController.addUserToGroup(groupID, uID);
    MaterialPageRoute(builder: ((context) => mainPage()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/logo.png",
                height: 100,
                width: 100,
              ),
              Text(
                'Join/Create Group',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              // Join group code textbox
              SizedBox(height: 15),
              // Group
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[130],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextField(
                      controller: _groupIDController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.onetwothree_outlined,
                          color: Colors.blue,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 14.0),
                        hintText: 'Group Code',
                      ),
                    ),
                  ),
                ),
              ),

              // Join Group button
              SizedBox(height: 50),
              Container(
                // decoration: BoxDecoration(color: Colors.green[300]),
                width: 180.0,
                height: 40.0,

                child: ElevatedButton(
                  child: Text(
                    'Join group',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    //side: BorderSide(color: Colors.white)
                  ))),
                  onPressed: () {
                    // TODO: Database implementation
                    // Need to connect to database. Link code to an existing group and tasks that belong to that group.
                    if(isGIDFormatted(_groupIDController.text.trim()))
                      {
                        joinGroup(_groupIDController.text.trim(), _uID!);
                      }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => mainPage()));
                  },
                ),
              ),

              // Create group button
              SizedBox(height: 25),
              Container(
                // decoration: BoxDecoration(color: Colors.green[300]),
                width: 180.0,
                height: 40.0,
                child: ElevatedButton(
                  child: Text(
                    'Create group',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    //side: BorderSide(color: Colors.white)
                  ))),
                  onPressed: () {
                    // TODO: Database implementation
                    // Need to connect to database. Link code to a new group and tasks that belong to that group (empty).
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => mainPage()));
                  },
                ),
              ),
            ],
          )),
        ));
  }
}
