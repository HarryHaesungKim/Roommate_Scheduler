import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roommates/mainPage.dart';


class registrationPage extends StatefulWidget {
  const registrationPage({Key? key}) : super(key: key);

  @override
  State<registrationPage> createState() => _RegPageState();
}

class _RegPageState extends State<registrationPage> {
  bool showMain = false;
  //controllers for text entered by user
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future registerAccount() async {
    if (passwordsMatch()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),

      );
      setState(() {showMain = true;
      });
    } else {
      // display error saying password does not match
    }
  }

  bool passwordsMatch() {
    return (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    if (showMain) {
      return mainPage();
    }
    else {
      return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
                child: Column(
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
                          fontSize: 20
                      ),
                    ),
                    SizedBox(height: 15),
                    //Email
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[130],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.blue,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              hintText: 'Email',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    //Password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[130],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              hintText: 'Password',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        //Sign in
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[130],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: TextField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              hintText: 'Confirm Password',
                              prefixIcon: Icon(
                                Icons.password,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        //Sign in
                      ),
                    ),
                    SizedBox(height: 35),
                    Container(
                      // decoration: BoxDecoration(color: Colors.green[300]),
                      width: 180.0,
                      height: 40.0,
                      child: ElevatedButton(
                        child: Text('Sign Up',
                          style: TextStyle(color: Colors.white,
                            letterSpacing: 1.5,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',),),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  //side: BorderSide(color: Colors.white)
                                )
                            )
                        ),
                        onPressed: () {
                          registerAccount();
                        },
                      ),
                    ),
                  ],
                )
            ),
          )
      );
    }
  }
}