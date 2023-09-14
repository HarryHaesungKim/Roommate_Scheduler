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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['date'] = this.date;
    data['note'] = this.note;
    return data;
  }
}