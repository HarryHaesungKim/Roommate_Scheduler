import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpMenuPage extends StatefulWidget {
  const HelpMenuPage({Key? key}) : super(key: key);

  @override
  State<HelpMenuPage> createState() => _HelpMenuPage();
}
class _HelpMenuPage extends State<HelpMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: const Text("Help"),
      ),
    body: ListView(
      padding: EdgeInsets.all(20),
      children: [
        Text("Welcome to the Help Menu! If you need assistance with our app, we're here to help! Below are some common topics to help you get started.",
          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),)
      ],
    )

    );
  }

}