
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roommates/Group/groupController.dart';
import 'package:roommates/Task/taskController.dart';
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

  // Controllers
  final taskController taskCon = taskController();
  final groupController groupCon = groupController();

  // Media query stuff?
  static late MediaQueryData _mediaQueryData;

  // Getting the tasks from firebase.
  Stream<List<TaskObject>> readTasks() {

    // // Get list of users in the same group. Waits until we have the data.
    // final futureData = await Future.wait([groupCon.getGroupIDFromUser(currUser!)]);

    return FirebaseFirestore.instance
        .collection('Group').doc(currGroup).collection('tasks')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => TaskObject.fromJson(doc.data()))
            .toList());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCurrGroup = groupCon.getGroupIDFromUser(currUser!);
  }
  String themeBrightness = "";
  String themeColor = "";
  void getUserData() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if(user !=null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();
      Map<String, dynamic> list = db.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          themeBrightness = list['themeBrightness'];
          themeColor = list['themeColor'];
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {

    _mediaQueryData = MediaQuery.of(context);

    return MaterialApp(
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
                        MaterialPageRoute(builder: (context) => GroupChatsListPage()),
                      );                    },
                    child: const Icon(
                        Icons.send
                    ),
                  )
              ),
            ],

        ),

        body: FutureBuilder(
          
          future: futureCurrGroup,

          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            // If there's an error.
            if(snapshot.hasError){
              return Text("Something went wrong! ${snapshot.error}");
            }

            // If there's no error and the snapshot has data.
            else if(snapshot.hasData){

              //return Text("GroupCode: ${snapshot.data}");=

              // Setting the groupID.
              currGroup = snapshot.data;

              return StreamBuilder<List<TaskObject>>(
                    stream: readTasks(),
                    builder: (context, snapshot){

                      // If there's an error.
                      if (snapshot.hasError){
                        return Text('Something went wrong! ${snapshot.data}');
                      }

                      // If there's no error and the snapshot has data.
                      else if (snapshot.hasData){

                        // Setting the task data.
                        final tasksData = snapshot.data!;

                        // Building the widget.
                        return LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {

                              return Column(
                                children:[

                                  addTaskBar(),
                                  SizedBox(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight - 85, // 85 pixels is the height of the bottom bar.
                                      child: ListView.builder(
                                            primary: true,
                                            itemCount: tasksData.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              //print("tasks ${_taskController.taskList[index].title!}");
                                              TaskObject task = tasksData[index];
                                              var title = task.title;
                                              int? coloDB = task.color;


                                              // Adding extra padding at the last item for the button (so that it doesn't overlap).
                                              if(index == tasksData.length - 1){
                                                return Padding(

                                                  // Spacing between elements:
                                                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 70),

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
                                                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),

                                                // The task tiles.
                                                child: InkWell(
                                                  child: taskView(task),
                                                  onTap: () {
                                                    showBottomSheet(context, task);
                                                  },
                                                ),
                                              );



                                            }

                                        ),


                                  ),

                                ],
                              );
                            });

                      }
                      // Loading.
                      else{
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },

                    //child: MyStatefulWidget()
                  );


            }
            // Loading.
            else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },

        ),

        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange[700],
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => addTask()),
              );
              Get.lazyPut(()=>taskController());

              // Add task.
            },child: const Icon(Icons.add)
        ),

      ),
    );
  }

  // Widgets

// Worth viewing: https://flutterforyou.com/how-to-add-space-between-listview-items-in-flutter/

// Need to implement list tile: https://api.flutter.dev/flutter/material/ListTile-class.html

// Might be fun for messagingPage: https://docs.flutter.dev/cookbook/animation/page-route-animation

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final ScrollController _firstController = ScrollController();
  final _taskController = Get.put(taskController());
  final _groupController = Get.put(groupController());
  static late MediaQueryData _mediaQueryData;
  String? uID = FirebaseAuth.instance.currentUser?.uid;
  late String groupID = "";
  late bool isGroupAdmin;

  void setGroupID() async {
    groupID = await _groupController.getGroupIDFromUser(uID!);
    isGroupAdmin = await _groupController.isGroupAdminMode(groupID);
  }

  @override
  Widget build(BuildContext context) {
    setGroupID();
    _taskController.getTasks(groupID);
    _mediaQueryData = MediaQuery.of(context);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children:[
              addTaskBar(),
              SizedBox(
                  width: constraints.maxWidth - constraints.maxWidth * 0.05,
                  height: constraints.maxHeight - constraints.maxHeight * 0.2,
                  child: Obx(() {
                    //thumbVisibility: true,
                    //thickness: 10,
                    return ListView.builder(
                        primary: true,
                        itemCount: _taskController.taskList.length,
                        itemBuilder: (BuildContext context, int index) {
                          print("tasks " + _taskController.taskList[index].title!);
                          Task task = _taskController.taskList[index];
                          var title = task.title;
                          int? coloDB = task.color;

                          return Padding(

                            // Spacing between elements:
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),

                            child: Container(
                                //color: Color(coloDB!),
                              // color: index.isEven
                              //     ? Colors.amberAccent
                              //     : Colors.blueAccent,
                                child: InkWell(
                                  child: taskView(task),
                                  onTap: () {
                                    showBottomSheet(context, task);
                                  },
                                )

                              ),
                            );
                        }

                    );
                  })

              ),

            ],
          );
        });
  }
  scrollList() {
    return Container(
        margin: EdgeInsets.only(bottom: 500, left: 20),
        child: Scrollbar(
          // This vertical scroll view has primary set to true, so it is
          // using the PrimaryScrollController. On mobile platforms, the
          // PrimaryScrollController automatically attaches to vertical
          // ScrollViews, unlike on Desktop platforms, where the primary
          // parameter is required.
          //thumbVisibility: true,
          thickness: 10,
          child: ListView.builder(
              primary: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  // Spacing between elements:
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Container(
                        height: 100,
                        //padding: const EdgeInsets.all(2),

                        color: index.isEven
                            ? Colors.amberAccent
                            : Colors.blueAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Random task $index'),
                        )
                    ));

              }),
        )
    );
  }
  addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       DateFormat.yMMMMd().format(DateTime.now()),
          //       style: subHeadingTextStyle,
          //     ),
          //     const SizedBox(height: 10,),
          //     Text(
          //       "Upcoming Tasks",
          //       style: headingTextStyle,
          //     ),
          //   ],
          // ),
          Text(
            "Upcoming Tasks",
            style: headingTextStyle,
          ),
          Text(
            DateFormat.yMMMMd().format(DateTime.now()),
            style: subHeadingTextStyle,
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

          // Container(
          //   height: 37.0,
          //   width: 40.0,
          //   color: Colors.orange[700],
          //   child: TextButton(
          //     child: const Icon(Icons.refresh, color: Colors.white,),
          //     onPressed: () {
          //       build(context);
          //     },
          //   ),
          // ),

          // Add task button
          ElevatedButton(
            child: Text('+ Add Task',),

            onPressed:  () async {
                //await Get.to(addTask());
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => addTask()),
                // );


              if(isGroupAdmin) {
                if(!await _groupController.isUserAdmin(uID!))
                {
                  showNotAdminUser(context);
                }
                else
                {
                  await Get.to(addTask());
                  _taskController.getTasks(groupID);
                  //_taskController = Get.put(taskController());
                }
              }
              else
                {
                  await Get.to(addTask());
                  _taskController.getTasks(groupID);
                }
              // check if the current user is an admin user
              // if(!await _groupController.isUserAdmin(uID!))
              //   {
              //     showNotAdminUser(context);
              //   }
              // else
              // {
              //   await Get.to(addTask());
              //   _taskController.getTasks(groupID);
              //   //_taskController = Get.put(taskController());
              // }
              },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange[700]!),
            ),
          ),
        ],
      ),
    );
  }
  Widget VoteTaskInfo(){
    // You are the creator of this payment and thus cannot settle it.
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),


    );
  }

  /// Shows the options when a task is clicked on.
  showBottomSheet(BuildContext context, TaskObject task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? _mediaQueryData.size.height * 0.32
            : _mediaQueryData.size.height * 0.32,
        width: _mediaQueryData.size.width,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(children: [
          Container(
            height: 9,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          const Spacer(),
          task.isCompleted == 1
              ? _buildBottomSheetButton(
              label: "Vote task",
              onTap: () async {
                await createVoting(context);
// showDialog(context: context, builder: (context){
//
// });
              },
              clr: Colors.yellow[300])
              : _buildBottomSheetButton(
              label: "Task Completed",
              onTap: () async {
                if(isGroupAdmin)
                  {
                    if(await _groupController.isUserAdmin(uID!))
                    {
                      _taskController.markTaskCompleted(groupID, task.id);
                      Get.back();
                    }
                    else
                    {
                      Get.back();
                      Get.snackbar("Not Admin!", "Not an admin user, cannot mark tasks as complete");
                    }
                  }
                else
                  {
                    _taskController.markTaskCompleted(groupID, task.id);
                    Get.back();
                  }
                // if(await _groupController.isUserAdmin(uID!))
                //   {
                //     _taskController.markTaskCompleted(groupID, task.id);
                //   }
                // else
                //   {
                //     Get.back();
                //     Get.snackbar("Not Admin!", "Not an admin user, cannot mark tasks as complete");
                //   }
              },
              clr: primaryClr),
          _buildBottomSheetButton(
              label: "Delete Task",
              onTap: () async {

                if(isGroupAdmin)
                  {
                    if(await _groupController.isUserAdmin(uID!))
                    {
                      _taskController.deleteTask(groupID, task);
                      Get.back();
                    }
                    else
                    {
                      Get.back();
                      Get.snackbar("Not Admin!", "Not an admin user, cannot delete tasks");
                    }
                  }
                else
                  {
                    _taskController.deleteTask(groupID, task);
                    Get.back();
                  }
                // if(await _groupController.isUserAdmin(uID!))
                // {
                //   _taskController.deleteTask(groupID, task);
                //   Get.back();
                // }
                // else
                // {
                //   Get.back();
                //   Get.snackbar("Not Admin!", "Not an admin user, cannot delete tasks");
                // }
              },
              clr: Colors.red[300]),
          const SizedBox(
            height: 20,
          ),
          _buildBottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  showNotAdminUser (BuildContext context)
  {
    Widget cancelButton = TextButton(
      child: const Text("Okay"),
      onPressed:  () {
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

  showNotAdminUserComplete (BuildContext context)
  {
    Widget cancelButton = TextButton(
      child: const Text("Okay"),
      onPressed:  () {
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

  _buildBottomSheetButton(
      {required String label, Function? onTap, Color? clr, bool isClose = false}) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: _mediaQueryData.size.width * 0.9,
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
  Future<void> createVoting(BuildContext context) async {

    return await showDialog(context: context, builder: (context) {


      return StatefulBuilder(builder: (context, setState) {

        return AlertDialog(
          // Rounding corners of the dialogue.
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),

          title: const Text("Add New Payment"),
          content: SingleChildScrollView(
            child: Column(
                children:[
                  TextFormField(
                    // controller: _newPaymentTitleController,
                    decoration: const InputDecoration(
                        hintText: "Enter payment title"),
                  ),
              ]

            )
          ),


          actions: <Widget>[
            TextButton(
              child: const Text("Okay"),
              onPressed: () {


              },
            ),
          ],
        );

      });

    });
  }

}