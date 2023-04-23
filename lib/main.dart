import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:roommates/LoginPage.dart';
import 'package:roommates/sign.dart';
import 'package:get/get.dart';
import 'package:roommates/registrationPage.dart';

import 'Task/database_demo.dart';
// import 'strings.dart'

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key:key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      home : sign(),
    );
  }
}

