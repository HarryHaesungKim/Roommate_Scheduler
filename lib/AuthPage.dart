import 'package:flutter/material.dart';
import 'package:roommates/LoginPage.dart';
import 'registrationPageCreatGroup.dart';
import 'package:roommates/AuthPage.dart';
import 'package:roommates/registrationPageCreatGroup.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}
class _AuthPageState extends State<AuthPage>{
  // At first this should be true, for now set as false
  bool showLogin = true;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    if(showLogin){
      // page for existing users to login
      return  LoginPage();
    } else {
      // page for users to register an account
      return registrationPage();
    }
  }
}


