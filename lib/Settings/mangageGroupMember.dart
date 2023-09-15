
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roommates/Task/input_field.dart';
import 'package:roommates/User/user_model.dart';
class mangageGroupMember extends StatefulWidget {
  const mangageGroupMember({Key? key}) : super(key: key);

  @override
  State<mangageGroupMember> createState() => _mangageGroupMember();
}
class _mangageGroupMember extends State<mangageGroupMember> {
  final TextEditingController _accessCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: const Text("Group Member"),
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
                      backgroundColor: Colors.orange,side: BorderSide.none, shape: const StadiumBorder()
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
                      backgroundColor: Colors.orange,side: BorderSide.none, shape: const StadiumBorder()
                  ) ,
                  child: const Text(
                    "Leave Group",style: TextStyle(color:Colors.white),
                  ),
                )
            )
          ],
        ),
      ),


    );
  }

}