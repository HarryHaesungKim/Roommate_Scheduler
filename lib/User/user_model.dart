class userModel {
  String? username;
  String? password;
  String? email;
  String? groupID;
  List<String>? chatRooms;

  userModel({
    this.email,
    this.password,
    this.username,
    this.groupID,
    this.chatRooms
  });

  userModel.fromJson(Map<String, dynamic> json) {
    email = json['Email'].toString();
    password = json['Password'].toString();
    username = json['UserName'].toString();
    groupID = json['groupID'].toString();
    chatRooms = json['chatRooms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = this.email;
    data['Password'] = this.password;
    data['UserName'] = this.username;
    data['groupID'] = this.groupID;
    data['chatRooms'] = this.chatRooms;
    return data;
  }
}