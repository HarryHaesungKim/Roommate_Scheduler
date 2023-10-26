import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roommates/Group/groupController.dart';
import 'package:roommates/themeData.dart';

import '../Notifications/NotificationController.dart';
import '../Task/database_demo.dart';
import '../Task/input_field.dart';
import '../Task/TaskObject.dart';
import '../Task/taskController.dart';
import '../User/user_controller.dart';
import '../theme.dart';

class addTask extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<addTask> {
  final taskController _taskController = Get.find<taskController>();
  final groupController _groupController = Get.put(groupController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? uID = FirebaseAuth.instance.currentUser?.uid;
  late Future<String> futureCurrGroup;
  late String groupID = "";
  late Future<List<String>> FutureAssigneeList;
  late List<String> assigneeList;
 late String themeColor;
  late String themeBrightness;
  late Future<String> futureThemeColor;
  late Future<String> futureThemeBrightness;
  final _db = Get.put(DBHelper());
  final userController userCon = userController();
  DateTime _selectedDate = DateTime.now();
  String? _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();

  String? _endTime = "9:30 AM";
  int _selectedColor = 0;

  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  String _selectedAssigness = "None";
  List<String> AssigneesList = [];

  String? _selectedRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',
  ];

  // Controller
  final NotificationController notifCon = NotificationController();

  ///
  /// This method sets the groupID to the logged in users groupID
  ///
  void setGroupID() async {
    groupID = await _groupController.getGroupIDFromUser(uID!);
    print("groupID in setgroupID" + groupID);
  }



  @override
  void initState() {
    super.initState();
    futureCurrGroup =  _groupController.getGroupIDFromUser(uID!);
    FutureAssigneeList = _groupController.getUsersInGroup(uID!);
    futureThemeBrightness = userCon.getUserThemeBrightness(uID!);
    futureThemeColor = userCon.getUserThemeColor(uID!);
  }

  @override
  Widget build(BuildContext context) {
    //Below shows the time like Sep 15, 2021
    //print(new DateFormat.yMMMd().format(new DateTime.now()));
    print(" starttime " + _startTime!);
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, now.minute, now.second);
    final format = DateFormat.jm();

    print(format.format(dt));
    print("add Task date: " + DateFormat.yMd().format(_selectedDate));
    print("List of assignees" + AssigneesList.toString());
    print("user id " + uID.toString());
    return FutureBuilder(
        future: Future.wait([FutureAssigneeList,futureThemeBrightness,futureThemeColor,futureCurrGroup]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) return Container();
             assigneeList = snapshot.data[0];
             themeBrightness = snapshot.data[1];
             themeColor = snapshot.data[2];
             groupID = snapshot.data[3];
          return Scaffold(
            //backgroundColor: context.theme.backgroundColor,
            appBar: AppBar(
              backgroundColor: setAppBarColor(themeColor, themeBrightness),
              title: const Text("Add Task"),
            ),
            backgroundColor: Color.fromARGB(255, 227, 227, 227),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      title: "Title",
                      hint: "Enter title here.",
                      controller: _titleController,
                    ),
                    InputField(
                        title: "Description",
                        hint: "Enter description here.",
                        controller: _noteController),
                    InputField(
                      title: "Date",
                      hint: DateFormat.yMd().format(_selectedDate),
                      widget: IconButton(
                        icon: (const Icon(
                          Icons.calendar_month_sharp,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          //_showDatePicker(context);
                          _getDateFromUser();
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            title: "Start Time",
                            hint: _startTime,
                            widget: IconButton(
                              icon: (Icon(
                                Icons.alarm,
                                color: Colors.grey,
                              )),
                              onPressed: () {
                                _getTimeFromUser(isStartTime: true);
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: InputField(
                            title: "End Time",
                            hint: _endTime,
                            widget: IconButton(
                              icon: (Icon(
                                Icons.alarm,
                                color: Colors.grey,
                              )),
                              onPressed: () {
                                _getTimeFromUser(isStartTime: false);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    InputField(
                      title: "Remind",
                      hint: "$_selectedRemind minutes early",
                      widget: Row(
                        children: [
                          DropdownButton<String>(
                              //value: _selectedRemind.toString(),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              iconSize: 32,
                              elevation: 4,
                              style: subTitleTextStle,
                              underline: Container(height: 0),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedRemind = int.parse(newValue!);
                                });
                              },
                              items: remindList
                                  .map<DropdownMenuItem<String>>((int value) {
                                return DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: Text(value.toString()),
                                );
                              }).toList()),
                          SizedBox(width: 6),
                        ],
                      ),
                    ),
                    InputField(
                      title: "Repeat",
                      hint: _selectedRepeat,
                      widget: Row(
                        children: [
                          Container(
                            child: DropdownButton<String>(
                                dropdownColor: Colors.blueGrey,
                                //value: _selectedRemind.toString(),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                ),
                                iconSize: 32,
                                elevation: 4,
                                style: subTitleTextStle,
                                underline: Container(
                                  height: 6,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedRepeat = newValue;
                                  });
                                },
                                items: repeatList.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList()),
                          ),
                          SizedBox(width: 6),
                        ],
                      ),
                    ),
                    InputField(
                      title: "Assignees",
                      hint: "$_selectedAssigness",
                      widget: Row(
                        children: [
                          DropdownButton<String>(
                              //value: _selectedRemind.toString(),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              iconSize: 32,
                              elevation: 4,
                              style: subTitleTextStle,
                              underline: Container(height: 0),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedAssigness = newValue!;
                                });
                              },
                              items: assigneeList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                print("assingees" + assigneeList.toString());
                                return DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: Text(value.toString()),
                                );
                              }).toList()),
                          SizedBox(width: 6),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _colorChips(),
                        ElevatedButton(
                          child: Text('Create Task'),
                          onPressed: () {
                            _validateInputs();

                            // Adding a notification of task creation.
                            String notifTitle =
                                "New task: ${_titleController.text}";
                            String notifBody =
                                "Task Description: ${_noteController.text}\nTo-do Date: ${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}\nRepeat: $_selectedRepeat\nAssigned to: $_selectedAssigness";
                            notifCon.createNotification(
                                title: notifTitle,
                                body: notifBody,
                                type: "task");
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                setAppBarColor(themeColor, themeBrightness)!),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _validateInputs() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      print("SOMETHING ERROR");
    }
  }

  _addTaskToDB() async {
    String? uID = FirebaseAuth.instance.currentUser?.uid;
    String groupID = await _groupController.getGroupIDFromUser(uID!);

    await _taskController.addTask(
      groupID,
      task: TaskObject(
        id: '',
        note: _noteController.text.toString(),
        title: _titleController.text.toString(),
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
        assignedUserID: uID,
        assignedUserName: _selectedAssigness,
      ),
    );
  }

  _colorChips() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Color",
        style: titleTextStle,
      ),
      SizedBox(
        height: 8,
      ),
      Wrap(
        children: List<Widget>.generate(
          3,
          (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: index == _selectedColor
                      ? Center(
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : Container(),
                ),
              ),
            );
          },
        ).toList(),
      ),
    ]);
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    print(_pickedTime.format(context));
    String? _formatedTime = _pickedTime.format(context);
    print(_formatedTime);
    if (_pickedTime == null)
      print("time canceld");
    else if (isStartTime)
      setState(() {
        _startTime = _formatedTime;
      });
    else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
      //_compareTime();
    }
  }

  _showTimePicker() async {
    return showTimePicker(
      initialTime: TimeOfDay(
          hour: int.parse(_startTime!.split(":")[0]),
          minute: int.parse(_startTime!.split(":")[1].split(" ")[0])),
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
    );
  }

  _getDateFromUser() async {
    final DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    }
  }
}
