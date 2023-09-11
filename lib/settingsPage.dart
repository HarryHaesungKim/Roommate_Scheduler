import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/LoginPage.dart';
import 'package:roommates/Settings/accountInformation.dart';
import 'package:roommates/Settings/helpMenu.dart';
import 'package:roommates/User/user_model.dart';
class settingsProfile extends StatefulWidget {
  const settingsProfile({Key? key}) : super(key: key);

  @override
  State<settingsProfile> createState() => _settingsProfileState();
}

class _settingsProfileState extends State<settingsProfile> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => LoginPage())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.orange[700],
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
                color: Colors.orange,
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
                  leading: Icon(Icons.password,color: Colors.orange,),
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
                  leading: Icon(Icons.password_outlined,color: Colors.orange,),
                  title: Text("Mangage Group Member"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                 //Undo
                  onTap: (){

                  },
                ),
                //Mangage balance
                ListTile(
                  leading: Icon(Icons.password_outlined,color: Colors.orange,),
                  title: Text("Mangage Balance"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  //Undo
                  onTap: (){

                  },
                ),
                Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey.shade300,
                ),

                //Change theme
                ListTile(
                  leading: Icon(Icons.password_outlined,color: Colors.orange,),
                  title: Text("Change Theme"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  //Undo
                  onTap: (){

                  },
                ),
                Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey.shade300,
                ),

                //Help menu
                ListTile(
                  leading: Icon(Icons.password_outlined,color: Colors.orange,),
                  title: Text("Help Menu"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return HelpMenuPage();
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
                color: Colors.orange,
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
                    activeColor: Colors.orange,
                    value: true,
                    title: Text("Receive Chat Messages",),
                    onChanged: (val){

                    },
                  ),
                  SwitchListTile(
                    activeColor: Colors.orange,
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
              color: Colors.orange,
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
    );
  }
}
