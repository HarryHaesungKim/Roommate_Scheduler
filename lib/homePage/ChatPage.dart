import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/homePage/chat_bubble.dart';
import 'package:roommates/homePage/chat_service.dart';

import 'message.dart';
import 'my_text_field.dart';

//https://stackoverflow.com/questions/50702749/flutter-i-want-to-pass-variable-from-one-class-to-another

//https://pub.dev/packages/flutter_chat_list

//https://pub.dev/packages/flutter_chat_ui

//https://www.youtube.com/watch?v=mBBycL0EtBQ&ab_channel=MitchKoko timestamp: 29:51

class ChatPage extends StatefulWidget {

  // Declare a field that holds the group chat data
  final String groupChatID;

  // from video
  final String receiverUserEmail;
  final String receiverUserID;

  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,

    // not in video
    required this.groupChatID,
  });

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {

  late List<String> messages = ["Hey Guys. How's it going?", "Not bad", "I'm good"];
  late List<String> whoSent = ["Me", "Andrew", "Bob"];
  late List<DateTime> timeSent = [DateTime.parse('2023-09-06 20:18:04Z'), DateTime.parse('2023-09-06 20:20:04Z'), DateTime.parse('2023-09-06 20:25:04Z')];

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there is something to send.
    if (_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserID, _messageController.text);
      // clear the text controller after sending the message.
      _messageController.clear();
    }
  }

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

          const SizedBox(height: 10,),

          // messages
          // REMOVE COMMENTS 81 - 83
          Expanded(
            child: _buildMessageList()
          ),

          // user input
          _buildMessageInput(),

          const SizedBox(height: 25,),
        ]
      ),
    );
  }

  // build message list
  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );

  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to the right if the sender is the current user, otherwise to the left.
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Text(data['senderEmail']),
          const SizedBox(height: 5,),
          ChatBubble(message: data['message']),
        ]
      )
    );
  }

  // build message input
  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
              child: MyTextField(
                  controller: _messageController,
                  hintText: 'Enter message',
                  obscureText: false
              )
          ),

          // send button
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                size: 40,
              )
          )
        ],
      ),
    );
  }

}