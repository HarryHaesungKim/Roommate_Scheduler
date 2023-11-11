import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:roommates/Messaging/EditGroupChatView.dart';
import 'package:roommates/Messaging/GroupChatsListPageUpdated.dart';
import 'package:roommates/Messaging/chat_bubble.dart';
import 'package:roommates/Messaging/chat_service.dart';
import 'package:roommates/themeData.dart';

import '../Group/groupController.dart';
import '../User/user_controller.dart';
import '../homePage/my_text_field.dart';
import 'GroupChatObject.dart';
import 'MessagingController.dart';

//https://stackoverflow.com/questions/50702749/flutter-i-want-to-pass-variable-from-one-class-to-another

//https://pub.dev/packages/flutter_chat_list

//https://pub.dev/packages/flutter_chat_ui

//https://www.youtube.com/watch?v=mBBycL0EtBQ&ab_channel=MitchKoko timestamp: 29:51

class ChatPage extends StatefulWidget {
  // Declare a field that holds the group chat data

  // from video
  final List<String> groupChatMembers;
  final String chatID;

  const ChatPage({
    super.key,
    required this.groupChatMembers,
    required this.chatID,
  });

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  String? uID = FirebaseAuth.instance.currentUser?.uid;
  final userController userCon = userController();
  late Future<String> futureThemeColor;
  late Future<String> futureThemeBrightness;
  late String themeColor;
  late String themeBrightness;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late String groupChatTitle;

  final MessagingController messagingCon = MessagingController();

  void sendMessage() async {
    // only send message if there is something to send.
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.groupChatMembers, _messageController.text, widget.chatID);
      // clear the text controller after sending the message.
      _messageController.clear();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureThemeBrightness = userCon.getUserThemeBrightness(uID!);
    futureThemeColor = userCon.getUserThemeColor(uID!);
  }

  // Getting the group chats from firebase.
  Stream<List<GroupChatObject>> readGroupChats() {
    // Get list of group chats that the current user is apart of.
    return FirebaseFirestore.instance
        .collection('Chats')
        .where('id', isEqualTo: widget.chatID)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GroupChatObject.fromJson(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    // groupChatTitle = widget.chatTitle;

    return FutureBuilder(
        future: Future.wait([futureThemeBrightness, futureThemeColor]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // If the snapshot has an error.
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          }

          // If the snapshot has meaningful data.
          if (snapshot.hasData) {
            themeBrightness = snapshot.data[0];
            themeColor = snapshot.data[1];
            // groupChatTitle = snapshot.data[2];

            return StreamBuilder(
                stream: readGroupChats(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong! ${snapshot.error}');
                  }

                  if (snapshot.hasData) {

                    // // If current user is no longer apart of the chat, navigate them back to the group chat list page.
                    // if (!snapshot.data![0].groupChatMembers.contains(uID)) {
                    //   WidgetsBinding.instance.addPostFrameCallback((_) =>
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => profile())
                    //   );
                    //
                    //   return const Center();
                    //
                    // }

                    if (!snapshot.data![0].groupChatMembers.contains(uID)){
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                            builder: (context) =>
                            const GroupChatsListPageUpdated(gotKicked: true)), (
                            route) => false);
                      });
                    }

                    groupChatTitle = snapshot.data![0].title;

                    return MaterialApp(
                      theme: showOption(themeBrightness),
                      home: Scaffold(
                        appBar: AppBar(
                          leading: IconButton(
                              icon: Icon(Icons.arrow_back,
                                  color:
                                      setBackGroundBarColor(themeBrightness)),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) {
                                  return const GroupChatsListPageUpdated(
                                    gotKicked: false,
                                  );
                                }));
                              }),
                          backgroundColor:
                              setAppBarColor(themeColor, themeBrightness),

                          // Needs to be title of the group chat!
                          title: Text(groupChatTitle),
                          actions: [
                            IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  // Bring up a new page to change the name, add more users, or delete the chat.
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditGroupChatView(
                                                chatID: widget.chatID,
                                                chatTitle: groupChatTitle,
                                              )));
                                  // if (context.mounted) {
                                  //   build(context);
                                  // }
                                  setState(() {});
                                }),
                          ],
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 227, 227, 227),
                        body: Column(children: [
                          //const SizedBox(height: 10,),

                          // messages
                          // REMOVE COMMENTS 81 - 83
                          Expanded(child: _buildMessageList()),

                          // user input
                          _buildMessageInput(),

                          const SizedBox(
                            height: 25,
                          ),
                        ]),
                      ),
                    );
                  }

                  // Show loading.
                  else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          }

          // Show loading.
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.chatID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    // Messages from you should be a different color than messages from others.
    var bubbleColor = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Colors.blue
        : Colors.grey.shade400;
    var textColor =
        (data['senderId'] == _firebaseAuth.currentUser!.uid) ? 0 : 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Container(
          alignment: alignment,
          child: Column(
              crossAxisAlignment:
                  (data['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              mainAxisAlignment:
                  (data['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(data['senderUserName']),
                const SizedBox(
                  height: 3,
                ),
                ChatBubble(
                    message: data['message'],
                    color: bubbleColor,
                    textColor: textColor),
              ])),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Row(
        children: [
          Expanded(
              child: MyTextField(
                  controller: _messageController,
                  hintText: 'Enter message',
                  obscureText: false)),

          // send button
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                size: 40,
              ))
        ],
      ),
    );
  }
}
