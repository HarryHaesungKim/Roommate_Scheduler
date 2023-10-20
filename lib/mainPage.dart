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
import 'strings.dart';

class mainPage extends StatefulWidget {
  @override
  _mainPageState createState() => _mainPageState();


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

  @override
  void initState() {
    super.initState();
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
          title = "Cost Split";
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
    getUserData();
    return Scaffold(
      // Don't need appbar for mainPage.dart. Each page will have it's own appbar.
      //appBar: AppBar(
      //    backgroundColor: Colors.orange[700],
      //    title: Text(returnPageTitle(_selectedIndex))
      //),
      backgroundColor: setBackGroundBarColor(themeBrightness),
      body: screens[_selectedIndex],
      // body: Center(
      //   child: _widgetOptions.elementAt(_selectedIndex),
      // ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: setAppBarColor(color, themeBrightness),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor:transparent(color, themeBrightness),
              hoverColor: transparent(color, themeBrightness),
              gap: 3,
              activeColor: setBackGroundBarColor(themeBrightness),
              iconSize: 25,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: deep(color, themeBrightness),
              color: setBackGroundBarColor(themeBrightness),
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
                  text: "Cost Split",
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
