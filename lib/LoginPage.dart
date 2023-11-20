import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/forgotPassWordPage.dart';
import 'package:get/get.dart';
import 'package:roommates/joinGroupPage.dart';
import 'package:roommates/mainPage.dart';
import 'package:roommates/registrationPageCreatGroup.dart';

import 'Group/groupController.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText= true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _groupController = Get.put(groupController());

  late Future<bool> futureIsUserInGroup;

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const mainPage(navigateToScreen: 0,)));
    } on FirebaseAuthException catch (e) {
      //Error Message
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("You have entered an incorrect email or password"),
            );
          });
    }
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   String? uID = FirebaseAuth.instance.currentUser?.uid;
  //   futureIsUserInGroup = _groupController.isUserInGroup(uID!);
  //   }

  @override
  void dispose() {
    super.dispose();
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
                  Image.asset("images/logo.png", height: 100, width: 100,),
                  // Icon(
                  //   widget.icon
                  //   size: 100,
                  // ),
                  const Text(
                    'Roommates',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 15),
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
                          decoration: const InputDecoration(
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
                  const SizedBox(height: 15),
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
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(top: 14.0),
                              hintText: 'Password',
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.blue,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                    _obscureText ? Icons.visibility : Icons
                                        .visibility_off),
                              )

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
                                  return const ForgotPasswordPage();
                                }));
                          },
                          child: const Text(
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

                  const SizedBox(height: 50),
                  SizedBox(
                    // decoration: BoxDecoration(color: Colors.green[300]),
                    width: 180.0,
                    height: 40.0,

                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                //side: BorderSide(color: Colors.white)
                              ))),
                      onPressed: () async {
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
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ),

                  // Go to register page.
                  const SizedBox(height: 25),
                  SizedBox(
                    // decoration: BoxDecoration(color: Colors.green[300]),
                    width: 180.0,
                    height: 40.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                //side: BorderSide(color: Colors.white)
                              ))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (
                                    context) => const registrationPage()));
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
