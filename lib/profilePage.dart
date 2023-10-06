import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/User/user_model.dart';
import 'package:roommates/themeData.dart';
import 'package:roommates/settingsPage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _profilePage();
}
//Edit profile page
class _profilePage extends State<ProfilePage> {
  String userName = "";
  String email = "";
  String imageURL = "";
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
          userName = list['UserName'];
          email = list['Email'];
          imageURL = list['imageURL'];
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
      //darkTheme: darkTheme,
      home: Scaffold(
      //  backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leading: null,
        //  backgroundColor: Theme.of(context).colorScheme.background,
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

                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: email,
                        enabled: false,
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                        ),
                        label:Text("Email"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: Icon(Icons.email),

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

                    ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: email,
                      enabled: false,
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                        color: Colors.black,
                      ),
                      label:Text("Email"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(Icons.email),

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
    );
  }




}



