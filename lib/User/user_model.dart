class UserData {
   String? username;
   String? password;
   String? email;
   String? balance;
   String? id;

   UserData({
     this.email,
     this.password,
     this.username,
     this.balance,
     this.id,
  });
   UserData.fromJson(Map<String, dynamic> json) {
     id = json['id'];
     email = json['Email'].toString();
     password = json['Password'].toString();
     username = json['UserName'].toString();
     balance = json['Balance'].toString();
   }

   Map<String, dynamic> toJson() {
     final Map<String, dynamic> data = new Map<String, dynamic>();
     data['id'] = this.id;
     data['Email'] = this.email;
     data['Password'] = this.password;
     data['UserName'] = this.username;
     data['Balance'] = this.balance;
     return data;
   }


}
