class GroupChatObject{
  final String id;
  final String title;
  final List<String> groupChatMembers;

  GroupChatObject({
    required this.id,
    required this.title,
    required this.groupChatMembers,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'groupChatMembers': groupChatMembers,
  };

  static GroupChatObject fromJson(Map<String, dynamic> json) => GroupChatObject(
    id: json['id'],
    title: json['title'],
    groupChatMembers: json['groupChatMembers'].cast<String>(),
  );

}