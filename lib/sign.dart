import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roommates/mainPage.dart';
import 'package:roommates/AuthPage.dart';
class sign extends StatelessWidget{
  const sign({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
           return mainPage();
          }else{
            return mainPage();
          }
        },
      ),
    );
  }
}