import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/LoginPage.dart';
import 'package:roommates/joinGroupPage.dart';
import 'package:get/get.dart';
import 'package:roommates/User/user_model.dart';


/**
 * This class holds the widget that allows users to register their information and use the app.
 */
class registrationPage extends StatefulWidget {
  const registrationPage({Key? key}) : super(key: key);

  @override
  State<registrationPage> createState() => _RegPageState();
}

class _RegPageState extends State<registrationPage> {
  bool showJoinGroup = false;

  //controllers for text entered by user
  final _userName = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _userName.dispose();
    super.dispose();
  }

  Future registerAccount() async {
    if (passwordsMatch()) {
      try {
        final user = UserModel(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            userName: _userName.text.trim());
       // FirebaseFirestore.instance
        //More code about database
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        setState(() {
          showJoinGroup = true;
        });
      } on FirebaseAuthException catch(e) {
        //Error Message
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("The email is already taken"),
              );
            });
      }
    } else {
      //Error Message
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Passwords didn't match"),
            );
          });
    }
  }

  bool passwordsMatch() {
    return (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    if (showJoinGroup) {
      return joinGroupPage();
    } else {
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),

                // Username textbox
                SizedBox(height: 10),
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
                        controller: _userName,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.account_circle,
                            color: Colors.blue,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          hintText: 'Username',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
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

                SizedBox(height: 10),
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

                // Confirm password textbox
                SizedBox(height: 10),
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

                // Sign up button.
                SizedBox(height: 20),
                Container(
                  // decoration: BoxDecoration(color: Colors.green[300]),
                  width: 180.0,
                  height: 40.0,
                  child: ElevatedButton(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      //side: BorderSide(color: Colors.white)
                    ))),
                    onPressed: () {
                      if (_emailController.text.isEmpty ||
                          _confirmPasswordController.text.isEmpty ||
                          _emailController.text.isEmpty) {
                        Get.snackbar(
                          "Required",
                          "All fields are required.",
                          snackPosition: SnackPosition.TOP,
                        );
                      } else {
                        registerAccount();
                      }
                    },
                  ),
                ),

                // Return to login button.
                SizedBox(height: 20),
                Container(
                  // decoration: BoxDecoration(color: Colors.green[300]),
                  width: 180.0,
                  height: 40.0,
                  child: ElevatedButton(
                    child: Text(
                      'Back to Login',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      //side: BorderSide(color: Colors.white)
                    ))),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                ),
              ],
            )),
          ));
    }
  }
}
