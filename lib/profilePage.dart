import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/LoginPage.dart';

class profilePage extends StatefulWidget {
  profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePage();

}

class _profilePage extends State<profilePage> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => LoginPage())));
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
        child: Center(
        child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Icon(
        Icons.ios_share_rounded, //change icon
        size: 100,
    ),
    Text(
    'Profile',
    style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize:20
    ),
    ),
    //Testing log out
    MaterialButton(onPressed:(){
      _signOut();
    },
    child: Text('sign out'),
    color: Colors.orange[700]),
  ]
    ),
    )
    )
    );


    // return Scaffold(
    //
    //   backgroundColor:  Color.fromARGB(255, 227, 227, 227),
    //   body: Padding(
    //     padding: const EdgeInsets.only(bottom: 25),
    //     child: Align(
    //       alignment: Alignment.bottomCenter,
    //       child: Text('Profile Page',
    //         style: optionStyle,),
    //     ),
    //   ),
    // );
  }
}