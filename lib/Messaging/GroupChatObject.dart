import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatObject{
  final String id;
  final String title;
  final List<String> groupChatMembers;
  final String owner;
  final String lastSentMessage;
  final Timestamp lastSentMessageTime;

  GroupChatObject({
    required this.id,
    required this.title,
    required this.groupChatMembers,
    required this.owner,
    required this.lastSentMessage,
    required this.lastSentMessageTime,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'groupChatMembers': groupChatMembers,
    'owner': owner,
    'lastSentMessage' : lastSentMessage,
    'lastSentMessageTime': lastSentMessageTime
  };

  static GroupChatObject fromJson(Map<String, dynamic> json) => GroupChatObject(
    id: json['id'],
    title: json['title'],
    groupChatMembers: json['groupChatMembers'].cast<String>(),
    owner: json['owner'],
    lastSentMessage: json['lastSentMessage'],
    lastSentMessageTime: json['lastSentMessageTime'],
  );

}