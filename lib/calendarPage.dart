import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Used this guide: https://pub.dev/documentation/table_calendar/latest/

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
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    // This is where the calendar will go.

    return Scaffold(
      body: TableCalendar(

        // firstDay is the first available day for the calendar. Users will not be able to access days before it.
        // lastDay is the last available day for the calendar. Users will not be able to access days after it.
        // focusedDay is the currently targeted day. Use this property to determine which month should be currently visible.
        // firstDay and lastDay can change depending on how far or early we want the user to be able to view the date.

        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,

        // Being able to select what day to focus on.
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });
        },

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
/*        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },*/

      // TODO: Need to implement events to calendar.

      ),

    );

    // throw UnimplementedError();
  }
  
}
