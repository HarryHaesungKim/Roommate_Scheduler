import 'dart:ui';

class UserData {
   String? username;
   String? password;
   String? email;
   String? balance;
   String? income;
   String? expense;
   String? groupID;
   String? imageURL;
   List<String>? chatRooms;
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
     this.chatRooms,
     this.imageURL,
     this.themeBrightness,
     this.themeColor,
  });
   UserData.formJson(Map<String, dynamic> json) {
     email = json['Email'].toString();
     password = json['Password'].toString();
     username = json['UserName'].toString();
     balance = json['Balance'].toString();
     income = json['Income'].toString();
     expense = json['Expense'].toString();
     groupID = json['groupID'].toString();
     chatRooms = json['chatRooms'];
     imageURL = json['imageURL'].toString();
     themeBrightness = json['themeBrightness'].toString();
     themeColor = json['themeColor'].toString();
   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = new Map<String, dynamic>();
     data['Email'] = this.email;
     data['Password'] = this.password;
     data['UserName'] = this.username;
     data['Balance'] = this.balance;
     data['Income'] = this.income;
     data['Expense'] = this.expense;
     data['groupID'] = this.groupID;
     data['chatRooms'] = this.chatRooms;
     data['imageURL'] = this.imageURL;
     data['themeBrightness'] = this.themeBrightness;
     data['themeColor'] = this.themeColor;

     return data;
   }


}
