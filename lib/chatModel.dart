import "package:cloud_firestore/cloud_firestore.dart";
import "package:roommates/User/user_model.dart";


import "../User/user_model.dart";

class Chat {
  Timestamp? timestamp;
  String? chatContent;
  List<userModel>? toUsers;
  userModel? fromUser;


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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['chatContent'] = this.chatContent;
    data['toUsers'] = this.toUsers;
    data['fromUser'] = this.fromUser;
    return data;
  }
}

