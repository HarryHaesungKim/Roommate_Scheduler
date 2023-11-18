import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roommates/calendarPage/event.dart';
import 'package:roommates/calendarPage/eventController.dart';

import '../Group/groupController.dart';
import '../Notifications/NotificationController.dart';
import '../Task/database_demo.dart';
import '../Task/input_field.dart';
import '../themeData.dart';

class addEvent extends StatefulWidget {
  const addEvent({super.key});

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<addEvent> {
  final eventController _eventController = Get.find<eventController>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _groupController = Get.put(groupController());
  String? uID = FirebaseAuth.instance.currentUser?.uid;

  final _db = Get.put(DBHelper());

  DateTime _selectedDate = DateTime.now();
  String? _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  final DateFormat formatter = DateFormat('MM/dd/yyyy');
  String? _endTime = "9:30 AM";

  // Controller
  final NotificationController notifCon = NotificationController();

  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> setAssignees() async {
    return await _groupController.getUsersInGroup(uID!);
  }

  @override
  Widget build(BuildContext context) {
    //Below shows the time like Sep 15, 2021
    //print(new DateFormat.yMMMd().format(new DateTime.now()));
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, now.minute, now.second);
    final format = DateFormat.jm();
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('Users').doc(uID).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.data}');
          }
          else if (snapshot.hasData) {
            final UserData = snapshot.data!;
            return Scaffold(
              //backgroundColor: context.theme.backgroundColor,
              appBar: AppBar(
                backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                title: const Text("Add Event"),
              ),
              backgroundColor: const Color.fromARGB(255, 227, 227, 227),
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
                          hint: "Enter Description here.",
                          controller: _noteController),
                      InputField(
                        title: "Date",
                        // hint: DateFormat.yMd().format(_selectedDate),
                        hint: formatter.format(_selectedDate),
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
                      const SizedBox(
                        height: 18.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _validateInputs();

                              // Adding a notification of event creation.
                              String notifTitle =
                                  "New Event: ${_titleController.text}";
                              String notifBody =
                                  "Event Description: ${_noteController.text}\nEvent Date: ${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}";
                              notifCon.createNotification(
                                  title: notifTitle,
                                  body: notifBody,
                                  type: "event");
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  setAppBarColor(UserData['themeColor'], UserData['themeBrightness'])!),
                            ),
                            child: const Text('Create Event'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  _validateInputs() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addEventToDB();
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

  _addEventToDB() async {
    String groupID = await _groupController.getGroupIDFromUser(uID!);
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    await _eventController.addEvent(
      groupID,
      event: Event(
        title: _titleController.text.toString(),
        note: _noteController.text.toString(),
        date: formatter.format(_selectedDate),
      ),
    );
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    print(pickedTime.format(context));
    String? formatedTime = pickedTime.format(context);
    print(formatedTime);
    if (pickedTime == null) {
      print("time canceld");
    } else if (isStartTime)
      setState(() {
        _startTime = formatedTime;
      });
    else if (!isStartTime) {
      setState(() {
        _endTime = formatedTime;
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
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
