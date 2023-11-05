class Event {
  String? id;
  String? title;
  String? date;
  String? note;
  Event({
    this.id,
    this.title,
    this.date,
    this.note
  });
  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    title = json['title'].toString();
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['note'] = note;
    return data;
  }
}