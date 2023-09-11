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
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(userController());
    final TextEditingController _passWordController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _userNameController = TextEditingController();

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
                              initialValue: "123",
                              decoration: InputDecoration(
                                label:Text("Full Name"),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                prefixIcon: Icon(Icons.people),

                              ),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              initialValue: "123",
                              decoration: InputDecoration(
                                label:Text("Email"),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                prefixIcon: Icon(Icons.email),

                              ),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              initialValue: "234",
                              decoration: InputDecoration(
                                label:Text("Password"),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                prefixIcon: Icon(Icons.password),

                              ),
                            ),
                            SizedBox(height: 20,),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () =>Get.to((EditProfile())),
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



