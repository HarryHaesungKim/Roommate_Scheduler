
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'CostSplitObject.dart';

class CostSplitController {

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
    String userName = list['UserName'];

    return [user!, email, groupID, userName];

  }

  // Future<List<String>> getGroupMembers() async {
  //
  //   // Get the user IDs via groupID
  //
  //   final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection("Users")
  //       .where('groupID', isEqualTo: '84461')
  //       .get();
  //
  //   final allMembersInGroupData = querySnapshot.docs.map((doc) => doc.id).toList();
  //
  //   print(allMembersInGroupData);
  //
  //   return allMembersInGroupData;
  // }

  // Creates the notification object and sends it to firebase.
  Future createPayment({required String title, required String description, required String amount, required List<String> whoNeedsToPay}) async {

    // // Getting the User Data.
    // await getUserData();

    // Math for how much each person owes.
    var splitAmount = double.parse(amount) / whoNeedsToPay.length;

    // Get list of users in the same group. Waits until we have the data.
    final futureData = await Future.wait([getUserData()]);

    //final groupMembers = futureData[1];

    // // Write a notification for all users.
    // for (String member in groupMembers){
    //
    //
    // }

    // Reference to Document.
    final notification = FirebaseFirestore.instance.collection('Group').doc(futureData[0][2]).collection('Payments').doc();

    // Create the notification object.
    final announcement = CostSplitObject(
      id: notification.id,
      title: title,
      description: description,
      time: DateTime.now(),
      amount: amount,
      creator: futureData[0][3],
      howMuchDoesEachPersonOwe: splitAmount.toString(),
      whoNeedsToPay: whoNeedsToPay,
      whoHasPayed: [],
    );

    // Create document and write data to firebase.
    await notification.set(announcement.toJson());

    // All done :)

  }
}
