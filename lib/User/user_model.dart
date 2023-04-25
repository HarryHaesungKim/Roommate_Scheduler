class userModel {
  String? username;
  String? password;
  String? email;

  userModel({
    this.email,
    this.password,
    this.username,
  });

  userModel.fromJson(Map<String, dynamic> json) {
    email = json['Email'].toString();
    password = json['Password'].toString();
    username = json['UserName'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = this.email;
    data['Password'] = this.password;
    data['UserName'] = this.username;
    return data;
  }
}