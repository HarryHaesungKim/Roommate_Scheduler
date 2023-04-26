import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/LoginPage.dart';
class settingsProfile extends StatefulWidget {
  const settingsProfile({Key? key}) : super(key: key);

  @override
  State<settingsProfile> createState() => _settingsProfileState();
}

class _settingsProfileState extends State<settingsProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: const Text("Settings"),
    ),
    );
  }
}
