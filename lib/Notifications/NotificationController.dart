
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'NotificationObject.dart';

class NotificationController {

  // Creates the notification object and sends it to firebase.
  Future createNotification({required String title, required String body, required type, required String groupID, required String email}) async {
    // Reference to Document.
    final notification = FirebaseFirestore.instance.collection('Notifications').doc();

    final announcement = NotificationObject(
      id: notification.id,
      title: title,
      body: body,
      time: DateTime.now(),
      type: type,
      groupID: groupID,
      creator: email,
    );

    // Create document and write data to firebase.
    await notification.set(announcement.toJson());
  }

}
