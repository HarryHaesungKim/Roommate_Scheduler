class TaskObject {
  String? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  double? rates ;
  int? voteRecord;
  int? remind ;
  String? repeat;
  String? assignedUserName;
  String? assignedUserID;
  double? rate;
  double? overallRate;
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
    this.rates,
    this.voteRecord,
    this.overallRate,
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
    voteRecord : json['voteRecord'],
    rates : json['Rates'],
    overallRate : json['overallRate'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['note'] = note;
    data['isCompleted'] = isCompleted;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['color'] = color;
    data['Rate'] = rate;
    data['remind'] = remind;
    data['repeat'] = repeat;
    data['assignedUserName'] = assignedUserName;
    data['assignedUserID'] = assignedUserID;
    data['voteRecord'] = voteRecord;
    data['Rates'] = rates;
    data['overallRate'] = overallRate;
    return data;
  }
}


