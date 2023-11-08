import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roommates/Messaging/GroupChatObject.dart';

class MessagingController {

  /// This method creates a new chatroom in Firebase.
  ///
  /// Returns the chat ID.
  Future<String> createChatRoom(String owner, List<String> members, String title, String lastSentMessage) async {

    // Reference to Document.
    final groupChat = FirebaseFirestore.instance.collection('Chats').doc();

    // Create the notification object.
    final announcement = GroupChatObject(
      owner: owner,
      id: groupChat.id,
      title: title,
      groupChatMembers: members,
      lastSentMessage: lastSentMessage,
      lastSentMessageTime: Timestamp.now(),
    );

    // Create document and write data to firebase, then return the chat ID.
    await groupChat.set(announcement.toJson());
    return groupChat.id;
  }

  /// This method deletes a chat from Firebase.
  void deleteChat(String chatID){
    FirebaseFirestore.instance.collection('Chats').doc(chatID).delete();
  }
  
  /// This method updates information of a group chat in Firebase.
  void updateChat(String chatID, String newTitle, List<String> newMembers){
    FirebaseFirestore.instance.collection('Chats').doc(chatID).update({'title': newTitle, 'groupChatMembers': newMembers});

  }

  /// This method returns the title of the group chat through their ID.
  Future<String> getGroupChatTitle(String chatID) async {
    final groupChatRef = await FirebaseFirestore.instance.collection('Chats').doc(chatID).get();
    String title = groupChatRef.data()?['title'];
    return title;
  }

  /// This method updates the last sent message time of a group chat object.
  void updateLastSentMessage(String chatID, Timestamp timestamp, String lastSentMessage) async {
    FirebaseFirestore.instance.collection('Chats').doc(chatID).update({'lastSentMessage': lastSentMessage, 'lastSentMessageTime': timestamp});
  }

  // /// This method updates the group members of a chat.
  // void updateGroupMembers(String chatID, List<String> updatedMembers) async {
  //   FirebaseFirestore.instance.collection('Chats').doc(chatID).update({'groupChatMembers': updatedMembers});
  // }

}