
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roommates/Task/input_field.dart';
import 'package:roommates/User/user_model.dart';

import '../themeData.dart';
class mangageGroupMember extends StatefulWidget {
  const mangageGroupMember({Key? key}) : super(key: key);

  @override
  State<mangageGroupMember> createState() => _mangageGroupMember();
}
class _mangageGroupMember extends State<mangageGroupMember> {
  final TextEditingController _accessCodeController = TextEditingController();
  String themeBrightness = "";
  String themeColor = "";
  void getUserData() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if(user !=null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();
      Map<String, dynamic> list = db.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          themeBrightness = list['themeBrightness'];
          themeColor = list['themeColor'];
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    getUserData();
    return MaterialApp(
        theme: showOption(themeBrightness),
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: setAppBarColor(themeColor, themeBrightness),
        title: const Text("Group Member"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: setBackGroundBarColor(themeBrightness)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(
              width: 50,
              child: InputField(
                title:   "Access Code"  ,
                hint: "Enter your code",
                controller: _accessCodeController,),
            ),
            SizedBox(height: 20,),
            SizedBox(width: 15,
                child: ElevatedButton(
                  onPressed: (){
                     //Back-End from Groups database
                  },
                  style:ElevatedButton.styleFrom(
                      backgroundColor:setAppBarColor(themeColor, themeBrightness),side: BorderSide.none, shape: const StadiumBorder()
                  ) ,
                  child: const Text(
                    "Join Different Group",style: TextStyle(color:Colors.white),
                  ),
                )
            ),
            SizedBox(height:20,)
     ,
            SizedBox(width: 15,
                child: ElevatedButton(
                  onPressed: (){
                    //Back-End from Groups database
                  },
                  style:ElevatedButton.styleFrom(
                      backgroundColor: setAppBarColor(themeColor, themeBrightness),side: BorderSide.none, shape: const StadiumBorder()
                  ) ,
                  child: const Text(
                    "Leave Group",style: TextStyle(color:Colors.white),
                  ),
                )
            )
          ],
        ),
      ),

    )
    );
  }

}