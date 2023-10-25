import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:roommates/main.dart';

//https://www.youtube.com/watch?v=A3M0N_B-CR0&t=220s
//https://firebase.google.com/codelabs/firebase-fcm-flutter#0

class FirebaseApi{
  // create an instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    // print the token (normally you would send this to your server).
    print('Token: $fCMToken');

    // initialize further settings for push notification
    initPushNotifications();
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

    print(message.notification!.title.toString());

    // We can customize where opening the app will take us by reading the notification's title or body.
    if(message.notification!.title.toString() == 'New event created.'){
      navigatorKey.currentState?.pushNamed(
        '/calendarSplit_screen',
        arguments: message,
      );
    }
    else if(message.notification!.title.toString() == 'New payment created.'){
      navigatorKey.currentState?.pushNamed(
        '/costSplit_screen',
        arguments: message,
      );
    }
    else{
      navigatorKey.currentState?.pushNamed(
        '/home_screen',
        arguments: message,
      );
    }
  }

  // function to initialize backgorund settings
  Future initPushNotifications() async {
    // handle notification if the app was terminated and now opened.
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // attach event listeners for when a notification opens the app.
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

}