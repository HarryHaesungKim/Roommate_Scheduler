import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roommates/Messaging/GroupChatObject.dart';

class MessagingController {

  /// This method creates a new chatroom in Firebase.
  ///
  /// Returns the chat ID.
  Future<String> createChatRoom(List<String> members, String title) async {

    // Reference to Document.
    final groupChat = FirebaseFirestore.instance.collection('chat_rooms').doc();

    // Create the notification object.
    final announcement = GroupChatObject(
      id: groupChat.id,
      title: title,
      groupChatMembers: members,
    );

    // Create document and write data to firebase, then return the chat ID.
    await groupChat.set(announcement.toJson());
    return groupChat.id;
  }

  /// This method deletes a chat from Firebase.
  void deleteChat(String chatID){
    FirebaseFirestore.instance.collection('chat_rooms').doc(chatID).delete();
  }
}