import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class registerationPage extends StatelessWidget {
  const registerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "route",
      home: Scaffold(
        appBar: AppBar(title: Text("Registeration Page"),),
        body: Center(
          child: ElevatedButton(
            child: Text("Go Back"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

}