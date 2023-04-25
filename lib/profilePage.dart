import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roommates/LoginPage.dart';
import 'package:roommates/settingsPage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _profilePage();
}
class _profilePage extends State<ProfilePage> {
   static String userName = "";
   static String email = "";
   static String password = "";

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
      print(list.length);
      userName = list['UserName'];
      email = list['Email'];
      password = list['Password'];
    }
   //return userName;
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    getUserData();
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.orange[700],
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
              SizedBox(height: 15),
              buildUserInformation("Username", userName),
              buildUserInformation("Email", email),
              buildUserInformation("Passwword", password),
              Container(
                child: ElevatedButton(
                  child: Text(
                    'Sign out',
                    style: TextStyle(
                      color: Colors.yellow,
                      letterSpacing: 2,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            //side: BorderSide(color: Colors.white)
                          ))),
                  onPressed: () {
                    _signOut();
                  },
                ),
              ),
              SizedBox(height: 15),
              //Need to fix
              Container(
                child: ElevatedButton(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.yellow,
                      letterSpacing: 2,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            //side: BorderSide(color: Colors.white)
                          ))),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserInformation(String label, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      // child: Text(text),
        // child: TextFormField(initialValue: text)
      child: TextField (
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: text,
            hintStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              color: Colors.black,
            )),
      ),

    );
  }
}
