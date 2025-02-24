import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:roommates/calendarPage/addEvent.dart';
import 'package:roommates/calendarPage/eventView.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:roommates/calendarPage/event.dart';
import '../Group/groupController.dart';
import '../Task/TaskObject.dart';
import '../Task/taskController.dart';
import '../theme.dart';
import '../themeData.dart';
import 'calendar_taskview.dart';
import 'eventController.dart';
import 'package:intl/intl.dart';

// Used this guide: https://pub.dev/documentation/table_calendar/latest/
// Use for implementing events: https://www.youtube.com/watch?v=ASCs_g8RJ9s&ab_channel=AIwithFlutter

class calendarPage extends StatefulWidget {
  const calendarPage({Key? key}) : super(key: key);

  @override
  State<calendarPage> createState() => _calendarPage();
}

class _calendarPage extends State<calendarPage> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime now = DateTime.now();
  late DateTime _focusedDay = DateTime(now.year, now.month, now.day);
  DateTime? _selectedDay;
  String? selectedDayString;
  String groupID = "";
  late Future<String> futureCurrGroup;
  String currGroup = '';
  RxMap<String?, int> eventsCountMap = RxMap<String?,int>();
  List<Object> todo = [];
  final DateFormat formatter = DateFormat('MM/dd/yyyy');
  final taskController taskCon = taskController();
  bool isNothing = true;

  // For Events
  // Map<DateTime, List<Event>> events = {};
  // final TextEditingController _eventController = TextEditingController();
  final _eventController = Get.put(eventController());
  static late MediaQueryData _mediaQueryData;
  late final ValueNotifier<List<Event>> _selectedEvents;
  final _groupController = Get.put(groupController());
  final groupController groupCon = groupController();
  String? uID = FirebaseAuth.instance.currentUser?.uid;
  String? currUser = FirebaseAuth.instance.currentUser?.uid;
  late Future<bool> isGroupAdmin;
  late bool gotIsGroupAdmin;
  Stream<List<Event>> readEvent() {
    return FirebaseFirestore.instance
        .collection('Group')
        .doc(currGroup)
        .collection('Event')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Event.fromJson(doc.data()))
        .toList());
  }
  Stream<List<TaskObject>> readTasks() {
    return FirebaseFirestore.instance
        .collection('Group')
        .doc(currGroup)
        .collection('tasks')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TaskObject.fromJson(doc.data()))
        .toList());// .where("date", isEqualTo: today)
  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> readUser() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currUser)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    //_selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    selectedDayString = DateFormat('M/dd/yyyy').format(_selectedDay!);
    futureCurrGroup = groupCon.getGroupIDFromUser(currUser!);
    isGroupAdmin = groupCon.isGroupAdminModeByID(currUser!);
  }

  @override
  void dispose() {
    //_selectedEvents.dispose();
    super.dispose();
  }

  // void setGroupID() async {
  //   groupID = await _groupController.getGroupIDFromUser(uID!);
  //   isGroupAdmin = await _groupController.isGroupAdminMode(groupID);
  // }
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        selectedDayString = DateFormat('MM/dd/yyyy').format(_selectedDay!);
        //_selectedEvents.value = _getEventsForDay(selectedDay!);
      });
    }
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
      content: const Text("You are not an admin user, cannot create events!"),
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
  showBottomSheet(BuildContext context, Event event) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        // height: groceries.isCompleted == 1
        //     ? _mediaQueryData.size.height * 0.24
        //     : _mediaQueryData.size.height * 0.32,
        height: _mediaQueryData.size.height * 0.2,
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
          _buildBottomSheetButton(
              label: "Delete Event",
              onTap: () async {
                if (gotIsGroupAdmin) {
                  if (await groupCon.isUserAdmin(currUser!)) {
                    _eventController.deleteEvent(currGroup, event);
                Get.back();
                } else {
                Get.back();
                Get.snackbar(
                "Not Admin!", "Not an admin user, cannot delete events");
                }
                } else {
                  _eventController.deleteEvent(currGroup, event);
                  Get.back();
                }
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
  showBottomSheet_task(BuildContext context, TaskObject task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: _mediaQueryData.size.height * 0.2,
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
      {required String label,
        Function? onTap,
        Color? clr,
        bool isClose = false}) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: _mediaQueryData.size.width* 0.9,
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

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    return FutureBuilder(
        future: Future.wait([futureCurrGroup, isGroupAdmin]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if (snapshot.hasData){
            currGroup = snapshot.data[0];
            gotIsGroupAdmin = snapshot.data[1];
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(currUser)
                    .snapshots(),
                builder: (context, snapshot){
                  if (snapshot.hasError){
                    return Text('Something went wrong! ${snapshot.data}');
                  }
                  else if (snapshot.hasData){
                    return StreamBuilder<List<TaskObject>>(
                        stream: readTasks(),
                        builder: (context, snapshot3){
                          if (snapshot3.hasError) {
                            return Text('Something went wrong! ${snapshot3
                                .data}');
                          }
                          else if (snapshot3.hasData){
                            return StreamBuilder<List<Event>>(
                                stream: readEvent(),
                                builder: (context, snapshot2) {
                                  if (snapshot2.hasError) {
                                    return Text('Something went wrong! ${snapshot2
                                        .data}');
                                  }
                                  else if (snapshot2.hasData) {
                                    final EventData = snapshot2.data!;
                                    final UserData = snapshot.data!;
                                    final TaskData = snapshot3.data!;
                                    eventsCountMap.clear();
                                    todo =  [EventData, TaskData].expand((x) => x).toList();
                                    for(int i = 0; i < todo.length; i++){
                                      if(todo[i].runtimeType == Event){
                                        Event event = todo[i] as Event;
                                        if (eventsCountMap.containsKey(event.date)) {
                                          if(eventsCountMap[event.date] != null){
                                            eventsCountMap[event.date] =eventsCountMap[event.date]! + 1;
                                          }
                                        }
                                        else{
                                          eventsCountMap[event.date] = 1;
                                        }
                                      }
                                      else{
                                        TaskObject task = todo[i] as TaskObject;
                                        if (eventsCountMap.containsKey(task.date)) {
                                          if(eventsCountMap[task.date] != null){
                                            eventsCountMap[task.date] =eventsCountMap[task.date]! + 1;
                                          }
                                        }
                                        else{
                                          eventsCountMap[task.date] = 1;
                                        }
                                      }

                                    }
                                    return MaterialApp(
                                        title: "Calendar",
                                        theme: showOption(UserData['themeBrightness']),
                                        home: Scaffold(
                                          appBar: AppBar(
                                            backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                                            title: const Text("Calendar"),
                                          ),
                                          floatingActionButton: FloatingActionButton(
                                              backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                                              onPressed: () async {
                                                if (await isGroupAdmin) {
                                                  if (!await _groupController.isUserAdmin(uID!)) {
                                                    showNotAdminUser(context);
                                                  } else {
                                                    await Get.to(const addEvent());
                                                    //_eventController.getEvents(groupID);
                                                  }
                                                } else {
                                                  await Get.to(const addEvent());
                                                  //_eventController.getEvents(groupID);
                                                }
                                                // await Get.to(addEvent());
                                                // _eventController.getEvents(groupID);
                                              },
                                              child: const Icon(Icons.add)),
                                          body: Container(
                                            child: Column(
                                              children: [
                                                TableCalendar(
                                                  // firstDay is the first available day for the calendar. Users will not be able to access days before it.
                                                  // lastDay is the last available day for the calendar. Users will not be able to access days after it.
                                                  // focusedDay is the currently targeted day. Use this property to determine which month should be currently visible.
                                                  // firstDay and lastDay can change depending on how far or early we want the user to be able to view the date.
                                                  firstDay: DateTime.utc(2010, 10, 16),
                                                  lastDay: DateTime.utc(2030, 3, 14),
                                                  focusedDay: _focusedDay,
                                                  calendarFormat: _calendarFormat,
                                                  selectedDayPredicate: (day) {
                                                    return isSameDay(_selectedDay, day);
                                                  },
                                                  //eventLoader: _getEventsForDay,
                                                  onDaySelected: _onDaySelected,

                                                  // Change the layout of the calendar.
                                                  // Currently changes from month to 2 weeks to 1 week view. Can change to fit our needs.
                                                  onFormatChanged: (format) {
                                                    if (_calendarFormat != format) {
                                                      // Call `setState()` when updating calendar format
                                                      setState(() {
                                                        _calendarFormat = format;
                                                      });
                                                    }
                                                  },
                                                  // Allows users to keep their selected dates between closing/reopening the app.
                                                  // Currently commented out because I want it to reset to the current date. We can change this if we wanted to.
                                                  onPageChanged: (focusedDay) {
                                                    _focusedDay = focusedDay;
                                                  },
                                                  calendarBuilders: CalendarBuilders(
                                                      markerBuilder: (context, day, events) {
                                                        // String curDay = '${day.month}/${day.day}/${day.year}';
                                                        String curDay = formatter.format(day);
                                                        int countEvent = 0;
                                                        if(eventsCountMap[curDay]==null){
                                                          countEvent = 0;
                                                        }
                                                        else{
                                                          countEvent = eventsCountMap[curDay]!;
                                                          return Container(
                                                            width: 20,
                                                            height: 15,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(4.0),
                                                              color: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                                                            ),
                                                            child: Text(
                                                              '$countEvent',
                                                              style: const TextStyle(color: Colors.white),
                                                            ),
                                                          );
                                                        }
                                                        return null;
                                                      }
                                                  ),
                                                ),
                                                // Spacer
                                                const SizedBox(height: 8.0),
                                                Expanded(
                                                  child: LayoutBuilder(
                                                      builder: (BuildContext context, BoxConstraints constraints) {
                                                        String curDay = formatter.format(_selectedDay!);
                                                        if(eventsCountMap[curDay] == null){
                                                          return Flex(
                                                            direction: Axis.horizontal,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Text("No entries.",
                                                                style: headingTextStyle,),
                                                            ],
                                                          );
                                                        }
                                                        return Column(
                                                          children: [
                                                            SizedBox(
                                                              width: constraints.maxWidth - constraints.maxWidth * 0.05,
                                                              height:
                                                              constraints.maxHeight,
                                                              //thumbVisibility: true,
                                                              //thickness: 10,
                                                              child: ListView.builder(
                                                                  primary: true,
                                                                  itemCount: todo.length,
                                                                  itemBuilder: (BuildContext context, int index) {
                                                                    if(todo[index].runtimeType == Event){
                                                                      Event event = todo[index] as Event;
                                                                      if(event.date == selectedDayString){
                                                                        return Padding(
                                                                          // Spacing between elements:
                                                                          padding:
                                                                          const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                                          child: InkWell(
                                                                            child: eventView(event),
                                                                            onTap: () {
                                                                              showBottomSheet(context, event);
                                                                            },
                                                                          ),
                                                                        );
                                                                      }
                                                                      else{
                                                                        return const Padding(
                                                                          // Spacing between elements:
                                                                          padding:
                                                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                        );
                                                                      }
                                                                    }
                                                                    else {
                                                                      TaskObject task = todo[index] as TaskObject;
                                                                      if(task.date == selectedDayString){

                                                                        return Padding(
                                                                          // Spacing between elements:
                                                                          padding:
                                                                          const EdgeInsets.fromLTRB(10, 5, 10, 5),

                                                                          child: InkWell(
                                                                            child: calendar_taskView(task),
                                                                            onTap: () {
                                                                              showBottomSheet_task(context, task);
                                                                            },
                                                                          ),
                                                                        );
                                                                      }
                                                                      else{
                                                                        return const Padding(
                                                                          // Spacing between elements:
                                                                          padding:
                                                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                        );
                                                                      }

                                                                    }
                                                                  }
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                }
                            );
                          }
                          else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                    );
                  }
                  else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                }
            );
          }
          else if (snapshot.hasError){
            return Text("Something went wrong! ${snapshot.error}");
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}