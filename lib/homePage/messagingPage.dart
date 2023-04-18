import 'package:flutter/material.dart';

class messagingPage extends StatefulWidget {
  messagingPage({Key? key}) : super(key: key);

  @override
  State<messagingPage> createState() => _messagingPage();
}

// Random comment

class _messagingPage extends State<messagingPage> {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange[700],
          title: const Text("Messaging"),
      ),
      backgroundColor:  Color.fromARGB(255, 227, 227, 227),
      body: const Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text('Messaging Page',
            style: optionStyle,),
        ),
      ),
    );
  }
}