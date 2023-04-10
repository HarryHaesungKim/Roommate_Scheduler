import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

import 'mainPage.dart';

class registerationPage extends StatelessWidget {
  const registerationPage({super.key});

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
                    color: Colors.blue,
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
                        padding: const EdgeInsets.only(left:12.0),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                            border:InputBorder.none,
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
                        padding: const EdgeInsets.only(left:12.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border:InputBorder.none,
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
                        padding: const EdgeInsets.only(left:12.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border:InputBorder.none,
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
                        style: TextStyle(color:Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',),),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                //side: BorderSide(color: Colors.white)
                              )
                          )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => mainPage()));
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