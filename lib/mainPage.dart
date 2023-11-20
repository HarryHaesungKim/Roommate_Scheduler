import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
//import 'package:roommates/calendarPage.dart';
import 'package:roommates/CostSplit/CostSplitView.dart';
import 'package:roommates/homePage/homePage.dart';
import 'package:roommates/Notifications/NotificationView.dart';
import 'package:roommates/profilePage.dart';
import 'package:roommates/themeData.dart';
import 'calendarPage/calendarPage.dart';

import 'package:roommates/api/firebase_api.dart';

class mainPage extends StatefulWidget {

  final int navigateToScreen;

  const mainPage({Key? key, required this.navigateToScreen}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();

}

class _mainPageState extends State<mainPage> {
  int _selectedIndex = 0;
  String themeBrightness = "";
  String color = "";

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  final screens = [
    homePage(),
    calendarPage(),
    CostSplitView(),
    NotificationView(),
    ProfilePage(),
  ];

  late int screenCopy;

  FirebaseApi pushNotifCon = FirebaseApi();

  @override
  void initState() {
    super.initState();
    screenCopy = widget.navigateToScreen;
    _selectedIndex = screenCopy;
    // print("Sent from mainPage.dart");

    // Initialize the entire notification stuff upon start up of the app.
    // Sends the token to firebase when the app itself is building up.
    // Will send regardless of if person is not signed in, or already is since main page needs to build.
    pushNotifCon.initNotifications();
  }

  Future getUserData() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if (user != null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();
      Map<String, dynamic> list = db.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          color = list['themeColor'];
          themeBrightness = list['themeBrightness'];
        });
      }
    }


  }
  String returnPageTitle(int index) {
    String title = "";
    switch (index) {
      case 0:
        {
          title = "Home";
        }
        break;
      case 1:
        {
          title = "Calender";
        }
        break;

      case 2:
        {
          title = "Split Pay";
        }
        break;

      case 3:
        {
          title = "Notifications";
        }
        break;

      case 4:
        {
          title = "Profile";
        }
        break;

      default:
        {
          title = "Error";
        }
        break;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([]),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
    return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('Users')
        .doc(currUser!)
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
        return Scaffold(
          backgroundColor: setBackGroundBarColor(UserData['themeBrightness']),
          body: screens[_selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 8),
                child: GNav(
                  rippleColor: transparent(UserData['themeColor'], UserData['themeBrightness']),
                  hoverColor: transparent(UserData['themeColor'], UserData['themeBrightness']),
                  gap: 3,
                  activeColor: setBackGroundBarColor( UserData['themeBrightness']),
                  iconSize: 25,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: deep(UserData['themeColor'],  UserData['themeBrightness']),
                  color: setBackGroundBarColor( UserData['themeBrightness']),
                  tabs: const [
                    GButton(
                      icon: Icons.home,
                      text: "Home",
                    ),
                    GButton(
                      icon: Icons.calendar_month,
                      text: "Calendar",
                    ),
                    GButton(
                      icon: Icons.money,
                      text: "Split Pay",
                    ),
                    GButton(
                      icon: Icons.notifications,
                      text: "Notification",
                    ),
                    GButton(
                      icon: Icons.account_circle,
                      text: "Profile",
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
                GButton(
                  icon: Icons.calendar_month,
                  text: "Calendar",
                ),
                GButton(
                  icon: Icons.money,
                  text: "Split Pay",
                ),
                GButton(
                  icon: Icons.notifications,
                  text: "Notification",
                ),
                GButton(
                  icon: Icons.account_circle,
                  text: "Profile",
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
