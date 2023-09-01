class Groceries {
  String? id;
  String? title;
  double? amount;
  String? paidName;
  int? percentage;
  int? remind;
  String? date;

  Groceries({
    this.id,
    this.title,
    this.amount,
    this.paidName,
    this.remind,
    this.percentage,
    this.date,
  });
  Groceries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'].toString();
    amount = json['amount'];
    paidName = json['paidName'];
    percentage = json['percentage'];
    remind = json['remind'];
    date = json['date'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['amount'] = this.amount;
    data['paidName'] = this.paidName;
    data['remind'] = this.remind;
    data['percentage'] = this.percentage;
    data['date'] = this.date;
    return data;
  }
}





