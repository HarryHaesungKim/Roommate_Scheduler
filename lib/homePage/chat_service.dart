import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:roommates/User/user_controller.dart';
import 'message.dart';
import 'package:get/get.dart';


class ChatService extends ChangeNotifier {
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final userController _userController = Get.put(userController());

  // Send message
  Future<void> sendMessage(List<String> receiverIds, String message) async {
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

    // construct chat room id from current user id and receiver id (sorted to ensure uniqueness).

    List<String> ids = [currentUserId];
    for(int i = 0; i < receiverIds.length; i++)
      {
        ids.add(receiverIds[i]);
      }
    ids.sort();
    String chatRoomId = ids.join("_");
    print("CHatroom id is $chatRoomId");

    // add new message to database
    await _fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());

  }

  // Get message
  Stream<QuerySnapshot> getMessages(String userId, List<String> otherUserIds) {
    // construct chat room id from user ids (sorted to ensure it matches the id used when sending messages).
    List<String> ids = [userId];
    for(int i = 0; i < otherUserIds.length; i++)
    {
      ids.add(otherUserIds[i]);
    }
    ids.sort();
    String chatRoomId = ids.join("_");
    print("ChatID  $chatRoomId");
    return _fireStore.collection("chat_rooms").doc(chatRoomId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }
}