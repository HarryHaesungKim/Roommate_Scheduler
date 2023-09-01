import 'package:flutter/material.dart';

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

  late List<String> groupchatTitles = ["The Boys", "Andrew", "Bob"];
  late List<String> groupchatLastMessage = ["Hey what's up, guys?", "Hey Andrew, can you take out the trash?", "Bob, please take a shower."];

  late List<String> peopleInGroup = ["Andrew", "Bob", "Eric", "Tate", "Henry"];
  late List<bool> addPeopleYesOrNo = List.filled(peopleInGroup.length, false);

  // Text controller for adding new chat pop-up
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

  //
  Widget selectPeopleAlertDialogContainer() {
    return SizedBox(
      //height: 300.0, // Change as per your requirement
      width: 200.0, // Change as per your requirement
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
    );
  }

  Future<void> showInformationDialog(BuildContext context) async {
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

                 // The checklist.
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     const Text("Choice Box"),
                     Checkbox(value: isChecked, onChanged: (checked){
                       setState(() {
                         isChecked = checked;
                       });
                     })
                   ],
                 )
               ],
             )),

         actions: <Widget>[
           TextButton(
             child: const Text("Okay"),
             onPressed: () {
               if(formKey.currentState!.validate()){
                 addItemToList();
                 Navigator.of(context).pop();
               }
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
                    child: const Text("Continue"),
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
        await showInformationDialog(context);

        // showDialog(context: context, builder: (context) {
        //   return AlertDialog(
        //     scrollable: true,
        //     title: const Text("Group Chat Name:"),
        //     content: TextField(
        //             controller: _newChatNameController,
        //           ),
        //
        //     actions: [
        //       ElevatedButton(
        //         onPressed: (){
        //           addItemToList();
        //           // Closes pop-up.
        //           Navigator.of(context).pop();
        //
        //           // TODO: Open a new alert dialog that has a list of your group mates to add to the chat.
        //           showDialog(context: context, builder: (context) {
        //             return AlertDialog(
        //               title: const Text("Select members: "),
        //               content: StatefulBuilder(
        //                 builder: (BuildContext context, StateSetter setState) {
        //                   return selectPeopleAlertDialogContainer();
        //                 },
        //
        //               ),
        //
        //             );
        //           });
        //
        //         },
        //         child: const Text("Create Chat"),
        //       )
        //     ],
        //   );
        // });

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