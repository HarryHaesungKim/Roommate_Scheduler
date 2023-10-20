import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/User/user_model.dart';
import 'package:roommates/themeData.dart';
import 'package:roommates/settingsPage.dart';

import 'Group/groupController.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _profilePage();
}
//Edit profile page
class _profilePage extends State<ProfilePage> {
    bool _password = true;
    String userName = "";
    String email = "";
    String password = "";
    String groupID = "";
    String isAdmin ="";
    String adminMode ="";

    final groupController _groupController = Get.put(groupController());
    final _uID = FirebaseAuth.instance.currentUser?.uid;

    Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => LoginPage())));
  }
  void getUserData() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if(user !=null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();
      Map<String, dynamic> list = db.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          userName = list['UserName'];
          email = list['Email'];
          password = list['Password'];
          groupID = list['groupID'];
        });

        if(await _groupController.isUserAdmin(_uID!))
          {
            isAdmin = "True";
          }
        else{
          isAdmin = "False";
        }

        if(await _groupController.isGroupAdminMode(groupID))
        {
          adminMode = "True";
        }
        else
        {
            adminMode = "False";
        }
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
          backgroundColor: setAppBarColor(themeColor,themeBrightness), //appbar
          title: const Text("Profile"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => settingsProfile()),
                    );
                  },
                  child: Icon(Icons.settings),
                )),
          ],

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
                                  imageURL),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Form(child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label:Text("Full Name"),
                        labelStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                        ),
                        hintText: userName,
                        enabled: false,
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: Icon(Icons.people,color: Colors.black),

                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: email,
                        enabled: false,
                        labelStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                        ),
                        label:Text("Email"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: Icon(Icons.email,color: Colors.black,),

                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
                ),
              ],
            ),
          ),
        ),
        ),
      );

    getUserData();
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.black,
        title: const Text("Profile"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => settingsProfile()),
                  );
                },
                child: Icon(Icons.settings),
              )),
        ],

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
                               imageURL),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Form(child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label:Text("Full Name"),
                      hintText: userName,
                      enabled: false,
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                        color: Colors.black,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(Icons.people),

              buildUserInformation("Username", userName),
              buildUserInformation("Email", email),
              buildUserInformation("Group ID", groupID),
              buildUserInformation("Admin User", isAdmin),
              buildUserInformation("Admin Mode", adminMode),
           //   buildUserInformation("Password", password),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }




}



