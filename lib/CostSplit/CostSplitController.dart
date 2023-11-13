
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roommates/api/firebase_api.dart';

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

  // Creates the notification object and sends it to firebase.
  Future createPayment({required String title, required String description, required String amount, required List<String> whoNeedsToPay}) async {

    // // Getting the User Data.
    // await getUserData();

    // Math for how much each person owes.
    var splitAmount = double.parse(amount) / (whoNeedsToPay.length);


    // Get list of users in the same group. Waits until we have the data.
    final futureData = await Future.wait([getUserData()]);

    //final groupMembers = futureData[1];

    // // Write a notification for all users.
    // for (String member in groupMembers){
    //
    //
    // }

    List<String> whoHasPaid = [];
    if(whoNeedsToPay.contains(futureData[0][0])){
      whoHasPaid.add(futureData[0][0]);
    }

    // Reference to Document.
    final payment = FirebaseFirestore.instance.collection('Group').doc(futureData[0][2]).collection('Payments').doc();

    // Create the notification object.
    final announcement = CostSplitObject(
      id: payment.id,
      title: title,
      description: description,
      time: DateTime.now(),
      amount: amount,
      creator: futureData[0][0],
      howMuchDoesEachPersonOwe: splitAmount.toString(),
      whoNeedsToPay: whoNeedsToPay,
      whoHasPaid: whoHasPaid,
    );

    // Create document and write data to firebase.
    await payment.set(announcement.toJson());
    
    // Send push notification.
    FirebaseApi().sendPushNotification('New payment created.', title);

    // All done :)

  }

  Future<void> settlePayment(CostSplitObject payment) async {

    //https://stackoverflow.com/questions/64934102/firestore-add-or-remove-elements-to-existing-array-with-flutter

    final futureData = await Future.wait([getUserData()]);

    FirebaseFirestore.instance.collection('Group').doc(futureData[0][2]).collection('Payments').doc(payment.id)
        .update({'whoHasPaid': FieldValue.arrayUnion([futureData[0][0]]),});
  }

  Future<void> unsettlePayment(CostSplitObject payment) async {

    //https://stackoverflow.com/questions/64934102/firestore-add-or-remove-elements-to-existing-array-with-flutter

    final futureData = await Future.wait([getUserData()]);

    FirebaseFirestore.instance.collection('Group').doc(futureData[0][2]).collection('Payments').doc(payment.id)
        .update({'whoHasPaid': FieldValue.arrayRemove([futureData[0][0]]),});
  }

  Future<void> deletePayment(CostSplitObject payment) async {

    final futureData = await Future.wait([getUserData()]);

    FirebaseFirestore.instance.collection('Group').doc(futureData[0][2]).collection('Payments').doc(payment.id).delete();
  }

}
