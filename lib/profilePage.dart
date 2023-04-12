
import 'package:flutter/material.dart';

class profilePage extends StatefulWidget {
  profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePage();
}

class _profilePage extends State<profilePage> {
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
          child: Text('Profile Page',
            style: optionStyle,),
        ),

      ),

    );
  }
}