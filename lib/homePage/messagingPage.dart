import 'package:flutter/material.dart';
import 'package:roommates/homePage/ChatPage.dart';

class messagingPage extends StatefulWidget {
  messagingPage({Key? key}) : super(key: key);

  @override
  State<messagingPage> createState() => _messagingPage();
}

// https://docs.flutter.dev/cookbook/lists/mixed-list

// https://medium.flutterdevs.com/creating-stateful-dialog-form-in-flutter-c619e9ec864

// https://www.youtube.com/watch?v=Fd5ZlOxyZJ4&ab_channel=RetroPortalStudio

class _messagingPage extends State<messagingPage> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Different group chat information.
  late List<String> groupchatTitles = ["The Boys", "Andrew", "Bob"];
  late List<String> groupchatLastMessage = ["Hey what's up, guys?", "Hey Andrew, can you take out the trash?", "Bob, please take a shower."];

  late List<String> peopleInGroup = ["Andrew", "Bob", "Eric", "Tate", "Henry"];
  late List<bool> addPeopleYesOrNo = List.filled(peopleInGroup.length, false);
  
  // Idea is to pass a unique groupchat ID from messagingPage.dart to ChatPage.dart.
  // ChatPage.dart will then use this groupchat ID to pull relevant data from firebase instead of trying to send a million things at once within this class.
  late List<String> groupChatUniqueIDs = ["0", "1", "2"];
  
  // Text controller for adding new chat pop-up.
  final TextEditingController _newChatNameController = TextEditingController();

  // Method that currently adds titles and list item body manually. TODO: Implement firebase to show different messages.
  void addItemToList(){
    setState(() {
      if (_newChatNameController.text.isEmpty){
        groupchatTitles.insert(0,"New Chat");
      }
      else{
        groupchatTitles.insert(0,_newChatNameController.text);
      }
      groupchatLastMessage.insert(0, "");
      groupChatUniqueIDs.insert(0, "Requires new ID");
    });
  }

  // Method that deletes the chat from the list.
  // Should this be replaced to leave chat?
  // Should you only be able to leave chats once you're inside the ChatPage?
  // TODO: Figure this out...
  void deleteItemFromList(index){
    setState(() {
      groupchatTitles.removeAt(index);
      groupchatLastMessage.removeAt(index);
    });
  }

  Future<void> showCreateNewGroupChatInformationDialog(BuildContext context) async {
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
                     validator: (value){
                       return value!.isNotEmpty ? null : "Invalid Field";
                     },
                     decoration: const InputDecoration(hintText: "Enter title"),
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
               if(formKey.currentState!.validate() && _newChatNameController.text.isNotEmpty && addPeopleYesOrNo.contains(true)){
                 addItemToList();
                 Navigator.of(context).pop();
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage(groupChatID: "Requires New ID.",)),);
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

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange[700],
          title: const Text("Messaging"),
      ),
      backgroundColor:  const Color.fromARGB(255, 227, 227, 227),

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
              // This is how each group's ID will be determined and sent.
              print(groupChatUniqueIDs[index]);

              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupChatID: groupChatUniqueIDs[index],)));
            },

            //tileColor: Colors.orange,
            leading: CircleAvatar(
              // TODO: Let color be a choice when creating a new chat?
              // Might be too hard... make the color random?
              backgroundColor: const Color(0xff764abc),
              child: Text(groupchatTitles[index][0]),
            ),
            title: Text(groupchatTitles[index]),
            subtitle: Text(groupchatLastMessage[index]),
            //trailing: const Icon(Icons.more_vert),
            trailing: GestureDetector(
              onTap: (){
                // Opens pop-up window asking if you want to delete this chat.
                // print("Working..."); Works.

                showDialog(context: context, builder: (context) {

                  // set up the buttons
                  Widget continueButton = ElevatedButton(
                    child: const Text("Delete"),
                    onPressed:  () {
                      // print("Need to delete chat...");
                      deleteItemFromList(index);
                      Navigator.of(context).pop();
                    },
                  );
                  Widget cancelButton = ElevatedButton(
                    child: const Text("Cancel"),
                    onPressed:  () {
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
      floatingActionButton: FloatingActionButton(onPressed: () async {

        // show a dialog for user to input event name
        await showCreateNewGroupChatInformationDialog(context);

      }, child: const Icon(Icons.add)),
    );
  }
}

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