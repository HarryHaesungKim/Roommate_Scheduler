
//Blance, accountInformation,register page, user_model

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roommates/Task/input_field.dart';
import 'package:roommates/User/user_model.dart';

import '../themeData.dart';
class mangageBalance extends StatefulWidget {
  const mangageBalance({Key? key}) : super(key: key);

  @override
  State<mangageBalance> createState() => _mangageBalance();
}
class _mangageBalance extends State<mangageBalance> {
  String balance = "";
  String userName ="";
  String password = "";
  String email = "";
  String income ="";
  String expense = "";
  String themeBrightness = "";
  String themeColor = "";
  final TextEditingController _balanceController = TextEditingController();
  Future getCurrentBalance() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if (user != null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();
      Map<String, dynamic> list = db.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          userName = list['UserName'];
          password = list['Password'];
          email = list['Email'];
          balance = list['Balance'];
          income = list['Income'];
          expense = list['Expense'];
          themeBrightness = list['themeBrightness'];
          themeColor = list['themeColor'];
        });
      }
    }
  }
  Future addBalance() async {
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    final user = UserData(
      username: userName,
     password: password,
     email: email,
     balance: ( double.parse(_balanceController.text.trim())  + double.parse(balance)).toString(),
      income: _balanceController.text.trim(),
      expense: expense,

    );
    await FirebaseFirestore.instance.collection("Users").doc(userID).update(user.toJson());
  }

  @override
  Widget build(BuildContext context) {
    getCurrentBalance();
    return MaterialApp(
        theme: showOption(themeBrightness),
        home: Scaffold(
        appBar: AppBar(
        backgroundColor: setAppBarColor(themeColor, themeBrightness),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: setBackGroundBarColor(themeBrightness)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        title: const Text("Balance"),
        ),
        body: Container(
    padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              SizedBox(
                width: 50,
              child: InputField(
                title:   "Balance:  \$" + balance ,
                hint: "amount",
                controller: _balanceController,),
              ),
              SizedBox(height: 20,),
                SizedBox(width: 15,
                  child: ElevatedButton(
                    onPressed: (){
                   setState(() {
                     addBalance();
                   });
                    },
                    style:ElevatedButton.styleFrom(
                        backgroundColor: setAppBarColor(themeColor, themeBrightness),side: BorderSide.none, shape: const StadiumBorder()
                    ) ,
                    child: const Text(
                      "Add Balance",style: TextStyle(color:Colors.white),
                  ),
                )
                ),
            ],

          ),
    ),

        )
    );
  }

}