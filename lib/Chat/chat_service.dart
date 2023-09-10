import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'MessageModel.dart';

class ChatService extends ChangeNotifier {
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Send message
  Future<void> sendMessage(List<String> receiverIds, String message) async {
    // get current user info

    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    final String id = "";

    // create a new message
    MessageModel newMessage = MessageModel(
      senderId: currentUserId,
      senderUserName: currentUserEmail,
      receiverIds: receiverIds,
      timestamp: timestamp,
      message: message,
      id: id
    );

    // construct chat room id from current user id and receiver id (sorted to ensure uniqueness).
    List<String> ids = [currentUserId, receiverIds.toString()];
    ids.sort();
    String chatRoomId = ids.join("_");

    // add new message to database
    await _fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toJSON());

  }

  // Get message
  Stream<QuerySnapshot> getMessages(String userId, List<String> otherUserIds) {
    // construct chat room id from user ids (sorted to ensure it matches the id used when sending messages).
    List<String> ids = [userId, otherUserIds.toString()];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore.collection("chat_rooms").doc(chatRoomId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }
}
