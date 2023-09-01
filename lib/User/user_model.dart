class userModel {
  String? username;
  String? password;
  String? email;
  String? balance;

  userModel({
    this.email,
    this.password,
    this.username,
    this.balance,
  });

  userModel.fromJson(Map<String, dynamic> json) {
    email = json['Email'].toString();
    password = json['Password'].toString();
    username = json['UserName'].toString();
    balance = json['Balance'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = this.email;
    data['Password'] = this.password;
    data['UserName'] = this.username;
    data['Balance'] = this.balance;
    return data;
  }
}