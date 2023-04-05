import 'package:flutter/material.dart';

class notificationPage extends StatefulWidget {
  notificationPage({Key? key}) : super(key: key);

  @override
  State<notificationPage> createState() => _notificationPage();
}

class _notificationPage extends State<notificationPage> {
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
          child: Text('Notification Page',
            style: optionStyle,),
        ),
      ),
    );
  }
}