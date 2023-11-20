import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/Location/currentLocation.dart';
import 'package:roommates/LoginPage.dart';
import 'package:roommates/Settings/accountInformation.dart';
import 'package:roommates/Settings/changeThemePage.dart';
import 'package:roommates/Settings/helpMenu.dart';
import 'package:roommates/Settings/mangageGroupMember.dart';
import 'package:roommates/User/user_model.dart';
import 'package:roommates/themeData.dart';
class settingsProfile extends StatefulWidget {
  const settingsProfile({Key? key}) : super(key: key);

  @override
  State<settingsProfile> createState() => _settingsProfileState();
}

class _settingsProfileState extends State<settingsProfile> {
  String themeBrightness = "";
  String themeColor = "";
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: setBackGroundBarColor(themeBrightness)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text("Settings"),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: setAppBarColor(themeColor, themeBrightness),
                    ),
                    SizedBox(width: 10,),
                    Text("Account",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
                  ],
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(25, 12, 25, 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children:  <Widget>[
                      //Manage Account Information
                      ListTile(
                        leading: Icon(Icons.password,color:setAppBarColor(themeColor, themeBrightness),),
                        title: Text("Manage Account Information"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        //Undo
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfile()),
                          );
                        },

                      ),
                      Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey.shade300,
                      ),

                      //Mangage Group member
                      ListTile(
                        leading: Icon(Icons.group_add,color: setAppBarColor(themeColor, themeBrightness),),
                        title: Text("Mangage Group Member"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        //Undo
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => mangageGroupMember()),
                          );
                        },
                      ),
                      //Change theme
                      ListTile(
                        leading: Icon(Icons.color_lens,color:setAppBarColor(themeColor, themeBrightness),),
                        title: Text("Change Theme"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        //Undo
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => changeTheme()),
                          );
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey.shade300,
                      ),

                      //Help menu
                      // ListTile(
                      //   leading: Icon(Icons.password_outlined,color: setAppBarColor(themeColor, themeBrightness),),
                      //   title: Text("Help Menu"),
                      //   trailing: Icon(Icons.keyboard_arrow_right),
                      //   onTap: (){
                      //     Navigator.push(context,
                      //         MaterialPageRoute(builder: (context) {
                      //           return HelpMenuPage();
                      //         }));
                      //   },
                      //
                      // ),
                      // Container(
                      //   width: double.infinity,
                      //   height: 1.0,
                      //   color: Colors.grey.shade300,
                      // ),

                      //Help menu
                      ListTile(
                        leading: Icon(Icons.map,color: setAppBarColor(themeColor, themeBrightness),),
                        title: Text("Location"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const CurrentLocation();
                              }));
                        },

                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.volume_up,
                      color: setAppBarColor(themeColor, themeBrightness),
                    ),
                    SizedBox(width: 10),
                    Text("Notifications",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
                  ],

                ),
                Card(
                    margin: const EdgeInsets.fromLTRB(25, 12, 25, 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        children:  <Widget>[
                          SwitchListTile(
                            activeColor: setAppBarColor(themeColor, themeBrightness),
                            value: true,
                            title: Text("Receive Chat Messages",),
                            onChanged: (val){

                            },
                          ),
                          SwitchListTile(
                            activeColor: setAppBarColor(themeColor, themeBrightness),
                            value: true,
                            title: Text("Receive Notification Messages"),
                            onChanged: (val){

                            },
                          )
                        ]
                    )
                ),
                SizedBox(height: 50),

                Center(
                  child: OutlinedButton(
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        color: setAppBarColor(themeColor, themeBrightness),
                        letterSpacing: 2,
                        fontSize: 15.0,

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
              ],
            ),
          ),
        )
    );
  }
}
