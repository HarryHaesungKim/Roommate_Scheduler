
import 'package:flutter/material.dart';
import 'package:roommates/Task/task.dart';

import '../Task/input_field.dart';
class VotingPage extends StatefulWidget {
  const VotingPage({Key? key}) : super(key: key);

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: const Text("Voting Task"),
      ),
    );
  }
}
