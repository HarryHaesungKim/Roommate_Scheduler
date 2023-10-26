import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roommates/Group/groupController.dart';
import 'package:roommates/Task/taskController.dart';
import 'package:roommates/User/user_controller.dart';
import 'package:roommates/homePage/addTask.dart';
import 'package:roommates/homePage/GroupChatsListPage.dart';
import 'package:roommates/theme.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'package:roommates/themeData.dart';
//import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Task/TaskObject.dart';
import '../Task/taskView.dart';

class homePage extends StatefulWidget {
  homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePage();
}

class _homePage extends State<homePage> {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  // The current user and group
  String? currUser = FirebaseAuth.instance.currentUser?.uid;
  late Future<String> futureCurrGroup;
  String currGroup = '';
  double taskRate = 0.0;
  // Controllers
  final taskController taskCon = taskController();
  final groupController groupCon = groupController();
  final userController userCon = userController();
  // Media query stuff?
  static late MediaQueryData _mediaQueryData;

  // Is group admin future
  late Future<bool> isGroupAdmin;

  late bool gotIsGroupAdmin;
  late Future<String> futureThemeColor;
  late Future<String> futureThemeBrightness;
  late Future<String> userName;

  String themeColor = '';
  String themeBrightness = '';
  String currentName = '';
  // Getting the tasks from firebase.
  Stream<List<TaskObject>> readTasks() {
    // // Get list of users in the same group. Waits until we have the data.
    // final futureData = await Future.wait([groupCon.getGroupIDFromUser(currUser!)]);

    return FirebaseFirestore.instance
        .collection('Group')
        .doc(currGroup)
        .collection('tasks')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TaskObject.fromJson(doc.data()))
        .toList());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCurrGroup = groupCon.getGroupIDFromUser(currUser!);
    isGroupAdmin = groupCon.isGroupAdminModeByID(currUser!);
    futureThemeBrightness = userCon.getUserThemeBrightness(currUser!);
    futureThemeColor = userCon.getUserThemeColor(currUser!);
    userName = userCon.getUserName(currUser!);
  }


  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    return FutureBuilder(
      future: Future.wait([futureCurrGroup, isGroupAdmin,futureThemeBrightness,futureThemeColor,userName]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        // If there's no error and the snapshot has data.
        if (snapshot.hasData) {
          //return Text("GroupCode: ${snapshot.data}");=

          // Setting the groupID.
          currGroup = snapshot.data[0];
          gotIsGroupAdmin = snapshot.data[1];
          themeBrightness = snapshot.data[2];
          themeColor = snapshot.data[3];
          currentName = snapshot.data[4];

          return StreamBuilder<List<TaskObject>>(
            stream: readTasks(),
            builder: (context, snapshot) {
              // If there's an error.
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.data}');
              }

              // If there's no error and the snapshot has data.
              else if (snapshot.hasData) {
                // Setting the task data.
                final tasksData = snapshot.data!;
                return MaterialApp(
                  theme: showOption(themeBrightness),
                  title: "Tasks",
                  home: Scaffold(
                    appBar: AppBar(
                      backgroundColor: setAppBarColor(themeColor, themeBrightness),
                      title: const Text("Home"),
                      actions: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GroupChatsListPage()),
                                );
                              },
                              child: const Icon(Icons.send),
                            )),
                      ],
                    ),
                    floatingActionButton: FloatingActionButton(
                        backgroundColor: setAppBarColor(themeColor, themeBrightness),
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => addTask()),
                          );
                          Get.lazyPut(() => taskController());

                          // Add task.
                        },
                        child: const Icon(Icons.add,)),
                    // Building the widget.
                    body: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Column(
                        children: [
                          addTaskBar(),
                          SizedBox(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight - 85,
                            // 85 pixels is the height of the bottom bar.
                            child: ListView.builder(
                                primary: true,
                                itemCount: tasksData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //print("tasks ${taskCon.taskList[index].title!}");
                                  TaskObject task = tasksData[index];
                                  var title = task.title;
                                  int? coloDB = task.color;

                                  // Adding extra padding at the last item for the button (so that it doesn't overlap).
                                  if (index == tasksData.length - 1) {
                                    return Padding(
                                      // Spacing between elements:
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 70),

                                      // The task tiles.
                                      child: InkWell(
                                        child: taskView(task),
                                        onTap: () {
                                          showBottomSheet(context, task);
                                        },
                                      ),
                                    );
                                  }

                                  return Padding(
                                    // Spacing between elements:
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 0),

                                    // The task tiles.
                                    child: InkWell(
                                      child: taskView(task),
                                      onTap: () {
                                        showBottomSheet(context, task);
                                      },
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
                    }),
                  ),
                );
              }
              // Loading.
              else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },

            //child: MyStatefulWidget()
          );
        }

        // If there's an error.
        else if (snapshot.hasError) {
          return Text("Something went wrong! ${snapshot.error}");
        }

        // Loading.
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  addTaskBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 12, top: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Upcoming Tasks",
                style: headingTextStyle,
              ),
            ],
          ),

          // Refresh button
          // ElevatedButton.icon(
          //   onPressed:  () async {
          //     build(context);
          //   },
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all<Color>(Colors.orange[700]!),
          //   ),
          //   icon: const Icon(
          //     Icons.refresh,
          //     color: Colors.white,
          //     size: 24.0,
          //   ),
          //     label: const Text(''),
          // ),

          Container(
            height: 37.0,
            width: 40.0,
            color: setAppBarColor(themeColor,themeBrightness),
            child: TextButton(
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                build(context);
              },
            ),
          ),

          // Add task button
          ElevatedButton(
            onPressed: () async {
              //await Get.to(addTask());
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => addTask()),
              // );

              Get.lazyPut(() => taskController());

              if (gotIsGroupAdmin) {
                if (!await groupCon.isUserAdmin(currUser!)) {
                  showNotAdminUser(context);
                } else {
                  await Get.to(addTask());
                  taskCon.getTasks(currGroup);
                  //taskCon = Get.put(taskController());
                }
              } else {
                await Get.to(addTask());
                taskCon.getTasks(currGroup);
              }
              // check if the current user is an admin user
              // if(!await _groupController.isUserAdmin(uID!))
              //   {
              //     showNotAdminUser(context);
              //   }
              // else
              // {
              //   await Get.to(addTask());
              //   taskCon.getTasks(groupID);
              //   //taskCon = Get.put(taskController());
              // }
            },
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all<Color>(setAppBarColor(themeColor,themeBrightness)!),
            ),
            child: const Text(
              '+ Add Task',
            ),
          ),
        ],
      ),
    );
  }

  showNotAdminUser(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Okay"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Not Admin!"),
      content: const Text("You are not an admin user, cannot create tasks!"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showNotAdminUserComplete(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Okay"),
      onPressed: () {
        Get.back();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Not Admin!"),
      content: const Text("You are not an admin user, cannot complete task!"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showBottomSheet(BuildContext context, TaskObject task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? _mediaQueryData.size.height * 0.32
            : _mediaQueryData.size.height * 0.32,
        width: _mediaQueryData.size.width,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          Spacer(),
          //if you are an admin user, you can vote other's task. others can't vote.
          //if you are not admin user, everyone can vote other's task.
          task.isCompleted == 1
              ? _buildBottomSheetButton(
              label: "Vote task",
              onTap: () async {
                if (gotIsGroupAdmin) {
                  if (await groupCon.isUserAdmin(currUser!) != task.assignedUserName){
                    await createVoting(context, task);
                    Get.back();
                  }else{
                    Get.snackbar("Error:", "You aren't admin, and you can't vote other's task");
                  }
                }else{
                  if (task.assignedUserName != currentName) {
                    await createVoting(context, task);
                    Get.back();
                  }else{
                    Get.snackbar("Error:", "You can‘t vote your task");
                  }
                }
              },
              clr: Colors.yellow[300])
              : _buildBottomSheetButton(
              label: "Task Completed",
              //Question here: Admin or not admin can only mark his own task
              onTap: () async {
                if (gotIsGroupAdmin) {
                  if (await groupCon.isUserAdmin(currUser!)) {
                    taskCon.markTaskCompleted(currGroup, task.id);
                    Get.back();
                  } else {
                    Get.back();
                    Get.snackbar("Not Admin!",
                        "Not an admin user, cannot mark tasks as complete");
                  }
                } else {
                  taskCon.markTaskCompleted(currGroup, task.id);
                  Get.back();
                }
              },
              clr: primaryClr),
          _buildBottomSheetButton(
              label: "Delete Task",
              onTap: () async {
                if (gotIsGroupAdmin) {
                  if (await groupCon.isUserAdmin(currUser!)) {
                    taskCon.deleteTask(currGroup, task);
                    Get.back();
                  } else {
                    Get.back();
                    Get.snackbar(
                        "Not Admin!", "Not an admin user, cannot delete tasks");
                  }
                } else {
                  taskCon.deleteTask(currGroup, task);
                  Get.back();
                }
              },
              clr: Colors.red[300]),
          SizedBox(
            height: 20,
          ),
          _buildBottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true),
          SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  _buildBottomSheetButton(
      {required String label,
        Function? onTap,
        Color? clr,
        bool isClose = false}) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: _mediaQueryData.size.width! * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                ? Colors.grey[600]!
                : Colors.grey[300]!
                : clr!,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
              label,
              style: isClose
                  ? titleTextStle
                  : titleTextStle.copyWith(color: Colors.white),
            )),
      ),
    );
  }
  Future<void> createVoting(BuildContext context,TaskObject task) async {

    return await showDialog(context: context, builder: (context) {


      return StatefulBuilder(builder: (context, setState) {

        return AlertDialog(
          // Rounding corners of the dialogue.
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          backgroundColor:_getBGClr(task.color),
          title: Text("Task Title:" + task.title!,style:
          TextStyle(
            //fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white
          ),),
          content: SingleChildScrollView(
              child: Column(
                  children:[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          textAlign: TextAlign.left,
                          //notificationTitles[index],
                          task.startTime! + "-   " + task.endTime!,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              //fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white
                            ),
                          )
                      ),
                    ),
                    SizedBox(height: 25,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          textAlign: TextAlign.left,
                          //notificationTitles[index],
                          "Due date: "+ task.date!,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              //fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white
                            ),
                          )
                      ),
                    ),
                    SizedBox(height: 25,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          textAlign: TextAlign.left,
                          //notificationTitles[index],
                          "Description: " + task.note!,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              //fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white
                            ),
                          )
                      ),
                    ),
                    SizedBox(height: 25,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          textAlign: TextAlign.left,
                          //notificationTitles[index],
                          "Task Assign: "+ task.assignedUserName!,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              //fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white
                            ),
                          )
                      ),
                    ),
                    SizedBox(height: 25,),
                    RatingBar.builder(
                      initialRating: 1,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        taskRate = rating;
                      },
                      updateOnDrag: true,
                    ),
                  ]
              )
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  alignment: Alignment.center,
                ),
                child: const Text('Submit'),
                onPressed: () {
                  taskCon.setRate(currGroup,task,taskRate);

                },
              ),
            ),
          ],
        );

      });

    });
  }
  _getBGClr(int? no) {
    switch (no) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }

}
