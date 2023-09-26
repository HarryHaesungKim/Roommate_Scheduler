import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/calendarPage/addEvent.dart';
import 'package:roommates/calendarPage/eventView.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:roommates/calendarPage/event.dart';
import '../Group/groupController.dart';
import '../theme.dart';
import 'eventController.dart';
import 'package:intl/intl.dart';

// Used this guide: https://pub.dev/documentation/table_calendar/latest/
// Use for implementing events: https://www.youtube.com/watch?v=ASCs_g8RJ9s&ab_channel=AIwithFlutter

class calendarPage extends StatefulWidget {
  calendarPage({Key? key}) : super(key: key);

  @override
  State<calendarPage> createState() => _calendarPage();
}

class _calendarPage extends State<calendarPage> {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calendar",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          title: const Text("Calendar"),
        ),

        body: const Center(
            child: MyStatefulWidget()
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime now = DateTime.now();
  late DateTime _focusedDay = DateTime(now.year, now.month, now.day);
  DateTime? _selectedDay;
  String? selectedDayString;

  // For Events
  // Map<DateTime, List<Event>> events = {};
  // final TextEditingController _eventController = TextEditingController();
  final _eventController = Get.put(eventController());
  static late MediaQueryData _mediaQueryData;
  late final ValueNotifier<List<Event>> _selectedEvents;
  final _groupController = Get.put(groupController());
  String? uID = FirebaseAuth.instance.currentUser?.uid;


  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    //_selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    selectedDayString = DateFormat('M/dd/yyyy').format(_selectedDay!);
  }

  @override
  void dispose() {
    //_selectedEvents.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // This is where the calendar will go.
    String groupID = _groupController.getGroupIDFromUser(uID!).toString();
    _eventController.getEvents(groupID);
    _mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      // Button to add event (should be replaced to get tasks info from database).
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange[700],
          onPressed: () async {
        // show a dialog for user to input event name
        // showDialog(context: context, builder: (context) {
        //   return AlertDialog(
        //     scrollable: true,
        //     title: const Text("Event Name"),
        //     content: Padding(
        //       padding: EdgeInsets.all(8),
        //       child: TextField(
        //         controller: _eventController,
        //       )
        //     ),
        //     actions: [
        //       ElevatedButton(
        //         onPressed: () async{
        //           Store the event name into the map
        //           if (events.containsKey(_selectedDay)) {
        //             events[_selectedDay]?.add(Event(_eventController.text));
        //           }
        //           else{
        //             events.addAll({
        //               _selectedDay!: [Event(_eventController.text)]
        //               //_selectedDay!: [Event("hahahoohee")]
        //             });
        //           }
        //           Navigator.of(context).pop();
        //           _selectedEvents.value = _getEventsForDay(_selectedDay!);
        //
        //           // Need to reload the calendar.
        //           setState(() {});
        //
        //         },
        //         child: const Text("Submit"),
        //       )
        //     ],
        //   );
        //
        // });
        await Get.to(addEvent());
        _eventController.getEvents(groupID);
      },child: const Icon(Icons.add)),

      body: Column(
        children: [

          // Calendar Child
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

          ),

          // Spacer
          const SizedBox(height: 8.0),

          Expanded(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints){
                    return Column(
                      children:[
                        SizedBox(
                            width: constraints.maxWidth - constraints.maxWidth * 0.05,
                            height: constraints.maxHeight - constraints.maxHeight * 0.2,
                            child: Obx(() {
                              //thumbVisibility: true,
                              //thickness: 10,
                              return ListView.builder(
                                  primary: true,
                                  itemCount: _eventController.eventsMap[selectedDayString]?.length ?? 0,
                                  itemBuilder: (BuildContext context, int index) {
                                    //Event event = _eventController.eventList[index]
                                    // print("_eventController.eventsMap[_focusedDay]?.length");
                                    print(_eventController.eventsMap[selectedDayString]?.length);
                                    print(_eventController.eventList[2].date);
                                    int temp = _eventController.eventsMap[selectedDayString]![index];
                                    Event event = _eventController.eventList[temp];
                                    var title = event.title;
                                    return Padding(
                                      // Spacing between elements:
                                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),

                                      child: Container(
                                          child: InkWell(
                                            child:
                                            eventView(event),
                                            onTap: () {
                                              showBottomSheet(context, event);
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
                  }
              ),
          )


          //List view of events.
          // Expanded(
          //   child: ValueListenableBuilder<List<Event>>(
          //       valueListenable: _selectedEvents,
          //       builder: (context, value, _){
          //         return ListView.builder(
          //             itemCount: value.length,
          //             itemBuilder: (context, index) {
          //               return Container(
          //                 margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          //                 decoration: BoxDecoration(
          //                   border: Border.all(),
          //                   borderRadius:  BorderRadius.circular(12),
          //                 ),
          //                 child: ListTile(
          //                     onTap: () => print(''),
          //
          //                     // Print the values of an event type here.
          //                     title: Text(value[index].title.toString())
          //                 ),
          //               );
          //             });
          //           }),
          // )
        ],
      ),
    );
  }

  // List<Event> _getEventsForDay(DateTime day) {
  //   //retrieve all event from the selected day that pass in as the parameter.
  //   return events[day] ?? [];
  // }
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        selectedDayString = DateFormat('M/d/yyyy').format(_selectedDay!);
       //_selectedEvents.value = _getEventsForDay(selectedDay!);
      });
    }
  }
  showBottomSheet(BuildContext context,  Event event) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
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
              onTap: () {
                String groupID = _groupController.getGroupIDFromUser(uID!).toString();
                _eventController.deleteEvent(groupID, event);
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
class MyStatefulWidget2 extends StatefulWidget {
  const MyStatefulWidget2({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState2();
}
class _MyStatefulWidgetState2 extends State<MyStatefulWidget> {
  final ScrollController _firstController = ScrollController();
  final _eventController = Get.put(eventController());
  static late MediaQueryData _mediaQueryData;
  final _groupController = Get.put(groupController());
  String? uID = FirebaseAuth.instance.currentUser?.uid;


  @override
  Widget build(BuildContext context) {
    String groupID = _groupController.getGroupIDFromUser(uID!).toString();
    _eventController.getEvents(groupID);
    _mediaQueryData = MediaQuery.of(context);
    print( _eventController.eventList.length);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children:[
              SizedBox(
                  width: constraints.maxWidth - constraints.maxWidth * 0.05,
                  height: constraints.maxHeight - constraints.maxHeight * 0.2,
                  child: Obx(() {
                    //thumbVisibility: true,
                    //thickness: 10,
                    return ListView.builder(
                        primary: true,
                        itemCount: _eventController.eventList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Event event = _eventController.eventList[index];
                          var title = event.title;

                          return Padding(

                            // Spacing between elements:
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),

                            child: Container(
                              //color: Color(coloDB!),
                              // color: index.isEven
                              //     ? Colors.amberAccent
                              //     : Colors.blueAccent,
                                child: InkWell(
                                  child:
                                  eventView(event),
                                  onTap: () {
                                    showBottomSheet(context, event);
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
  showBottomSheet(BuildContext context,  Event event) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        // height: groceries.isCompleted == 1
        //     ? _mediaQueryData.size.height * 0.24
        //     : _mediaQueryData.size.height * 0.32,
        height: _mediaQueryData.size.height * 0.32,
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
          _buildBottomSheetButton(
              label: "Delete Task",
              onTap: () {
                String groupID = _groupController.getGroupIDFromUser(uID!).toString();
                _eventController.deleteEvent(groupID,event);
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
