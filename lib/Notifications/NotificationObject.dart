
class NotificationObject {

  final String id;
  final String title;
  final String body;
  final DateTime time;
  final String type;
  final String groupID;

  NotificationObject({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    required this.groupID
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'time': time,
    'type': type,
    'groupID': groupID,
  };

  static NotificationObject fromJson(Map<String, dynamic> json) => NotificationObject(
    id: json['id'],
    title: json['title'],
    body: json['body'],
    time: json['time'].toDate(),
    type: json['type'],
    groupID: json['groupID']
  );

}