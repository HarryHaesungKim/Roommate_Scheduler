import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:roommates/calendarPage.dart';
import 'package:roommates/groceriesPage.dart';
import 'package:roommates/homePage.dart';
import 'package:roommates/notificationPage.dart';
import 'package:roommates/profilePage.dart';


class mainPage extends StatefulWidget {
  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  final screens = [
    homePage(),
    calendarPage(),
    groceriesPage(),
    notificationPage(),
    profilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[_selectedIndex],
      // body: Center(
      //   child: _widgetOptions.elementAt(_selectedIndex),
      // ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
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
              rippleColor: Colors.grey.shade800,
              hoverColor: Colors.grey.shade700,
              gap: 3,
              activeColor: Colors.black,
              iconSize: 25,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey.shade800,
              color: Colors.white,
              tabs: const [
                GButton(icon:Icons.home, text: "Home",),
                GButton(icon:Icons.calendar_month, text: "Calendar",),
                GButton(icon:Icons.money, text: "Groceries",),
                GButton(icon:Icons.notifications, text: "Notification",),
                GButton(icon:Icons.account_circle, text: "Profile",),
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