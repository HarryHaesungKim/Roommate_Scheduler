class TaskObject {
  String? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;
  String? assignedUserName;
  String? assignedUserID;
  double? rate;
  TaskObject({
    required this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
    this.assignedUserName,
    this.assignedUserID,
    this.rate,
  });

  static TaskObject fromJson(Map<String, dynamic> json) => TaskObject(
    id : json['id'],
    title : json['title'].toString(),
    note : json['note'].toString(),
    isCompleted : json['isCompleted'],
    date : json['date'],
    startTime : json['startTime'],
    endTime : json['endTime'],
    color : json['color'],
    remind : json['remind'],
    repeat : json['repeat'],
    assignedUserName : json['assignedUserName'],
    assignedUserID : json['assignedUserID'],
    rate: json['Rate'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['date'] = this.date;
    data['note'] = this.note;
    data['isCompleted'] = this.isCompleted;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['color'] = this.color;
    data['Rate'] = this.rate;
    data['remind'] = this.remind;
    data['repeat'] = this.repeat;
    data['assignedUserName'] = this.assignedUserName;
    data['assignedUserID'] = this.assignedUserID;
    return data;
  }
}


