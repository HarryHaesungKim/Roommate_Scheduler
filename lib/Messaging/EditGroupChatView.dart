
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Group/groupController.dart';
import '../User/user_controller.dart';
import '../themeData.dart';
import 'MessagingController.dart';

class EditGroupChatView extends StatefulWidget {

  final List<String> groupMembers;
  final String chatID;
  final String chatTitle;

  const EditGroupChatView({
    super.key,
    required this.groupMembers,
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

  // Text controller for editing the title.
  final TextEditingController _editTitleTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureThemeColor = userCon.getUserThemeColor(uID!);
    futureThemeBrightness = userCon.getUserThemeBrightness(uID!);
    futurePeopleInGroup =  groupCon.getUsersInGroup(uID!);
    futurePeopleInGroupIDs =  groupCon.getUserIDsInGroup(uID!);
  }

  @override
  Widget build(BuildContext context) {

    _editTitleTextController.text = widget.chatTitle;

    return FutureBuilder(
      future: Future.wait([futureThemeColor, futureThemeBrightness, futurePeopleInGroup, futurePeopleInGroupIDs]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        // If the snapshot has an error.
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        }

        // If the snapshot has meaningful data.
        else if (snapshot.hasData) {


          themeColor = snapshot.data[0];
          themeBrightness = snapshot.data[1];

          return MaterialApp(
              home: Scaffold(
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
                    const SizedBox(height: 40,),

                    // The little circle picture thing on each group chat tile.
                    CircleAvatar(
                      backgroundColor: const Color(0xff764abc),
                      minRadius: 45,
                      child: Text(
                        style: const TextStyle(
                          fontSize: 40,
                        ),
                          widget.chatTitle[0]
                      ),
                    ),

                    // Spacing.
                    const SizedBox(height: 10,),

                    // Edit title form field.
                    Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _editTitleTextController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter a title.",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          // hintText: widget.chatTitle,
                          // isDense: false,
                          // contentPadding: EdgeInsets.symmetric(horizontal: 11, vertical: 0),
                          // errorText: "Need a title",
                        ),
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              //color: Colors.white
                          ),
                        ),
                      ),
                    ),

                    // Spacing.
                    const SizedBox(height: 10,),



                    ElevatedButton(
                      onPressed: () {
                        // TODO: Save the changes made to the chat.
                        messagingCon.updateChat(widget.chatID, _editTitleTextController.text, widget.groupMembers);

                        // Go back to the chat page.
                        Navigator.pop(context, _editTitleTextController.text);
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              //side: const BorderSide(color: Colors.red)
                              )
                        ),

                        backgroundColor: MaterialStateProperty.all(setAppBarColor(themeColor, themeBrightness)),
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

                  ],
                ),

              )


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
}