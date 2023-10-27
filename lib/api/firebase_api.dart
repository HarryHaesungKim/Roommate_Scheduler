import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:roommates/main.dart';

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

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    fCMToken = (await _firebaseMessaging.getToken())!;

    print("This is working");

    // print the token (normally you would send this to your server).
    print('Token: $fCMToken');

    // for testing
    //print("uID is: ${uID!}");

    // // Checking if a user is signed in. This works.
    // final User? user = FirebaseAuth.instance.currentUser;
    // if(user != null){
    //   print("Yes");
    // }
    // else{
    //   print("No..");
    // }
    //
    // // send token to firebase
    // // TODO: Need to send to firebase after user signs in.
    // FirebaseFirestore.instance.collection('Users').doc(uID).update({'DeviceToken': fCMToken});

    // // If the user is signed in.
    if(user != null){
      print("Sent from firebase_api.dart");
      sendTokenToFirebase();
    }
    // Else, it gets done when the user signs in.

    // initialize further settings for push notification
    initPushNotifications();
  }

  // function to send token to firebase.
  void sendTokenToFirebase(){
    FirebaseFirestore.instance.collection('Users').doc(uID).update({'DeviceToken': fCMToken});
  }

  // function to handle received messages
  void handleMessage(RemoteMessage? message) {
    // If the message is null, do nothing.
    if (message == null) return;

    // navigate to new screen when message is received and user taps notification
    // navigatorKey.currentState?.pushNamed(
    //     '/costSplit_screen',
    //   arguments: message,
    // );

    if(user != null) {
      print(message.notification!.title.toString());

      //TODO: Check to make sure that user is signed in first?
      // We can customize where opening the app will take us by reading the notification's title or body.
      if (message.notification!.title.toString() == 'New event created.') {
        navigatorKey.currentState?.pushNamed(
          '/calendar_screen',
          arguments: message,
        );
      }
      else
      if (message.notification!.title.toString() == 'New payment created.') {
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

  // function to initialize backgorund settings
  Future initPushNotifications() async {
    // handle notification if the app was terminated and now opened.
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // attach event listeners for when a notification opens the app.
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  // TODO: save the device token to firebase for each user. Probably every time user signs in.
  // TODO: function to be called to send notifications to every group member.
  void sendPushNotification() async {
    // FirebaseMessaging.onBackgroundMessage((message) => null)
  }

  // String getDeviceToken() {
  //   return devi
  // }


}