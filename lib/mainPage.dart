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
import 'User/user_controller.dart';
import 'calendarPage/calendarPage.dart';

class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  _mainPageState createState() => _mainPageState();


}

class _mainPageState extends State<mainPage> {
  int _selectedIndex = 0;
  final userController userCon = userController();
  String? currUser = FirebaseAuth.instance.currentUser?.uid;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  final screens = [
    const homePage(),
    const calendarPage(),
    const CostSplitView(),
    const NotificationView(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
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
              ),
            ),
          ),
        );
      }
      else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    }
    );
    }
    else if (snapshot.hasError) {
    return Text("Something went wrong! ${snapshot.error}");
    }
    else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    },
    );
  }
}
