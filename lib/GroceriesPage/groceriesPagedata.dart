class Groceries {
  String? id;
  String? title;
  double? amount;
  String? paidName;
  int? remind;
  String? date;
  String? split;

  Groceries({
    this.id,
    this.title,
    this.amount,
    this.paidName,
    this.remind,
    this.date,
    this.split,
  });

  Groceries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'].toString();
    amount = json['amount'];
    paidName = json['paidName'];
    remind = json['remind'];
    date = json['date'];
    split = json['split'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['amount'] = this.amount;
    data['paidName'] = this.paidName;
    data['remind'] = this.remind;
    data['date'] = this.date;
    data['split'] = this.split;
    return data;
  }
}





