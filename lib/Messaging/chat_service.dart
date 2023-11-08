import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:roommates/User/user_controller.dart';
import 'MessagingController.dart';
import 'MessagingObject.dart';
import 'package:get/get.dart';

class ChatService extends ChangeNotifier {
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final userController _userController = Get.put(userController());

  // Messaging controller.
  final MessagingController messagingCon = MessagingController();

  // Send message
  Future<void> sendMessage(List<String> receiverIds, String message, String chatID) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserName = await _userController.getUserName(currentUserId);
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderUserName: currentUserName,
      receiverIds: receiverIds,
      timestamp: timestamp,
      message: message,
    );

    // Update last sent message time of group chat.
    messagingCon.updateLastSentMessage(chatID, timestamp, '$currentUserName: $message');

    // add new message to database
    await _fireStore.collection('Chats').doc(chatID).collection('messages').add(newMessage.toMap());

  }

  // Get message
  Stream<QuerySnapshot> getMessages(String chatID) {
    // construct chat room id from user ids (sorted to ensure it matches the id used when sending messages).

    return _fireStore.collection("Chats").doc(chatID).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }
}