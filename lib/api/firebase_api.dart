import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:roommates/Group/groupController.dart';
import 'package:roommates/main.dart';
import 'package:http/http.dart' as http;

//https://www.youtube.com/watch?v=A3M0N_B-CR0&t=220s
//https://firebase.google.com/codelabs/firebase-fcm-flutter#0
//https://www.youtube.com/watch?v=uQs-SnlEUnY&t=172s

class FirebaseApi{
  // create an instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // The current user. Used to get UID and checking to see if a user is logged in.
  final User? user = FirebaseAuth.instance.currentUser;
  final uID = FirebaseAuth.instance.currentUser?.uid;

  // The FCM token
  late String fCMToken = "";

  /// function to initialize notifications
  Future<void> initNotifications() async {

    // Request permission from user (will prompt user).
    await _firebaseMessaging.requestPermission();

    // Fetch the FCM token for this device.
    fCMToken = (await _firebaseMessaging.getToken())!;

    // Send the device token to firebase.
    FirebaseFirestore.instance.collection('Users').doc(uID).update({'DeviceToken': fCMToken});

    // For testing.
    print("Token: $fCMToken");

    // Initialize the push notifications and the listeners.
    initPushNotifications();
  }

  /// function to initialize background settings
  Future initPushNotifications() async {
    // handle notification if the app was terminated and now opened.
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // attach event listeners for when a notification opens the app.
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// function is used to handle background messages?
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message");
  }

  /// function to handle received messages
  void handleMessage(RemoteMessage? message) async {

    // If the message is null, do nothing.
    if (message == null) return;

    // Proceed only if the user is signed in.
    if(user != null) {

      // For testing.
      // print(message.notification!.title.toString());

      // We can customize where opening the app will take us by reading the notification's title or body.
      // A few examples below.
      if (message.notification!.title.toString() == 'New event created.') {
        navigatorKey.currentState?.pushNamed(
          '/calendar_screen',
          arguments: message,
        );
      }
      else if (message.notification!.title.toString() == 'New payment created.') {
        navigatorKey.currentState?.pushNamed(
          '/costSplit_screen',
          arguments: message,
        );
      }
      else {
        navigatorKey.currentState?.pushNamed(
          '/home_screen',
          arguments: message,
        );
      }
    }
  }

  /// This method sends notifications to every group member.
  void sendPushNotification(String title, String body) async {

    // Get list of IDs of people in group.
    List<String> groupMembers = await groupController().getUserIDsInGroup(uID!);

    // Get all device tokens of each group member.
    List<String> groupMembersDeviceTokens = [];
    for(var member in groupMembers){
      groupMembersDeviceTokens.add(await getDeviceToken(member));
    }

    // Send notification to every user.
    for(var token in groupMembersDeviceTokens){
      try {
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAR2KvSuY:APA91bFIj0j8FbCO93rT-uCbxpFR6wL7rr3SMpYQIs-0G30B7Lzkg8_RXBr2Q6Sa8J21VMvHiQwE-Xngx7I7KKmdvNC6ja0eqPGPZzQmVbn5Gp_LTAuZ9SzW6alqOzbPOSyDiy555eBH',
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            // "notification": <String, dynamic>{
            //   "title": title,
            //   "body": body,
            //   "android_channel_id": "roommates"
            // },
            "to": token,
          }),
        );
      } catch (e) {
        if (kDebugMode) {
          print("Error push notification.");
        }
      }
    }
  }

  /// This method returns the user's device token given their user ID.
  Future<String> getDeviceToken(uID) async {
    final userRef = await FirebaseFirestore.instance.collection('Users').doc(uID).get();
    final devToken = userRef.data()?['DeviceToken'];
    return devToken;
  }
}