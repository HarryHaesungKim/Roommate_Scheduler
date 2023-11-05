import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/Location/currentLocation.dart';
import 'package:roommates/LoginPage.dart';
import 'package:roommates/Settings/accountInformation.dart';
import 'package:roommates/Settings/changeThemePage.dart';
import 'package:roommates/Settings/mangageGroupMember.dart';
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
        MaterialPageRoute(builder: ((context) => const LoginPage())));
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
  }
}
