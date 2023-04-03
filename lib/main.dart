import 'package:flutter/material.dart';
import 'package:roommates/mainPage.dart';
import 'package:roommates/registrationPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key:key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home : LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key:key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                'Roommates',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:20
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
              SizedBox(height: 50),
              Container(
                // decoration: BoxDecoration(color: Colors.green[300]),
                width: 180.0,
                height: 40.0,

                child: ElevatedButton(
                    child: Text('Sign in',
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

              SizedBox(height:25),
              Container(
                // decoration: BoxDecoration(color: Colors.green[300]),
                width: 180.0,
                height: 40.0,
                child: ElevatedButton(
                  child: Text('Register now',
                    style: TextStyle(color:Colors.white,
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
                          )
                      )
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => registerationPage()));
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


