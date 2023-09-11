import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roommates/User/user_controller.dart';
import 'package:roommates/User/user_model.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _editProfilePage();
}
//Edit profile page
class _editProfilePage extends State<EditProfile> {
  String userName = "";
  String email = "";
  String password = "";
  String balance = "";
  String income ="";
  String expense = "";
  void getUserData() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if(user !=null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();
      Map<String, dynamic> list = db.data() as Map<String, dynamic>;

      setState(() {
        userName = list['UserName'];
        email = list['Email'];
        password = list['Password'];
        balance = list['Balance'];
        income = list['Income'];
        expense = list['Expense'];
      });
    }
  }
  Future updateUserData() async {
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    final user = UserData(
      email: _emailController.text.trim(),
      password: _passWordController.text.trim(),
      username: _userNameController.text.trim(),
      balance:balance,
      income: income,
      expense: expense,
    );
    await FirebaseFirestore.instance.collection("Users").doc(userID).update(user.toJson());
  }
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    getUserData();
    return Scaffold(
    appBar: AppBar(
      leading: null,
      backgroundColor: Colors.orange[700],
      title: const Text("Edit Profile"),

    ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://cdn.pixabay.com/photo/2016/08/31/11/54/icon-1633249_960_720.png"),
                          )),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Colors.white,
                              ),
                              color: Colors.blue),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
                        SizedBox(height: 50),
                        Form(child: Column(
                          children: [
                            TextFormField(
                              controller: _userNameController,
                              decoration: InputDecoration(
                                label:Text("Full Name"),
                                hintText: userName,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                prefixIcon: Icon(Icons.people),

                              ),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: email,
                                label:Text("Email"),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                prefixIcon: Icon(Icons.email),

                              ),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              controller: _passWordController,
                              decoration: InputDecoration(
                                hintText: password,
                                label:Text("Password"),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                prefixIcon: Icon(Icons.password),

                              ),
                            ),
                            SizedBox(height: 20,),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: ()  {
                                  updateUserData();
                                  if (mounted) {
                                  setState(() {
                                    userName = _userNameController.text.trim();
                                    password = _passWordController.text.trim();
                                    email = _emailController.text.trim();
                                    balance = balance;
                                  }
                                      );
                                  }
                                },
                                style:ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,side: BorderSide.none, shape: const StadiumBorder()
                                ) ,
                                child: const Text(
                                  "Edit Profile",style: TextStyle(color:Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                        ),
                      ],
                            ),
        ),
      ),
    );
}




}



