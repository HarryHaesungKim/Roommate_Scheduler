
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

import '../Task/task.dart';
import '../Task/taskView.dart';

class homePage extends StatefulWidget {
  homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePage();
}

class _homePage extends State<homePage> {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  @override
  void initState() {
    super.initState();
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
    getUserData();
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
                    child: Icon(
                        Icons.send
                    ),
                  )
              ),
            ],

        ),

        body: const Center(
          child: MyStatefulWidget()
        ),
      ),
    );
  }
}

// Copy and pasted code from https://api.flutter.dev/flutter/material/Scrollbar-class.html
// Slightly modified.

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

  void setGroupID() async {
    groupID = await _groupController.getGroupIDFromUser(uID!);
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
              SizedBox(height: 10,),
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
            color: Colors.orange[700],
            child: TextButton(
              child: Icon(Icons.refresh, color: Colors.white,),
              onPressed: () {
                build(context);
              },
            ),
          ),

          // Add task button
          ElevatedButton(
            child: Text('+ Add Task',),

            onPressed:  () async {
                //await Get.to(addTask());
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => addTask()),
                // );
              await Get.to(addTask());
              _taskController.getTasks(groupID);
              //_taskController = Get.put(taskController());
              },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange[700]!),
            ),
          ),
        ],
      ),
    );
  }
  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
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
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _buildBottomSheetButton(
              label: "Task Completed",
              onTap: () {
                _taskController.markTaskCompleted(groupID, task.id);
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
                _taskController.deleteTask(groupID, task);
                Get.back();
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
      {required String label, Function? onTap, Color? clr, bool isClose = false}) {
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
}