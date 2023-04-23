import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 227, 227, 227),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text('Calendar Page',
            style: optionStyle,),
        ),
      ),
    );
  }
}
