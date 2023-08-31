import 'package:flutter/material.dart';
import 'package:roommates/Task/taskController.dart';
import 'package:roommates/groceriesPage/groceriesPage.dart';
import 'package:roommates/homePage/addTask.dart';
import 'package:roommates/homePage/messagingPage.dart';
import 'package:roommates/mainPage.dart';
import 'package:roommates/theme.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

/**
 * This class holds the widget that allows users to join or create a group.
 */
class joinGroupPage extends StatefulWidget {
  joinGroupPage({Key? key}) : super(key: key);

  @override
  State<joinGroupPage> createState() => _joinGroupPage();
}

class _joinGroupPage extends State<joinGroupPage> {
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
