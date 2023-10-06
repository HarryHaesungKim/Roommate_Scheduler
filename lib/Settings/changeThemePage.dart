
//Blance, accountInformation,register page, user_model

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:roommates/User/user_model.dart';
class changeTheme extends StatefulWidget {
  const changeTheme({Key? key}) : super(key: key);

  @override
  State<changeTheme> createState() => _changeTheme();
}
class _changeTheme extends State<changeTheme> {
  ColorLabel? selectedColor;
  String? _selectedTheme = 'Light';
  String username = "";
  String password = "";
  String email = "";
  String balance = "";
  String income = "";
  String expense = "";
  String groupID = "";
  List<String>? chatRooms;
  String imageURL = "";
  String? color;

  Future updateUserData() async {
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    final user = UserData(
        email:email,
        password:password,
        username:username,
        balance:balance,
        income:income,
        expense:expense,
        groupID:groupID,
        chatRooms:chatRooms,
        imageURL:imageURL,
        themeColor: color,
      themeBrightness: themeController.text.trim(),
    );

    await FirebaseFirestore.instance.collection("Users").doc(userID).update(
        user.toJson());

  }
  Future getUserData() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    color = selectedColor?.label.toString();
    if (user != null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();
      Map<String, dynamic> list = db.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          username = list['UserName'];
          password = list['Password'];
          email = list['Email'];
          balance = list['Balance'];
          income = list['Income'];
          expense = list['Expense'];
          groupID = list['groupID'];
          chatRooms = list['chatRooms'];
          imageURL = list['imageURL'];
          color = list['themeColor'];
          _selectedTheme = list['themeBrightness'];
        });
      }
    }
  }
  final TextEditingController colorController = TextEditingController();
  final TextEditingController themeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    getUserData();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final List<DropdownMenuEntry<ColorLabel>> colorEntries =
    <DropdownMenuEntry<ColorLabel>>[];
    for (final ColorLabel color in ColorLabel.values) {
      colorEntries.add(
        DropdownMenuEntry<ColorLabel>(
            value: color, label: color.label, enabled: color.label != 'Grey'),
      );
    }
    List<DropdownMenuEntry<String>> ThemeList = [
    const DropdownMenuEntry<String>(value: "Light", label:"Light"),
    const DropdownMenuEntry<String>(value: "Dark", label:"Dark"),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],

        title: const Text("Change Theme"),
      ),
      body: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              children:[
                SizedBox(width: 10,),
                Text('Theme Color', style: TextStyle(fontSize: 20),),
                SizedBox(width: 20,),
                DropdownMenu<ColorLabel>(
                  controller: colorController,
                  label: const Text('Color'),
                  dropdownMenuEntries: colorEntries,
                  onSelected: (ColorLabel? color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
              ],

            ),
            SizedBox(height: 20,),
            Row(
              children:[
                SizedBox(width: 10,),
                Text('Theme', style: TextStyle(fontSize: 20),),
                SizedBox(width: 73,),
                DropdownMenu<String>(
                  controller: themeController,
                  label: const Text('Theme'),
                  dropdownMenuEntries: ThemeList,
                  onSelected: (String? theme) {
                    setState(() {
                      _selectedTheme = theme;
                    });
                  },
                ),
              ],

            ),

            SizedBox(height: 50),
            SizedBox(width: width*0.5,
                child: ElevatedButton(
                  onPressed: (){
                  },
                  style:ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,side: BorderSide.none, shape: const StadiumBorder()
                  ) ,
                  child: const Text(
                    "Change background",style: TextStyle(color:Colors.white),
                  ),
                )
            ),
            SizedBox(width: width*0.5,
                child: ElevatedButton(
                  onPressed: (){
                  },
                  style:ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,side: BorderSide.none, shape: const StadiumBorder()
                  ) ,
                  child: const Text(
                    "Change Front Size",style: TextStyle(color:Colors.white),
                  ),
                )
            ),
            SizedBox(width: width*0.5,
                child: ElevatedButton(
                  onPressed: (){
                  updateUserData();
                  },
                  style:ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,side: BorderSide.none, shape: const StadiumBorder()
                  ) ,
                  child: const Text(
                    "Save",style: TextStyle(color:Colors.white),
                  ),
                )
            ),
          ],
      ),


    );
  }

}
enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  grey('Grey', Colors.black);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}