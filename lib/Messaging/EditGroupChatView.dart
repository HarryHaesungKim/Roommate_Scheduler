import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roommates/Messaging/GroupChatsListPageUpdated.dart';

import '../Group/groupController.dart';
import '../User/user_controller.dart';
import '../themeData.dart';
import 'ChatPage.dart';
import 'MessagingController.dart';
import 'chat_service.dart';

class EditGroupChatView extends StatefulWidget {
  final String chatID;
  final String chatTitle;

  const EditGroupChatView({
    super.key,
    required this.chatID,
    required this.chatTitle,
  });

  @override
  State<EditGroupChatView> createState() => EditGroupChatPage();
}

class EditGroupChatPage extends State<EditGroupChatView> {
  // The current user.
  String? uID = FirebaseAuth.instance.currentUser?.uid;

  // Map of members IDs and username.
  late Map<String, String> iDNameMap = {};

  // Controllers.
  final groupController groupCon = groupController();
  final userController userCon = userController();
  final MessagingController messagingCon = MessagingController();
  final ChatService chatServiceCon = ChatService();

  // Key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Future data
  late Future<String> futureThemeColor;
  late Future<String> futureThemeBrightness;
  late Future<List<String>> futurePeopleInGroup;
  late Future<List<String>> futurePeopleInGroupIDs;
  late Future<bool> futureIsOwner;
  late Future<List<dynamic>> futurePeopleInGroupChat;

  // Data extracted from the future.
  late String themeColor;
  late String themeBrightness;
  late List<String> peopleInGroup;
  late List<String> peopleInGroupIDs;
  late bool isOwner;
  late List<String> peopleInGroupChat;

  // Text controller for editing the title.
  final TextEditingController _editTitleTextController =
      TextEditingController();

  // Whether or not to enable text field. Unused.
  // bool _isEnable = false;

  // bool list of people who are in the chat.
  List<bool> areTheyInThisChat = [];

  // bool list of people who are in the chat before user changed anything.
  List<bool> areTheyInThisChatOriginally = [];

  @override
  void initState() {
    super.initState();
    futureThemeColor = userCon.getUserThemeColor(uID!);
    futureThemeBrightness = userCon.getUserThemeBrightness(uID!);
    futurePeopleInGroup = groupCon.getUsersInGroup(uID!);
    futurePeopleInGroupIDs = groupCon.getUserIDsInGroup(uID!);
    futureIsOwner = messagingCon.isUserTheOwner(widget.chatID, uID);
    futurePeopleInGroupChat = messagingCon.getGroupChatMembers(widget.chatID);
  }

  @override
  Widget build(BuildContext context) {
    _editTitleTextController.text = widget.chatTitle;

    return FutureBuilder(
        future: Future.wait([
          futureThemeColor,
          futureThemeBrightness,
          futurePeopleInGroup,
          futurePeopleInGroupIDs,
          futureIsOwner,
          futurePeopleInGroupChat,
        ]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // If the snapshot has an error.
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          }

          // If the snapshot has meaningful data.
          else if (snapshot.hasData) {

            // Getting Theme data.
            themeColor = snapshot.data[0];
            themeBrightness = snapshot.data[1];

            // Getting group data.
            peopleInGroup = snapshot.data[2];
            peopleInGroupIDs = snapshot.data[3];

            // Is the current user the owner?
            isOwner = snapshot.data[4];

            // Getting the people who are currently apart of this chat.
            peopleInGroupChat = snapshot.data[5].cast<String>();

            // Mapping IDs to UserNames (since they are done in order).
            for (var i = 0; i < peopleInGroupIDs.length; i++) {
              iDNameMap[peopleInGroupIDs[i]] = peopleInGroup[i];
            }

            // Creating a bool checklist for adding people.
            areTheyInThisChat = List.filled(peopleInGroupIDs.length, false);

            // Setting the checklist depending on who is or isn't already apart of the chat.
            for (String chatMember in peopleInGroupChat) {
              int i = 0;
              for (String groupMember in peopleInGroupIDs) {
                if (chatMember == groupMember) {
                  areTheyInThisChat[i] = true;
                }
                i++;
              }
            }

            // Saving who was originally in this chat.
            areTheyInThisChatOriginally = List.from(areTheyInThisChat);

            return MaterialApp(
                home: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: setBackGroundBarColor(themeBrightness)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                backgroundColor: setAppBarColor(themeColor, themeBrightness),
                title: const Text("Edit Group Chat"),
              ),

              // backgroundColor: const Color.fromARGB(255, 227, 227, 227),
              body: Column(
                children: [
                  // Spacing.
                  const SizedBox(
                    height: 40,
                  ),

                  // The little circle picture thing on each group chat tile.
                  CircleAvatar(
                    backgroundColor: const Color(0xff764abc),
                    minRadius: 45,
                    child: Text(
                        style: const TextStyle(
                          fontSize: 40,
                        ),
                        widget.chatTitle[0]),
                  ),

                  // Spacing.
                  const SizedBox(
                    height: 10,
                  ),

                  // Adds a button next to the form to edit the text.

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //
                  //     // Spacing.
                  //     const SizedBox(width: 50,),
                  //
                  //     // Edit title form field.
                  //     IntrinsicWidth(
                  //
                  //       // width: 280.0,
                  //
                  //       //alignment: Alignment.center,
                  //       child: TextFormField(
                  //         textAlign: TextAlign.center,
                  //         controller: _editTitleTextController,
                  //         enabled: _isEnable,
                  //         validator: (value) {
                  //           return value!.isNotEmpty ? null : "Invalid Field";
                  //         },
                  //         decoration: const InputDecoration(
                  //           hintText: "Enter a title.",
                  //           // border: InputBorder.none,
                  //           // focusedBorder: InputBorder.none,
                  //           // enabledBorder: InputBorder.none,
                  //           // errorBorder: InputBorder.none,
                  //           // disabledBorder: InputBorder.none,
                  //           // hintText: widget.chatTitle,
                  //           // isDense: false,
                  //           // contentPadding: EdgeInsets.symmetric(horizontal: 11, vertical: 0),
                  //           // errorText: "Need a title",
                  //         ),
                  //         style: GoogleFonts.lato(
                  //           textStyle: const TextStyle(
                  //               fontSize: 20,
                  //               fontWeight: FontWeight.bold,
                  //               //color: Colors.white
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //
                  //     // Edit button
                  //     IconButton(
                  //         icon: const Icon(Icons.edit),
                  //         onPressed: () {
                  //           setState(() {
                  //             _isEnable = true;
                  //           });
                  //         })
                  //
                  //   ],
                  // ),

                  // Edit title form field.
                  IntrinsicWidth(
                    // width: 280.0,

                    //alignment: Alignment.center,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _editTitleTextController,
                      // enabled: _isEnable,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Invalid Field";
                      },
                      decoration: const InputDecoration(
                        hintText: "Enter a title.",
                        // border: InputBorder.none,
                        // focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        // errorBorder: InputBorder.none,
                        // disabledBorder: InputBorder.none,
                        // hintText: widget.chatTitle,
                        // isDense: false,
                        // contentPadding: EdgeInsets.symmetric(horizontal: 11, vertical: 0),
                        // errorText: "Need a title",
                      ),
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          //color: Colors.white
                        ),
                      ),
                    ),
                  ),

                  // Spacing.
                  const SizedBox(
                    height: 24,
                  ),

                  // Text
                  isOwnerMessage(isOwner),

                  // Spacing.
                  const SizedBox(
                    height: 10,
                  ),

                  // Checklist of group members in chat.
                  // Checklist
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      // Can change color.
                      // color: const Color.fromARGB(255, 227, 227, 227),
                      child: SizedBox(
                        width: 270,
                        height: 150,
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 5,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: peopleInGroup.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (isOwner) {
                                return CheckboxListTile(
                                    value: areTheyInThisChat[index],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        areTheyInThisChat[index] = value!;
                                      });
                                    },
                                    enabled: enableSelfTile(
                                        peopleInGroupIDs[index], uID),
                                    title: Text(
                                        '${peopleInGroup[index]} ${textSelf(peopleInGroupIDs[index], uID)}'));
                              } else {
                                return CheckboxListTile(
                                    value: areTheyInThisChat[index],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        areTheyInThisChat[index] = value!;
                                      });
                                    },
                                    enabled: false,
                                    title: Text(
                                        '${peopleInGroup[index]} ${textSelf(peopleInGroupIDs[index], uID)}'));
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  }),

                  // Spacing.
                  const SizedBox(
                    height: 20,
                  ),

                  // Save changes
                  ElevatedButton(
                    onPressed: () {
                      // messagingCon.updateChat(
                      //     widget.chatID,
                      //     _editTitleTextController.text,
                      //     widget.groupChatMembers);

                      // Updating the chat.

                      List<String> updatedMembers = addOrRemoveMembersAndOrUpdateTitle(widget.chatID, _editTitleTextController.text, peopleInGroupChat);

                      // Go back to the chat page.
                      // Navigator.pop(context, _editTitleTextController.text);
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                        return ChatPage(groupChatMembers: updatedMembers, chatID: widget.chatID,);
                      }));

                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        //side: const BorderSide(color: Colors.red)
                      )),

                      backgroundColor: MaterialStateProperty.all(
                          setAppBarColor(themeColor, themeBrightness)),
                      //minimumSize: MaterialStateProperty.all(const Size(100, 40)),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                        //overflow: TextOverflow.ellipsis,
                      )),
                    ),
                    child: const Text("Save Changes"),
                  ),

                  // Spacing.
                  const SizedBox(
                    height: 10,
                  ),

                  // Select different owner.
                  ElevatedButton(
                    onPressed: selectNewOwnerEnableOrDisable() ? null : () {
                      showCreateNewGroupChatAlertDialog(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        //side: const BorderSide(color: Colors.red)
                      )),

                      backgroundColor: MaterialStateProperty.all(
                          setAppBarColor(themeColor, themeBrightness)),
                      //minimumSize: MaterialStateProperty.all(const Size(100, 40)),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                        //overflow: TextOverflow.ellipsis,
                      )),
                    ),
                    child: const Text("Select New Owner"),
                  ),

                  // Spacing.
                  const SizedBox(
                    height: 10,
                  ),

                  // Leave group.
                  ElevatedButton(
                    onPressed: () {

                      // Leave the chat and be taken back to the group chat page.
                      messagingCon.leaveChat(widget.chatID, uID);

                      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                        return const GroupChatsListPageUpdated(gotKicked: false);
                      }));
                      
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        //side: const BorderSide(color: Colors.red)
                      )),

                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      //minimumSize: MaterialStateProperty.all(const Size(100, 40)),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                        //overflow: TextOverflow.ellipsis,
                      )),
                    ),
                    child: const Text("Leave Chat"),
                  ),
                ],
              ),
            ));
          }

          // Show loading.
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  /// This method adds or removes people from the group when the 'Save Changes' button is pressed.
  List<String> addOrRemoveMembersAndOrUpdateTitle(chatID, newTitle, originalMembers) {

    Function eq = const ListEquality().equals;

    List<String> updatedMembers = [];
    int index = 0;

    // If the chat title has changed.
    if(widget.chatTitle != newTitle){
      chatServiceCon.sendMessage(originalMembers, 'Title has been changed to: $newTitle', chatID, true);
    }

    // Getting the updated people in this list.
    if (!listEquals(areTheyInThisChat, areTheyInThisChatOriginally)) {
      for (bool member in areTheyInThisChat) {
        if (member == true) {
          updatedMembers.add(peopleInGroupIDs[index]);
        }
        index++;
      }

      index = 0;
      // TODO: Letting chat know who was added or removed.
      for (bool member in areTheyInThisChat) {
        // If a member has been removed.
        if (member == false && areTheyInThisChatOriginally[index] == true) {
          chatServiceCon.sendMessage(originalMembers, '${iDNameMap[peopleInGroupIDs[index]]} has been removed.', chatID, true);
        }
        // Else if a member has been added.
        else if (member == true && areTheyInThisChatOriginally[index] == false) {
          chatServiceCon.sendMessage(originalMembers, '${iDNameMap[peopleInGroupIDs[index]]} has been added.', chatID, true);
        }
        index++;
      }

    }
    else{
      messagingCon.updateChat(chatID, newTitle, originalMembers);
      return originalMembers;
    }

    // Update the chat.
    messagingCon.updateChat(chatID, newTitle, updatedMembers);
    return updatedMembers;
  }

  String textSelf(id, uID) {
    if (id == uID) {
      return '(you)';
    }
    return '';
  }

  bool enableSelfTile(id, uID) {
    if (id == uID) {
      return false;
    }
    return true;
  }

  Widget isOwnerMessage(bool isOwner) {
    if (isOwner) {
      return // Text
          Column(
        children: [
          Text(
            "You are the group chat owner.",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),

          // Spacing.
          const SizedBox(
            height: 15,
          ),

          Text(
            "Add or remove members:",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                //color: Colors.white
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Text(
            "You are not the group chat owner.",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),

          // Spacing.
          const SizedBox(
            height: 15,
          ),

          Text(
            "Group Chat members:",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                //color: Colors.white
              ),
            ),
          ),
        ],
      );
    }
  }


  /// This method shows a new alert dialogue to select a new chat owner.
  Future<void> showCreateNewGroupChatAlertDialog(BuildContext context) async {

    List<String> peopleInGroupChatWithoutYou = List.from(peopleInGroupChat);
    peopleInGroupChatWithoutYou.remove(uID);

    List<bool> radioButtonsList = List.filled(peopleInGroupChatWithoutYou.length, false);

    int? id;

    String newOwner = '';

    return await showDialog(context: context, builder: (context) {

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

                    // Text
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select the new owner.",
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
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      // Can change color.
                      // color: const Color.fromARGB(255, 227, 227, 227),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200, minHeight: 56.0),
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 5,
                          child: ListView.separated(
                            separatorBuilder: (context, index) => const Divider(
                              color: Colors.grey,
                            ),
                            shrinkWrap: true,
                            itemCount: peopleInGroupChatWithoutYou.length,

                            itemBuilder: (BuildContext context, int index) {
                              return RadioListTile(
                                title: Text(iDNameMap[peopleInGroupChatWithoutYou[index]]!),
                                  value: index,
                                  groupValue: id,
                                  onChanged: (value) {
                                    setState(() {
                                      id = value;
                                      newOwner = peopleInGroupChatWithoutYou[index];
                                    });
                                  },
                              );
                            },
                          ),
                        ),

                      ),
                    ),

                    // Padding
                    const SizedBox(height: 20),

                    // Okay or cancel buttons
                    OverflowBar(
                      alignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                          width: 100,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              //padding: const EdgeInsets.all(16.0),
                              //textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: isAButtonSelected(id) ? null : () {

                              // Update firebase.
                              messagingCon.selectNewOwner(widget.chatID, newOwner);

                              // Send message that a new owner has been selected.
                              chatServiceCon.sendMessage([], '${iDNameMap[newOwner]} is now the owner.', widget.chatID, true);

                              // Exit the alert dialog.
                              Navigator.pop(context);

                              // Navigate back to the chat page.
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return ChatPage(groupChatMembers: peopleInGroupChat, chatID: widget.chatID,);
                              }));

                            },
                            child: const Text('Okay'),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 100,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red.shade600,
                                //padding: const EdgeInsets.all(16.0),
                                //textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);

                              }),
                        ),
                      ],
                    ),

                  ],
                ),
              )),


        );
      });
    });
  }

  bool selectNewOwnerEnableOrDisable() {
    if(peopleInGroupChat.length == 1 || !isOwner){
      return true;
    }
    return false;
  }

  bool isAButtonSelected(int? id) {
    if(id != null){
      return false;
    }
    else{
      return true;
    }
  }
}
