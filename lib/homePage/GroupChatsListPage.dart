import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/ChatRoom/ChatRoomController.dart';
import 'package:roommates/homePage/ChatPage.dart';
import 'package:get/get.dart';
import 'package:roommates/themeData.dart';
import '../Group/groupController.dart';
import '../Task/database_demo.dart';
import '../User/user_controller.dart';

class GroupChatsListPage extends StatefulWidget {
  const GroupChatsListPage({Key? key}) : super(key: key);

  @override
  State<GroupChatsListPage> createState() => _messagingPage();
}

// https://docs.flutter.dev/cookbook/lists/mixed-list

// https://medium.flutterdevs.com/creating-stateful-dialog-form-in-flutter-c619e9ec864

// https://www.youtube.com/watch?v=Fd5ZlOxyZJ4&ab_channel=RetroPortalStudio

class _messagingPage extends State<GroupChatsListPage> {

  final _db = Get.put(DBHelper());

  /// groupController
  final _groupController = Get.put(groupController());
  final userController userCon = userController();
  ///chatRoomController
  final _chatRoomController = Get.put(ChatRoomController());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Future<String> futureThemeColor;
  late Future<String> futureThemeBrightness;
  late String themeColor;
  late String themeBrightness;
  late Future< List<String>> FutureGroupchatTitles;
  // Different group chat information.
  late List<String> groupchatTitles = [];
  late List<String> groupchatLastMessage = [
    "Hey what's up, guys?",
    "Hey Andrew, can you take out the trash?",
    "Bob, please take a shower.",
    "",
    "",
    "",
  ];

  // names of people in group

  late List<bool> addPeopleYesOrNo = List.filled(peopleInGroup.length, false);
  late Future<List<String>> futurePeopleInGroup;
  late Future<List<String>> futurePeopleinGroupIDs;
  late Future<Map<String, String>> futureGroupInfo;


  // inverse of group Info, chat title is the key and chatID is value
  late Map<String, String>groupInfoInv;
  late List<bool> addPeopleYesOrNo1;
  late List<String> peopleInGroup;
  late List<String> peopleInGroupIDs;
  late Map<String, String> groupInfo;


  // Idea is to pass a unique groupchat ID from GroupChatsListPage.dart to ChatPage.dart.
  // ChatPage.dart will then use this groupchat ID to pull relevant data from firebase instead of trying to send a million things at once within this class.
  late List<String> groupChatUniqueIDs = ["0", "1", "2"];

  // Text controller for adding new chat pop-up.
  final TextEditingController _newChatNameController = TextEditingController();

  // Method that currently adds titles and list item body manually. TODO: Implement firebase to show different messages.
  void addItemToList() {
    setState(() {
      if (_newChatNameController.text.isEmpty) {
        groupchatTitles.insert(0, "New Chat");
      }
      else {
        groupchatTitles.insert(0, _newChatNameController.text);
      }
      groupchatLastMessage.insert(0, "");
      groupChatUniqueIDs.insert(0, "Requires new ID");
    });
  }


  ///
  /// This method creates a new chat
  ///
  void createGroupChat(List<String> receiverIds, String title) async {
    String? uID = FirebaseAuth.instance.currentUser?.uid;
    _chatRoomController.createChatRoom(uID!, receiverIds, title);
  }

  ///
  /// This method creates the list users to select from and their ids
  ///
  // void buildGroupChatList() async {
  //   //user id
  //   String? uID = FirebaseAuth.instance.currentUser?.uid;
  //   peopleInGroup = await _groupController.getUsersInGroup(uID!);
  //   peopleinGroupIDs = await _groupController.getUserIDsInGroup(uID!);
  //   groupInfo = await _chatRoomController.getGroupInfo(uID);
  //   groupInfoInv = groupInfo.map((k,v) => MapEntry(v, k));
  //
  // }

  ///
  /// This method fills the list of groupChatTitles
  ///
  // Future<List<String>> buildGroupChatTitles() async {
  //   String? uID = FirebaseAuth.instance.currentUser?.uid;
  //   return await _chatRoomController.getGroupChatTitles(uID!);
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String? uID = FirebaseAuth.instance.currentUser?.uid;
    futureThemeBrightness = userCon.getUserThemeBrightness(uID!);
    futureThemeColor = userCon.getUserThemeColor(uID);
    FutureGroupchatTitles = _chatRoomController.getGroupChatTitles(uID);

    futurePeopleInGroup =  _groupController.getUsersInGroup(uID);
    futurePeopleinGroupIDs =  _groupController.getUserIDsInGroup(uID);
    futureGroupInfo = _chatRoomController.getGroupInfo(uID);
    //groupInfoInv = groupInfo.map((k,v) => MapEntry(v, k));
  }
  // Method that deletes the chat from the list.
  // Should this be replaced to leave chat?
  // Should you only be able to leave chats once you're inside the ChatPage?
  // TODO: Figure this out...
  void deleteItemFromList(index) {
    setState(() {
      // Remove user from the groupchat.

      groupchatTitles.removeAt(index);
      groupchatLastMessage.removeAt(index);
    });
  }

  Future<void> showCreateNewGroupChatAlertDialog(BuildContext context) async {
    return await showDialog(context: context, builder: (context) {
      // Replaced textEditingController with _newChatNameController.
      // final TextEditingController textEditingController = TextEditingController();
      bool? isChecked = false;

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
              onPressed: () {
                // If text input is empty or not valid or no group members are selected, don't let it proceed.
                // Switch over to ChatPage.
                if (formKey.currentState!.validate() &&
                    _newChatNameController.text.isNotEmpty &&
                    addPeopleYesOrNo.contains(true)) {
                  addItemToList();
                  List<String> receiverids = [];
                  for (int i = 0; i < addPeopleYesOrNo.length; i++) {
                    if (addPeopleYesOrNo[i]) {
                      receiverids.add(peopleInGroupIDs[i]);
                    }
                  }
                  createGroupChat(receiverids, _newChatNameController.text);
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (
                      context) =>  ChatPage(
                      receiverUserName: peopleInGroup.toString(),
                      receiverUserIDs: receiverids)),);
                }

                // TODO: Need some way to warn user that at least one checkbox needs to be checked.

              },
            ),
          ],
        );
      });
    });
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([FutureGroupchatTitles, futureThemeBrightness, futureThemeColor,
          futurePeopleInGroup, futurePeopleinGroupIDs, futureGroupInfo]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) return Container();
          groupchatTitles = snapshot.data[0];
          themeBrightness = snapshot.data[1];
          themeColor = snapshot.data[2];
          peopleInGroup = snapshot.data[3];
          peopleInGroupIDs = snapshot.data[4];
          groupInfo = snapshot.data[5];
          groupInfoInv = groupInfo.map((k,v) => MapEntry(v, k));

          print("groupInfo : $groupInfo");
          print("people in group : $peopleInGroup");
          print("people in Group IDS : $peopleInGroupIDs");

          return MaterialApp(
              theme: showOption(themeBrightness),
              home: Scaffold(

                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: setBackGroundBarColor(themeBrightness)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  backgroundColor:setAppBarColor(themeColor, themeBrightness),
                  title: const Text("Messaging"),
                ),
                backgroundColor: const Color.fromARGB(255, 227, 227, 227),

                body: ListView.separated(
                  // Let the ListView know how many items it needs to build.
                  itemCount: groupchatTitles.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (context, index) {
                    return ListTile(

                      // If you click on a tile, it will send you to the ChatPage.
                      onTap: () {
                        // Delete later.

                        String title = groupchatTitles[index];
                        String? chatID = groupInfoInv[title];
                        String? uID = FirebaseAuth.instance.currentUser?.uid;
                        print("title: $title");
                        print("groupInfo$groupInfo");
                        print("groupInfoInv$groupInfoInv");
                        print("uID : $uID");
                        print("chatID$chatID");
                        List<String> receiverids = _chatRoomController.getUserInChatID(uID!, chatID!);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(receiverUserName: peopleInGroup.toString(),
                                    receiverUserIDs: receiverids)));
                      },

                      //tileColor: Colors.orange,
                      leading: CircleAvatar(
                        // TODO: Let color be a choice when creating a new chat?
                        // Might be too hard... make the color random?
                        backgroundColor: const Color(0xff764abc),
                        child: Text(groupchatTitles[index][0]),
                      ),
                      title: Text(groupchatTitles[index]),
                      //subtitle: Text(groupchatLastMessage[index]),
                      //trailing: const Icon(Icons.more_vert),
                      trailing: GestureDetector(
                          onTap: () {
                            // Opens pop-up window asking if you want to delete this chat.
                            // print("Working..."); Works.

                            showDialog(context: context, builder: (context) {
                              // set up the buttons
                              Widget continueButton = ElevatedButton(
                                child: const Text("Delete"),
                                onPressed: () {
                                  // print("Need to delete chat...");
                                  deleteItemFromList(index);
                                  Navigator.of(context).pop();
                                },
                              );
                              Widget cancelButton = ElevatedButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              );

                              return AlertDialog(
                                scrollable: true,
                                title: const Text("Delete Chat?"),
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

                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),

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
                    }, child: const Icon(Icons.add)),
              )
          );
        });
  }
}



//   return Scaffold(
//     appBar: AppBar(
//         backgroundColor: Colors.orange[700],
//         title: const Text("Messaging"),
//     ),
//     backgroundColor:  const Color.fromARGB(255, 227, 227, 227),
//
//     body: ListView.separated(
//       // Let the ListView know how many items it needs to build.
//       itemCount: groupchatTitles.length,
//       // Provide a builder function. This is where the magic happens.
//       // Convert each item into a widget based on the type of item it is.
//       itemBuilder: (context, index) {
//         return ListTile(
//
//           // If you click on a tile, it will send you to the ChatPage.
//           onTap: () {
//
//             // Delete later.
//             // This is how each group's ID will be determined and sent.
//             print(groupChatUniqueIDs[index]);
//
//             Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(receiverUserEmail: "dummyEmail@gmail.com", receiverUserID: "dum1234", groupChatID: groupChatUniqueIDs[index],)));
//           },
//
//           //tileColor: Colors.orange,
//           leading: CircleAvatar(
//             // TODO: Let color be a choice when creating a new chat?
//             // Might be too hard... make the color random?
//             backgroundColor: const Color(0xff764abc),
//             child: Text(groupchatTitles[index][0]),
//           ),
//           title: Text(groupchatTitles[index]),
//           subtitle: Text(groupchatLastMessage[index]),
//           //trailing: const Icon(Icons.more_vert),
//           trailing: GestureDetector(
//             onTap: (){
//               // Opens pop-up window asking if you want to delete this chat.
//               // print("Working..."); Works.
//
//               showDialog(context: context, builder: (context) {
//
//                 // set up the buttons
//                 Widget continueButton = ElevatedButton(
//                   child: const Text("Delete"),
//                   onPressed:  () {
//                     // print("Need to delete chat...");
//                     deleteItemFromList(index);
//                     Navigator.of(context).pop();
//                   },
//                 );
//                 Widget cancelButton = ElevatedButton(
//                   child: const Text("Cancel"),
//                   onPressed:  () {
//                     Navigator.of(context).pop();
//                   },
//                 );
//
//                 return AlertDialog(
//                   scrollable: true,
//                   title: const Text("Delete Chat?"),
//                   actions: [
//                     continueButton,
//                     cancelButton,
//                   ],
//                 );
//               });
//
//             },
//             child: const Icon(Icons.more_vert)
//           ),
//         );
//       },
//
//       padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//
//       separatorBuilder: (context, index) { // <-- SEE HERE
//         return const Divider();
//       },
//     ),
//
//     // Button to add a new chat.
//     floatingActionButton: FloatingActionButton(onPressed: () async {
//
//       // show a dialog for user to input event name
//       await showCreateNewGroupChatAlertDialog(context);
//
//     }, child: const Icon(Icons.add)),
//   );
// }


/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}