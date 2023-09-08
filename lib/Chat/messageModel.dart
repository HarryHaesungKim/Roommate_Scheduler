
import 'package:cloud_firestore/cloud_firestore.dart';

class messageModel {
  //attributes of a message
  String? chatContent;
  String? groupName;
  String? fromUser;
  List<String>? toUser;
  Timestamp? timeStamp;

  // constructor for message
  messageModel({
    this.chatContent,
    this.groupName,
    this.fromUser,
    this.toUser,
    this.timeStamp
});
  // This method converts a message object to JSON (format for firestore)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['chatContent'] = chatContent;
    data['groupName'] = groupName;
    data['fromUser'] = fromUser;
    data['toUser'] = toUser;
    data['timeStamp'] = timeStamp;
    return data;
  }

}
