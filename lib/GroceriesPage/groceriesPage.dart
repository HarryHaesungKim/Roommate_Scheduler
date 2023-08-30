class groceriesPage {
  String? id;
  String? title;
  String? description;
  int? amount;
  String? paidName;
  String? split;
  String? days;
  groceriesPage({
    this.id,
    this.title,
    this.description,
    this.amount,
    this.paidName,
    this.split,
    this.days,
  });
  groceriesPage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'].toString();
    description = json['description'].toString();
    amount = json['amount'];
    paidName = json['paidName'];
    split = json['split'];
    days = json['days'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['paidName'] = this.paidName;
    data['split'] = this.split;
    data['days'] = this.days;
    return data;
  }
}





