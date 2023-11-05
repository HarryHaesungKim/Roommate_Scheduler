import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roommates/themeData.dart';
import 'package:roommates/settingsPage.dart';
import 'package:get/get.dart';
import 'Group/groupController.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _profilePage();
}

//Edit profile page
class _profilePage extends State<ProfilePage> {
  final bool _password = true;
  final groupController _groupController = Get.put(groupController());
  //String isAdmin = "";
  final _uID = FirebaseAuth.instance.currentUser?.uid;
  late bool gotIsGroupAdmin;
  late bool isAdmin;
  late Future<bool> isGroupAdmin;
  late Future<bool> isFutureAdmin;
  final groupController groupCon = groupController();
  String? currUser = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isGroupAdmin = groupCon.isGroupAdminModeByID(currUser!);
    isFutureAdmin = groupCon.isUserAdmin(currUser!);
  }

  @override
  Widget build(BuildContext context) {
   return FutureBuilder(
     future: Future.wait([isGroupAdmin, isFutureAdmin]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        // If there's no error and the snapshot has data.
        if (snapshot.hasData) {
          //return Text("GroupCode: ${snapshot.data}");=

          // Setting the groupID.
          gotIsGroupAdmin = snapshot.data[0];
          isAdmin = snapshot.data[1];
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(_uID)
                .snapshots(),
            builder: (context, snapshot) {
              // If there's an error.
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.data}');
              }
              // If there's no error and the snapshot has data.
              else if (snapshot.hasData) {
                // Setting the task data.
                final UserData = snapshot.data!;
                // Building the widget.
                return MaterialApp(
                  theme: showOption(UserData['themeBrightness']),
                  home: Scaffold(
                    appBar: AppBar(
                      backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']), //appbar
                      title: const Text("Profile"),
                      actions: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const settingsProfile()),
                                );
                              },
                              child: const Icon(Icons.settings),
                            )),
                      ],
                    ),
                    body: Container(
                      padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: ListView(
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 4, color: Colors.white),
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 2,
                                              blurRadius: 10,
                                              color: Colors.black.withOpacity(0.1))
                                        ],
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(UserData['imageURL']),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),
                            Form(
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                      label: const Text("Full Name"),
                                      labelStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                      hintText: UserData['UserName'],
                                      enabled: false,
                                      hintStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      prefixIcon:
                                      const Icon(Icons.people, color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: UserData['Email'],
                                      enabled: false,
                                      labelStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                      hintStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                      label: const Text("Email"),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      label: const Text("Group Code"),
                                      labelStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                      hintText: UserData['groupID'],
                                      enabled: false,
                                      hintStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      prefixIcon:
                                      const Icon(Icons.people, color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      label: const Text("Admin Mode"),
                                      labelStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                      hintText: gotIsGroupAdmin.toString(),
                                      enabled: false,
                                      hintStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      prefixIcon:
                                      const Icon(Icons.people, color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      label: const Text("Admin User"),
                                      labelStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                      hintText: isAdmin.toString(),
                                      enabled: false,
                                      hintStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      prefixIcon:
                                      const Icon(Icons.people, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              // Loading.
              else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },

          );
        }
        // If there's an error.
        else if (snapshot.hasError) {
          return Text("Something went wrong! ${snapshot.error}");
        }

        // Loading.
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

