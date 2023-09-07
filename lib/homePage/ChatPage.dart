import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//https://stackoverflow.com/questions/50702749/flutter-i-want-to-pass-variable-from-one-class-to-another

//https://pub.dev/packages/flutter_chat_list

//https://pub.dev/packages/flutter_chat_ui

//https://www.youtube.com/watch?v=mBBycL0EtBQ&ab_channel=MitchKoko timestamp: 29:51

class ChatPage extends StatefulWidget {

  // Declare a field that holds the group chat data
  final String groupChatID;

  const ChatPage({
    Key? key,
    required this.groupChatID,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {

  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Send message
  Future<void> sendMessage(String receiverID, String message) async {
    // get current user info

    // create a new message

    // construct chat room id from current user id and receiver id (sorted to ensure uniqueness).

    // add new message to database

  }

  // Get message


  late List<String> messages = ["Hey Guys. How's it going?", "Not bad", "I'm good"];
  late List<String> whoSent = ["Me", "Andrew", "Bob"];
  late List<DateTime> timeSent = [DateTime.parse('2023-09-06 20:18:04Z'), DateTime.parse('2023-09-06 20:20:04Z'), DateTime.parse('2023-09-06 20:25:04Z')];

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);



  @override
  Widget build(BuildContext context) {

    String groupChatID = widget.groupChatID;
    
    print('The group chat ID is: $groupChatID');
    
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.orange[700],

        // Needs to be title of the group chat!
        title: const Text("Messaging"),
      ),
      backgroundColor:  const Color.fromARGB(255, 227, 227, 227),


      body: Column(

        children: [

          // messages
          // REMOVE COMMENTS 81 - 83
          // Expanded(
          //   child: _buildMassageList()
          // ),

          // user input
          // REMOVE COMMENT 86
          //_buildMessageInput();

        ]
      ),
    );
  }
}

// build message list

// build message item

// build message input
// REMOVE COMMENTS 101 - 122
// Widget _buildMessageInput(){
//   return Row(
//     children: [
//       Expanded(
//           child: MyTextField(
//             controller: _messageController,
//             hintText: 'Enter message',
//             obscureText: false
//           )
//       ),
//
//       // send button
//       IconButton(
//           onPressed: sendMessage,
//           icon: const Icon(
//             Icons.arrow_upward,
//             size: 40,
//           )
//       )
//     ],
//   );
// }