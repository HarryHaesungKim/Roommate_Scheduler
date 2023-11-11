import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:roommates/Messaging/GroupChatObject.dart';
import 'package:roommates/Messaging/MessagingController.dart';
import 'package:roommates/mainPage.dart';
import '../Group/groupController.dart';
import '../User/user_controller.dart';
import '../themeData.dart';
import 'ChatPage.dart';

import 'package:get/get.dart';

class GroupChatsListPageUpdated extends StatefulWidget {

  final bool gotKicked;

  //const GroupChatsListPageUpdated({Key? key}) : super(key: key);
  const GroupChatsListPageUpdated({
    super.key,
    required this.gotKicked,
  });

  @override
  State<GroupChatsListPageUpdated> createState() => _messagingPage();

}

class _messagingPage extends State<GroupChatsListPageUpdated> {

  // The current user.
  String? uID = FirebaseAuth.instance.currentUser?.uid;

  // Map of members IDs and username.
  late Map<String, String> iDNameMap = {};

  // Controllers.
  final groupController groupCon = groupController();
  final userController userCon = userController();
  final MessagingController messagingCon = MessagingController();

  // Key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Future data
  late Future<String> futureThemeColor;
  late Future<String> futureThemeBrightness;
  late Future<List<String>> futurePeopleInGroup;
  late Future<List<String>> futurePeopleInGroupIDs;

  // Data extracted from the future.
  late String themeColor;
  late String themeBrightness;
  late List<String> peopleInGroup;
  late List<String> peopleInGroupIDs;

  // names of people in group
  late List<bool> addPeopleYesOrNo = [];

  // Text controller for adding new chat pop-up.
  final TextEditingController _newChatNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureThemeColor = userCon.getUserThemeColor(uID!);
    futureThemeBrightness = userCon.getUserThemeBrightness(uID!);
    futurePeopleInGroup =  groupCon.getUsersInGroup(uID!);
    futurePeopleInGroupIDs =  groupCon.getUserIDsInGroup(uID!);
  }

  // Getting the group chats from firebase.
  Stream<List<GroupChatObject>> readGroupChats() {

    // Get list of group chats that the current user is apart of.
    return FirebaseFirestore.instance
        .collection('Chats').where('groupChatMembers', arrayContains: uID)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => GroupChatObject.fromJson(doc.data()))
        .toList());
  }

  void showAlert(BuildContext context) {

    Widget cancelButton = TextButton(
      child: const Text("Okay"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Kicked!"),
      content: const Text("You have been removed from the chat."),
      actions: [
        cancelButton,
      ],
    );

    showDialog(
        context: context,
        builder: (context) => alert,
    );

  }

  @override
  Widget build(BuildContext context) {

    // if(widget.gotKicked) {
    //   SchedulerBinding.instance.addPostFrameCallback((_) {
    //     //Future.delayed(Duration.zero, () => showAlert(context));
    //     showAlert(context);
    //   });
    // }

    // When trying to show an alert dialog after user has been kicked, errors pop up. Why?

    return FutureBuilder(
        future: Future.wait([futureThemeColor, futureThemeBrightness, futurePeopleInGroup, futurePeopleInGroupIDs]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

          // Get.snackbar("ERROR", "Whoops, something went wrong.");
          // showAlertDialog(context);

          // If the snapshot has an error.
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          }

          // If the snapshot has meaningful data.
          else if (snapshot.hasData) {

            // Theme feature information.
            themeColor = snapshot.data[0];
            themeBrightness = snapshot.data[1];

            // Current group information.
            peopleInGroup = snapshot.data[2];
            peopleInGroupIDs = snapshot.data[3];

            // Mapping IDs to UserNames (since they are done in order).
            for (var i = 0; i < peopleInGroupIDs.length; i++) {
              iDNameMap[peopleInGroupIDs[i]] = peopleInGroup[i];
            }

            // Deleting the current user from the group
            peopleInGroup.remove(iDNameMap[uID!]);
            peopleInGroupIDs.remove(uID!);

            // Creating a bool checklist for adding people.
            addPeopleYesOrNo = List.filled(peopleInGroupIDs.length, false);

            // For testing
            // print("groupInfo : $groupInfo");
            // print("people in group excluding current user : $peopleInGroup");
            // print("people in Group IDs excluding current user : $peopleInGroupIDs");

            // Creating the group chats list in a stream builder to update in real time.
            return StreamBuilder(
                stream: readGroupChats(),
                builder: (context, snapshot) {

                  // If the snapshot from the stream has an error.
                  if (snapshot.hasError) {
                    return Text('Something went wrong! ${snapshot.error}');
                  }

                  // If the snapshot from the stream has meaningful data.
                  else if (snapshot.hasData) {

                    // The group chat objects.
                    var groupChats = snapshot.data!;

                    groupChats.sort((a, b) => b.lastSentMessageTime.compareTo(a.lastSentMessageTime));

                    return MaterialApp(
                      theme: showOption(themeBrightness),
                      home: Scaffold(
                        appBar: AppBar(
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back, color: setBackGroundBarColor(themeBrightness)),
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                              return const mainPage();
                            })),
                          ),
                          backgroundColor:setAppBarColor(themeColor, themeBrightness),
                          title: const Text("Messaging"),
                        ),
                        backgroundColor: const Color.fromARGB(255, 227, 227, 227),
                        body: ListView.separated(

                          // Let the ListView know how many items it needs to build.
                          itemCount: groupChats.length,
                          itemBuilder: (context, index) {
                            return ListTile(

                              // If you click on a tile, it will send you to the ChatPage.
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        ChatPage(
                                          groupChatMembers: groupChats[index].groupChatMembers,
                                          chatID: groupChats[index].id,
                                        )
                                ));
                              },

                              // The little circle picture thing on each group chat tile.
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xff764abc),
                                child: Text(groupChats[index].title[0]),
                              ),

                              // Group chat title
                              title: Text(groupChats[index].title),

                              subtitle: Text(
                                groupChats[index].lastSentMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              // Three dots button at the end of the group chat tile.
                              trailing: GestureDetector(
                                  onTap: () {
                                    showDialog(context: context, builder: (context) {

                                      // set up the buttons
                                      Widget continueButton = ElevatedButton(
                                        child: const Text("Delete"),
                                        onPressed: () {
                                          // print("Need to delete chat...");
                                          messagingCon.deleteChat(groupChats[index].id);
                                          Navigator.of(context).pop();
                                        },
                                      );
                                      Widget cancelButton = ElevatedButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      );

                                      // Call the alert dialogue.
                                      return AlertDialog(
                                        scrollable: true,
                                        title: const Text("Delete Chat?"),
                                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                                        actions: [
                                          continueButton,
                                          cancelButton,
                                        ],
                                      );
                                    });
                                  },
                                  child: const Icon(Icons.more_vert)
                              ),
                            );
                          },

                          // Padding for each tile.
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),

                          // Divider between tiles.
                          separatorBuilder: (context, index) { // <-- SEE HERE
                            return const Divider();
                          },
                        ),

                        // Button to add a new chat.
                        floatingActionButton: FloatingActionButton(
                            backgroundColor: setAppBarColor(themeColor, themeBrightness),
                            onPressed: () async {

                              // show a dialog for user to input event name
                              await showCreateNewGroupChatAlertDialog(context);
                            }, child: const Icon(Icons.add)
                        ),
                      ),
                    );
                  }

                  // Show loading.
                  else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
            );
          }

          // Show loading.
          else{
            return const Center(
                child: CircularProgressIndicator(),
            );
          }
        }
    );

  }
  
  /// This method shows a new alert dialogue to create a new group chat.
  Future<void> showCreateNewGroupChatAlertDialog(BuildContext context) async {
    return await showDialog(context: context, builder: (context) {

      // Clears input field upon every pop-up.
      _newChatNameController.clear();

      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text("Create New Group Chat"),
          content: Form(
              key: formKey,
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Group chat title input.
                    TextFormField(
                      controller: _newChatNameController,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Invalid Field";
                      },
                      decoration: const InputDecoration(
                          hintText: "Enter title"),
                    ),

                    // Padding
                    const SizedBox(height: 30),

                    // Text
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Group Members",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    // Padding
                    const SizedBox(height: 20),

                    // Checklist
                    Container(
                      // Can change color.
                      color: const Color.fromARGB(255, 227, 227, 227),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 150,
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 5,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: peopleInGroup.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CheckboxListTile(
                                  value: addPeopleYesOrNo[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      addPeopleYesOrNo[index] = value!;
                                    });
                                  },
                                  title: Text(peopleInGroup[index])
                              );
                            },
                          ),
                        ),

                      ),
                    ),

                  ],
                ),
              )),

          actions: <Widget>[
            TextButton(
              child: const Text("Okay"),
              onPressed: () async {

                // If title text input is empty or not valid or no group members are selected, don't let it proceed.
                if (formKey.currentState!.validate() &&
                    _newChatNameController.text.isNotEmpty &&
                    addPeopleYesOrNo.contains(true)) {

                  List<String> receiverids = [];
                  for (int i = 0; i < addPeopleYesOrNo.length; i++) {
                    if (addPeopleYesOrNo[i]) {
                      receiverids.add(peopleInGroupIDs[i]);
                    }
                  }

                  // Adding in the current user.
                  receiverids.add(uID!);

                  // Creating a new group chat and getting it's ID.
                  String chatID = await messagingCon.createChatRoom(uID!, receiverids, _newChatNameController.text, '');

                  // Avoids annoying "Do not use BuildContexts across async gaps" warning.
                  if (context.mounted){
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        ChatPage(
                          groupChatMembers: receiverids, 
                          chatID: chatID,
                        )
                    ),);
                  }
                }
              },
            ),
          ],
        );
      });
    });
  }

}