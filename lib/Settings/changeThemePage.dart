
//Blance, accountInformation,register page, user_model

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:roommates/User/user_model.dart';

import '../themeData.dart';
class changeTheme extends StatefulWidget {
  const changeTheme({Key? key}) : super(key: key);

  @override
  State<changeTheme> createState() => _changeTheme();
}
class _changeTheme extends State<changeTheme> {
  ColorLabel? selectedColor;
  String? _selectedTheme;
  String username = "";
  String password = "";
  String email = "";
  String balance = "";
  String income = "";
  String expense = "";
  String groupID = "";
  List<String>? chatRooms;
  String imageURL = "";
  String? color = "";


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
        themeColor: colorController.text.trim(),
        themeBrightness: themeController.text.trim(),
    );

    await FirebaseFirestore.instance.collection("Users").doc(userID).update(
        user.toJson());

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
    var checkTheme = _selectedTheme;
    var checkColor = color;
    String themeBrightness = "";
    String themeColor = "";
    if(checkTheme!=null && checkColor!=null){
      themeBrightness = checkTheme;
      themeColor= checkColor;
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final List<DropdownMenuEntry<ColorLabel>> colorEntries =
    <DropdownMenuEntry<ColorLabel>>[];
    for (final ColorLabel color in ColorLabel.values) {
      colorEntries.add(
        DropdownMenuEntry<ColorLabel>(
            value: color, label: color.label),
      );
    }
    List<DropdownMenuEntry<String>> ThemeList = [
    const DropdownMenuEntry<String>(value: "Light", label:"Light"),
    const DropdownMenuEntry<String>(value: "Dark", label:"Dark"),
    ];
    return MaterialApp(
        theme: showOption(themeBrightness),
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: setAppBarColor(themeColor, themeBrightness),
       leading: IconButton(
         icon: Icon(Icons.arrow_back, color: Colors.white),
         onPressed: () => Navigator.of(context).pop(),
       ),
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
                  initialSelection: ColorLabel.blue,
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
                Text('Theme Brightness', style: TextStyle(fontSize: 20),),
                SizedBox(width: 20,),
                DropdownMenu<String>(
                  controller: themeController,
                  initialSelection: "Light",
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
                  updateUserData();
                  },
                  style:ElevatedButton.styleFrom(
                     backgroundColor: setAppBarColor(themeColor, themeBrightness),side: BorderSide.none, shape: const StadiumBorder()
                  ) ,
                  child: const Text(
                    "Save",style: TextStyle(color:Colors.white),
                  ),
                )
            ),
          ],
      ),
    )
    );
  }
}
enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  purple('Purple', Colors.purple),
  red('Red', Colors.red);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}