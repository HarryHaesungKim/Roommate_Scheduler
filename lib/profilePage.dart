
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class profilePage extends StatefulWidget {
  profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePage();
}

class _profilePage extends State<profilePage> {
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
    'Register',
    style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize:20
    ),
    ),
    //Testing log out
    MaterialButton(onPressed:(){
    FirebaseAuth.instance.signOut();
    },
    child: Text('sign out'),
    color: Colors.blue),
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