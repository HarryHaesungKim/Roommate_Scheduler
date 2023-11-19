import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? username;
  String? password;
  String? email;
  String? balance;
  String? income;
  String? expense;
  String? groupID;
  String? imageURL;
  // List<String>? chatRooms;
  GeoPoint? location;
  String? themeBrightness; //light or dark
  String? themeColor; // colors



  UserData({
    this.email,
    this.password,
    this.username,
    this.balance,
    this.income,
    this.expense,
    this.groupID,
    // this.chatRooms,
    this.imageURL,
    this.location,
    this.themeBrightness,
    this.themeColor,

   });
   static UserData fromJson(Map<String, dynamic> json) => UserData(
     email : json['Email'].toString(),
     password : json['Password'].toString(),
     username : json['UserName'].toString(),
     balance :json['Balance'].toString(),
     income :json['Income'].toString(),
     expense : json['Expense'].toString(),
     groupID : json['groupID'].toString(),
     // chatRooms : json['chatRooms'],
     imageURL :json['imageURL'].toString(),
     location : json['location'],
     themeBrightness : json['themeBrightness'].toString(),
     themeColor : json['themeColor'].toString(),
   );

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = <String, dynamic>{};
     data['Email'] = email;
     data['Password'] = password;
     data['UserName'] = username;
     data['Balance'] = balance;
     data['Income'] = income;
     data['Expense'] = expense;
     data['groupID'] = groupID;
     // data['chatRooms'] = chatRooms;
     data['imageURL'] = imageURL;
     data['location'] = location;
     data['themeBrightness'] = themeBrightness;
     data['themeColor'] = themeColor;
     return data;
   }


}
