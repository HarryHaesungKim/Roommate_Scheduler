import "package:cloud_firestore/cloud_firestore.dart";
import "package:roommates/User/user_model.dart";



class Chat {
  Timestamp? timestamp;
  String? chatContent;
  List<UserData>? toUsers;
  UserData? fromUser;


  Chat({
    this.timestamp,
    this.chatContent,
    this.toUsers,
    this.fromUser
  });

  Chat.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    chatContent = json['chatContent'];
    toUsers = json['toUsers'];
    fromUser = json['fromUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['chatContent'] = chatContent;
    data['toUsers'] = toUsers;
    data['fromUser'] = fromUser;
    return data;
  }
}

