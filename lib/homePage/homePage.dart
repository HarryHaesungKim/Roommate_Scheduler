
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/Group/groupController.dart';
import 'package:roommates/Task/taskController.dart';
import 'package:roommates/groceriesPage/groceriesView.dart';
import 'package:roommates/homePage/addTask.dart';
import 'package:roommates/homePage/GroupChatsListPage.dart';
import 'package:roommates/theme.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:roommates/homePage/VotingPage.dart';
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

  /// The top of the widget that shows the date, 'Upcoming Tasks', and the 'Add task' button.
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
          // ElevatedButton(
          //   onPressed:  () async {
          //       // await Get.to(addTask());
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => addTask()),
          //       );
          //     // await Get.to(addTask());
          //     // taskCon.getTasks(currGroup);
          //     Get.lazyPut(()=>taskController());
          //     },
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all<Color>(Colors.orange[700]!),
          //   ),
          //   child: const Text('+ Add Task',),
          // ),
        ],
      ),
    );
  }

  /// Shows the options when a task is clicked on.
  showBottomSheet(BuildContext context, TaskObject task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? _mediaQueryData.size.height * 0.24
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
          const Spacer(),
          task.isCompleted == 1
              ? Container()
              : _buildBottomSheetButton(
              label: "Task Completed",
              onTap: () {
                taskCon.markTaskCompleted(currGroup, task.id);
                Get.back();
              },
              clr: primaryClr),
          //Have a issue what happens if task is not completed, but user votes.
          _buildBottomSheetButton(
              label: "Voting Task",
              onTap: () {
             //  Get.to(VotingPage());
              },
              clr: Colors.yellow[300]),
          _buildBottomSheetButton(
              label: "Delete Task",
              onTap: () {
                taskCon.deleteTask(currGroup, task);
                Get.back();
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

}