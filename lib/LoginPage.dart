import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/homePage/homePage.dart';
import 'package:roommates/joinGroupPage.dart';
import 'package:roommates/forgotPassWordPage.dart';
import 'package:get/get.dart';
import 'package:roommates/mainPage.dart';
import 'package:roommates/registrationPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      if (Navigator.of(context).pushReplacement(
        // If you're logging in from an existing account, you should already be in a group
        // You should be able to change your group in the settings page.
          MaterialPageRoute(builder: ((context) => mainPage()))) != null) {}
      ;
    }on FirebaseAuthException catch(e){
      //Error Message
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("You have entered an incorrect email or password"),
            );
          });
    }
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                'Roommates',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      controller: emailController,
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
                      controller: passwordController,
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ForgotPasswordPage();
                        }));
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 50),
              Container(
                // decoration: BoxDecoration(color: Colors.green[300]),
                width: 180.0,
                height: 40.0,

                child: ElevatedButton(
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    //side: BorderSide(color: Colors.white)
                  ))),
                  onPressed: () {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      Get.snackbar(
                        "Required",
                        "All fields are required.",
                        snackPosition: SnackPosition.TOP,
                      );
                    } else {
                      signIn();
                    }
                  },
                ),
              ),

              // Go to register page.
              SizedBox(height: 25),
              Container(
                // decoration: BoxDecoration(color: Colors.green[300]),
                width: 180.0,
                height: 40.0,
                child: ElevatedButton(
                  child: Text(
                    'Register now',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    //side: BorderSide(color: Colors.white)
                  ))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => registrationPage()));
                  },
                ),
              ),
            ],
          )),
        ));
  }
}
