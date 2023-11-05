import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passWordreset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                  "The forgot password process was attempted for your email, and please check your email!"),
            );
          });
    } on FirebaseAuthException {
      //Error message
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("You have entered an incorrect email"),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Please submit to reset your password.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          MaterialButton(
            onPressed: () {
              if (_emailController.text.isEmpty) {
                Get.snackbar(
                  "Required",
                  "All fields are required.",
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else {
                passWordreset();
              }
            },
            textColor: Colors.white,
            color: Colors.blue,
            child: const Text('Reset Password'),
          )
        ],
      ),
    );
  }
}
