
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'NotificationObject.dart';

class NotificationController {

  // Current user information.
  String userName = "";
  String email = "";
  String groupID = "";

  // Gets the data of the current user.
  Future<List<String>> getUserData() async {

    String? user = FirebaseAuth.instance.currentUser?.uid;

    DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();

    Map<String, dynamic> list = db.data() as Map<String, dynamic>;

    // String userName = list['UserName'];
    String email = list['Email'];
    String groupID = list['groupID'];

    return [email, groupID];

  }

  Future<List<String>> getGroupMembers() async {

    // Get the user IDs via groupID

    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection("Users")
        .where('groupID', isEqualTo: '84461')
        .get();

    final allMembersInGroupData = querySnapshot.docs.map((doc) => doc.id).toList();

    print(allMembersInGroupData);

    return allMembersInGroupData;
  }

  // Creates the notification object and sends it to firebase.
  Future createNotification({required String title, required String body, required type}) async {

    // // Getting the User Data.
    // await getUserData();
    
    // Get list of users in the same group. Waits until we have the data.
    final futureData = await Future.wait([getUserData(), getGroupMembers()]);

    final groupMembers = futureData[1];
    
    // Write a notification for all users.
    for (String member in groupMembers){

      // Reference to Document.
      final notification = FirebaseFirestore.instance.collection('Users').doc(member).collection('Notifications').doc();

      // Create the notification object.
      final announcement = NotificationObject(
        id: notification.id,
        title: title,
        body: body,
        time: DateTime.now(),
        type: type,
        groupID: futureData[0][1],
        creator: futureData[0][0],
      );

      // Create document and write data to firebase.
      await notification.set(announcement.toJson());
    }

    // All done :)

  }
}
