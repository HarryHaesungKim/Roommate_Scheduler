
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'NotificationObject.dart';

class NotificationController {

  // Current user information.
  String userName = "";
  String email = "";
  String groupID = "";

  // Gets the data of the current user.
  Future<void> getUserData() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if(user !=null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();

      Map<String, dynamic> list = db.data() as Map<String, dynamic>;

      userName = list['UserName'];
      email = list['Email'];
      groupID = list['groupID'];

    }
  }

  // Creates the notification object and sends it to firebase.
  Future createNotification({required String title, required String body, required type}) async {

    // Getting the User Data.
    getUserData();

    // Reference to Document.
    final notification = FirebaseFirestore.instance.collection('Notifications').doc();

    final announcement = NotificationObject(
      id: notification.id,
      title: title,
      body: body,
      time: DateTime.now(),
      type: type,
      groupID: groupID,
      creator: userName,
    );

    // Create document and write data to firebase.
    await notification.set(announcement.toJson());
  }

}
