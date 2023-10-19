import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themeData.dart';

class HelpMenuPage extends StatefulWidget {
  const HelpMenuPage({Key? key}) : super(key: key);

  @override
  State<HelpMenuPage> createState() => _HelpMenuPage();
}
class _HelpMenuPage extends State<HelpMenuPage> {
  String themeBrightness = "";
  String themeColor = "";
  void getUserData() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if(user !=null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();
      Map<String, dynamic> list = db.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          themeBrightness = list['themeBrightness'];
          themeColor = list['themeColor'];
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    getUserData();
    return MaterialApp(
      theme: showOption(themeBrightness), 
      home: Scaffold(
      appBar: AppBar(
        backgroundColor: setAppBarColor(themeColor, themeBrightness),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: setBackGroundBarColor(themeBrightness)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Help"),
      ),
    body: ListView(
      padding: EdgeInsets.all(20),
      children: [
        Text("Welcome to the Help Menu! If you need assistance with our app, we're here to help! Below are some common topics to help you get started.",
          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),)
      ],
    )
      )
    );
  }

}