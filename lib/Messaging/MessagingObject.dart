
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderUserName;
  final List<String> receiverIds;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderUserName,
    required this.receiverIds,
    required this.message,
    required this.timestamp
  });

  // convert to a map (for firebase)
  Map<String, dynamic> toMap(){
    return {
      'senderId' : senderId,
      'senderUserName' : senderUserName,
      'receiverIds' : receiverIds,
      'message' : message,
      'timestamp' : timestamp,
    };
  }

}