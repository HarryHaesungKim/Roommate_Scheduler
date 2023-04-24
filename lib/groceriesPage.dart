import 'package:flutter/material.dart';
// @dart=2.9
class groceriesPage extends StatefulWidget {
  groceriesPage({Key? key}) : super(key: key);

  @override
  State<groceriesPage> createState() => _groceriesPage();
}

class _groceriesPage extends State<groceriesPage> {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 227, 227, 227),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text('Groceries Page',
            style: optionStyle,),
        ),
      ),
    );
  }
}