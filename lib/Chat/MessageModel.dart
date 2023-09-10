import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderUserName;
  final List<String> receiverIds;
  final String message;
  final Timestamp timestamp;
  final String id;

  MessageModel({
    required this.senderId,
    required this.senderUserName,
    required this.receiverIds,
    required this.message,
    required this.timestamp,
    required this.id
  });

  // convert to a map (for firebase)
  Map<String, dynamic> toJSON(){
    return {
      'senderId' : senderId,
      'senderEmail' : senderUserName,
      'receiverId' : receiverIds,
      'message' : message,
      'timestamp' : timestamp,
      'id' : id
    };
  }

}
