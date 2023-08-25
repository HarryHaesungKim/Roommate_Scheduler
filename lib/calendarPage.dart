import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'event.dart';

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

  // For Events
  Map<DateTime, List<Event>> events = {};
  final TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This is where the calendar will go.

    return Scaffold(

      // Button to add event (should be replaced to get tasks info from database).
      floatingActionButton: FloatingActionButton(onPressed: (){

        // show a dialog for user to input event name
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: const Text("Event Name"),
            content: Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: _eventController,
              )
            ),
            actions: [
              ElevatedButton(
                onPressed: (){
                  // Store the event name into the map
                  if (events.containsKey(_selectedDay)) {
                    events[_selectedDay]?.add(Event(_eventController.text));
                  }
                  else{
                    events.addAll({
                      _selectedDay!: [Event(_eventController.text)]
                      //_selectedDay!: [Event("hahahoohee")]
                    });
                  }
                  Navigator.of(context).pop();
                  _selectedEvents.value = _getEventsForDay(_selectedDay!);

                  // Need to reload the calendar.
                  setState(() {});
                },
                child: const Text("Submit"),
              )
            ],
          );
        });
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
            eventLoader: _getEventsForDay,
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
/*            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },*/

          ),

          // Spacer
          const SizedBox(height: 8.0),

          // List view of events.
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _){
                  return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius:  BorderRadius.circular(12),
                          ),
                          child: ListTile(
                              onTap: () => print(''),

                              // Print the values of an event type here.
                              title: Text(value[index].title)
                          ),
                        );
                      });
                    }),
          )

        ],
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    //retrieve all event from the selected day that pass in as the parameter.
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay!);
      });
    }
  }
}
