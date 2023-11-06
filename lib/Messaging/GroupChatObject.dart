class GroupChatObject{
  final String id;
  final String title;
  final List<String> groupChatMembers;
  final String owner;

  GroupChatObject({
    required this.id,
    required this.title,
    required this.groupChatMembers,
    required this.owner,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'groupChatMembers': groupChatMembers,
    'owner': owner,
  };

  static GroupChatObject fromJson(Map<String, dynamic> json) => GroupChatObject(
    id: json['id'],
    title: json['title'],
    groupChatMembers: json['groupChatMembers'].cast<String>(),
    owner: json['owner'],
  );

}