import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roommates/Task/input_field.dart';
import 'package:get/get.dart';
import 'package:roommates/joinGroupPage.dart';

import '../Group/groupController.dart';
import '../User/user_controller.dart';
import '../themeData.dart';

class mangageGroupMember extends StatefulWidget {
  const mangageGroupMember({Key? key}) : super(key: key);

  @override
  State<mangageGroupMember> createState() => _mangageGroupMember();
}

class _mangageGroupMember extends State<mangageGroupMember> {

  final TextEditingController _accessCodeController = TextEditingController();
  final groupController _groupController = Get.put(groupController());
  final userController _userController = Get.put(userController());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _uID = FirebaseAuth.instance.currentUser?.uid;

  late List<String> peopleInGroup;
  late List<String> peopleInGroupID;
  late List<bool> addPeopleYesOrNo = List.filled(peopleInGroup.length, false);
  late String groupID;

  late bool isUseringroup;
  late bool isUserAdmin;
  late bool doesNewGroupExist;

  String themeBrightness = "";
  String themeColor = "";

  late Future<List<String>> futurePeopleInGroup;
  late Future<List<String>> futurePeopleInGroupID;
  late Future<String> futureGroupID;
  late Future<String> futureThemeBrightness;
  late Future<String> futureThemeColor;
  late Future<bool> futureIsUserInGroup;
  late Future<bool> futureIsUserAdmin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String? uID = FirebaseAuth.instance.currentUser?.uid;
    futureThemeBrightness = _userController.getUserThemeBrightness(uID!);
    futureThemeColor = _userController.getUserThemeColor(uID);
    futurePeopleInGroup =  _groupController.getUsersInGroup(uID);
    futureGroupID = _groupController.getGroupIDFromUser(uID);
    futurePeopleInGroupID = _groupController.getUserIDsInGroup(uID);
    futureIsUserInGroup = _groupController.isUserInGroup(uID);
    futureIsUserAdmin = _groupController.isUserAdmin(uID);
  }



  void setDoesNewGroupExist(String groupID) async {
    doesNewGroupExist = await _groupController.doesGroupExist(groupID);
  }

  void buildIsUserAdmin(String uID) async {
    isUserAdmin = await _groupController.isUserAdmin(uID);
  }


  void showNotAdminUserDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Okay"),
      onPressed: () {
        Navigator.pop(context, 'Okay');
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Not Admin User!"),
      content: const Text("You are not an admin user, cannot add admin users!"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// This method returns whether [groupID] is formatted correct
  /// the formatting being exactly 5 digits
  bool isGroupIDFormatted(String groupID) {
    final fiveDigit = RegExp(r'^\d{5}$');
    return fiveDigit.hasMatch(groupID);
  }

  Future<void> showAddAdminDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool? isChecked = false;

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Admin User(s)"),
              content: Form(
                  key: formKey,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                      title: Text(peopleInGroup[index]));
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
                    child: const Text("Add"),
                    onPressed: () {
                      // If text input is empty or not valid or no group members are
                      if (addPeopleYesOrNo.contains(true)) {
                        List<String> newAdminIDS = [];
                        for (int i = 0; i < addPeopleYesOrNo.length; i++) {
                          if (addPeopleYesOrNo[i]) {
                            newAdminIDS.add(peopleInGroupID[i]);
                          }
                        }
                        _groupController.addAdminUsers(newAdminIDS, groupID);
                      }
                    }),
              ],
            );
          });
        });
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context, 'Cancel');

        Get.snackbar("Canceled", "Leaving group has been canceled");
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () async {
        print("User ID at time if leaving is $_uID");
        await _groupController.removeUser(_uID!).whenComplete(
                () => Get.snackbar("Left Group", "You have left the group"));
        Navigator.pop(context, 'Continue');
        // take user back to the joinGroupPage
        //await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => const joinGroupPage())));
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Leave Group?"),
      content: const Text("Are you sure you want to leave your group?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlreadyInGroupDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Okay"),
      onPressed: () {
        Navigator.pop(context, 'Okay');
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Already in group!"),
      content: const Text("Leave current group before joining another group"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showGroupDoesNotExist(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Okay"),
      onPressed: () {
        Navigator.pop(context, 'Okay');
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Invalid group!"),
      content: const Text("Please enter an existing group code."),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showEmptyGroupIDDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Okay"),
      onPressed: () {
        Navigator.pop(context, 'Okay');
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Group Code Empty!"),
      content: const Text("Please enter a group code."),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showGroupIDNotFormatted(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Okay"),
      onPressed: () {
        Navigator.pop(context, 'Okay');
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Invalid group!"),
      content: const Text("Please enter a 5 digit group code."),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // buildNonAdminUsers();
    // isUserInGroup(_uID!);
    // buildIsUserAdmin(_uID!);
    // setDoesNewGroupExist(groupID);

    return FutureBuilder(
      future: Future.wait([futureThemeBrightness, futureThemeColor, futurePeopleInGroup,
        futureGroupID, futurePeopleInGroupID, futureIsUserInGroup, futureIsUserAdmin]),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(!snapshot.hasData) return Container();
        themeBrightness = snapshot.data[0];
        themeColor = snapshot.data[1];
        peopleInGroup = snapshot.data[2];
        groupID = snapshot.data[3];
        peopleInGroupID = snapshot.data[4];
        isUseringroup = snapshot.data[5];
        isUserAdmin = snapshot.data[6];
      return Scaffold(
        appBar: AppBar(
          backgroundColor: setAppBarColor(themeColor, themeBrightness),
          title: const Text("Group Member"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: setBackGroundBarColor(themeBrightness)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              SizedBox(
                width: 50,
                child: InputField(
                  title: "Group Code",
                  hint: "Enter your code",
                  controller: _accessCodeController,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 15,
                  child: ElevatedButton(
                    onPressed: () {
                      //check to see if the user is in a group first

                      setDoesNewGroupExist(_accessCodeController.text.trim());
                      if (isUseringroup) {
                        showAlreadyInGroupDialog(context);
                        return;
                      }
                      if (_accessCodeController.text.isEmpty) {
                        showEmptyGroupIDDialog(context);
                        return;
                      }
                      if (!isGroupIDFormatted(
                          _accessCodeController.text.trim())) {
                        showGroupIDNotFormatted(context);
                        return;
                      }

                      if (!doesNewGroupExist) {
                        showGroupDoesNotExist(context);
                        return;
                      }
                      _groupController.addUserToGroup(
                          _accessCodeController.text.trim(), _uID!);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        setAppBarColor(themeColor, themeBrightness),
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: const Text(
                      "Join Different Group",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 15,
                  child: ElevatedButton(
                    onPressed: () {
                      //Back-End from Groups database

                      //check if the user is already groupless
                      if (!(isUseringroup)) {
                        Get.snackbar("Error",
                            "You cannot leave group because you are not in a group!");
                        return;
                      }
                      showAlertDialog(context);
                      // provide a "Are you sure you want to leave prompt"

                      // if there is other users in the group and the group is
                      // in parentMode and this user is the only admin, make sure
                      // they make another member an admin before they leave,
                      // if they are the only member just let them leave group and
                      // delete group
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        setAppBarColor(themeColor, themeBrightness),
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: const Text(
                      "Leave Group",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 15,
                  child: ElevatedButton(
                    onPressed: () {
                      buildIsUserAdmin(_uID!);
                      //check if the current user is an admin user
                      if (isUserAdmin) {
                        showAddAdminDialog(context);
                      } else {
                        showNotAdminUserDialog(context);
                      }
                      //first check to see if this user is an admin use for the group

                      // IF the user is admin pull list of users in the group who are not admins
                      //have a list to select users and make them admins for the group
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        setAppBarColor(themeColor, themeBrightness),
                        side: BorderSide.none,
                        shape: const StadiumBorder()),
                    child: const Text(
                      "Add Admin Users",
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
            ],
          ),
        ),
      );
    });
  }


}
