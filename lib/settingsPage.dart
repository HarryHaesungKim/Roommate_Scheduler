import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/Location/currentLocation.dart';
import 'package:roommates/LoginPage.dart';
import 'package:roommates/Settings/accountInformation.dart';
import 'package:roommates/Settings/changeThemePage.dart';
import 'package:roommates/Settings/mangageGroupMember.dart';
import 'package:roommates/themeData.dart';

import 'User/user_controller.dart';
class settingsProfile extends StatefulWidget {
  const settingsProfile({Key? key}) : super(key: key);

  @override
  State<settingsProfile> createState() => _settingsProfileState();
}

class _settingsProfileState extends State<settingsProfile> {
  String themeBrightness = "";
  String themeColor = "";
  final userController userCon = userController();
  late Future<String> futureThemeBrightness;
  late Future<String> futureThemeColor;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => const LoginPage())));
  }
  @override
  void initState() {
    super.initState();
    String? uID = FirebaseAuth.instance.currentUser?.uid;
    futureThemeBrightness = userCon.getUserThemeBrightness(uID!);
    futureThemeColor = userCon.getUserThemeColor(uID);
  }
  @override
  Widget build(BuildContext context) {
    //getUserData();
    return FutureBuilder(
        future: Future.wait([futureThemeBrightness,futureThemeColor]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) return Container();
          themeBrightness = snapshot.data[0];
          themeColor = snapshot.data[1];
          return MaterialApp(

                ),
                Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey.shade300,
                ),

                //Mangage Group member
                ListTile(
                  leading: Icon(Icons.group_add,color: setAppBarColor(themeColor, themeBrightness),),
                  title: const Text("Mangage Group Member"),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                 //Undo
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const mangageGroupMember()),
                    );
                  },
                ),
                //Change theme
                ListTile(
                  leading: Icon(Icons.color_lens,color:setAppBarColor(themeColor, themeBrightness),),
                  title: const Text("Change Theme"),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  //Undo
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const changeTheme()),
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
                // ),

                // Container(
                //   width: double.infinity,
                //   height: 1.0,
                //   color: Colors.grey.shade300,
                // ),

                //Help menu
                ListTile(
                  leading: Icon(Icons.map,color: setAppBarColor(themeColor, themeBrightness),),
                  title: const Text("Location"),
                  trailing: const Icon(Icons.keyboard_arrow_right),
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
              const SizedBox(width: 10),
              const Text("Notifications",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
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
                    title: const Text("Receive Chat Messages",),
                    onChanged: (val){

                    },
                  ),
                  title: const Text("Settings"),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: setAppBarColor(themeColor, themeBrightness),
                          ),
                          const SizedBox(width: 10,),
                          const Text("Account",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
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
                              title: const Text("Manage Account Information"),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              //Undo
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EditProfile()),
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
                              leading: Icon(Icons.password_outlined,color: setAppBarColor(themeColor, themeBrightness),),
                              title: const Text("Mangage Group Member"),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              //Undo
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const mangageGroupMember()),
                                );
                              },
                            ),
                            //Change theme
                            ListTile(
                              leading: Icon(Icons.password_outlined,color:setAppBarColor(themeColor, themeBrightness),),
                              title: const Text("Change Theme"),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              //Undo
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const changeTheme()),
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
                            // ),

                            // Container(
                            //   width: double.infinity,
                            //   height: 1.0,
                            //   color: Colors.grey.shade300,
                            // ),

                            //Help menu
                            ListTile(
                              leading: Icon(Icons.map,color: setAppBarColor(themeColor, themeBrightness),),
                              title: const Text("User Current Location"),
                              trailing: const Icon(Icons.keyboard_arrow_right),
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
                          const SizedBox(width: 10),
                          const Text("Notifications",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
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
                                  title: const Text("Receive Chat Messages",),
                                  onChanged: (val){

                                  },
                                ),
                                SwitchListTile(
                                  activeColor: setAppBarColor(themeColor, themeBrightness),
                                  value: true,
                                  title: const Text("Receive Notification Messages"),
                                  onChanged: (val){

                                  },
                                )
                              ]
                          )
                      ),
                      const SizedBox(height: 50),

                      Center(
                        child: OutlinedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    //side: BorderSide(color: Colors.white)
                                  ))),
                          onPressed: () {
                            _signOut();
                          },
                          child: Text(
                            'Sign out',
                            style: TextStyle(
                              color: setAppBarColor(themeColor, themeBrightness),
                              letterSpacing: 2,
                              fontSize: 15.0,

                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          );
        });


  }
}
