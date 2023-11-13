import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:roommates/CostSplit/CostSplitView.dart';
import 'package:roommates/LoginPage.dart';
import 'package:roommates/mainPage.dart';
import 'package:roommates/sign.dart';
import 'package:get/get.dart';
import 'package:roommates/registrationPageCreatGroup.dart';
//@dart = 2.9
import 'Task/database_demo.dart';
// import 'strings.dart'

import 'package:firebase_analytics/firebase_analytics.dart';

import 'api/firebase_api.dart';

// Key to take users to a specific page when opening push notification.
final navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await DBHelper.initDb();
  await GetStorage.init();
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print(fcmToken);

  // initialize push notification stuff
  // await FirebaseApi().initNotifications();
  // await FirebaseApi().initPushNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key:key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(

      // Key to take users to a specific page when opening push notification.
      navigatorKey: navigatorKey,

      home : const sign(),

      // routes user to a specific screen when clicking on notification
      routes: {
        '/home_screen':(context) => const mainPage(navigateToScreen: 0,),
        '/calendar_screen':(context) => const mainPage(navigateToScreen: 1,),
        '/costSplit_screen':(context) => const mainPage(navigateToScreen: 2,),

        // More routes for new message, new group members(?), etc.

      },
    );
  }
}

