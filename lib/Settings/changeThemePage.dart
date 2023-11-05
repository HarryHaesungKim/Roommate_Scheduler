
//Blance, accountInformation,register page, user_model

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:roommates/User/user_model.dart';

import '../User/user_controller.dart';
import '../themeData.dart';
class changeTheme extends StatefulWidget {
  const changeTheme({Key? key}) : super(key: key);

  @override
  State<changeTheme> createState() => _changeTheme();
}
class _changeTheme extends State<changeTheme> {
  ColorLabel? selectedColor;
  String? _selectedTheme;
  late Future<String> futureThemeColor;
  late Future<String> futureThemeBrightness;
  String themeColor = '';
  String themeBrightness = '';
  final userController userCon = userController();
  String? userID = FirebaseAuth.instance.currentUser?.uid;



  final TextEditingController colorController = TextEditingController();
  final TextEditingController themeController = TextEditingController();

  Future updateUserData(String email, String password, String userName,String balance, String income, String expense, String imageURL, String themeBrightness, String themeColor, List<String> chatRooms, GeoPoint? location, String groupID, ) async {
    final user = UserData(
      email: email,
      password: password,
      username: userName,
      balance: balance,
      income: income,
      expense: expense,
      imageURL: imageURL,
      themeBrightness: themeBrightness,
      themeColor: themeColor,
      groupID: groupID,
      chatRooms: chatRooms,
      location: location,
    );
    await FirebaseFirestore.instance.collection("Users").doc(userID).update(
        user.toJson());

  }
  @override
  void initState() {
    super.initState();
    futureThemeBrightness = userCon.getUserThemeBrightness(userID!);
    futureThemeColor = userCon.getUserThemeColor(userID!);
  }
  @override
  Widget build(BuildContext context) {

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
    return FutureBuilder(
        future: Future.wait([]),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userID!)
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
                      backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      title: const Text("Change Theme"),
                    ),
                    body: Column(
                      children: [
                        const SizedBox(height: 20,),
                        Row(
                          children:[
                            const SizedBox(width: 10,),
                            const Text('Theme Color', style: TextStyle(fontSize: 20),),
                            const SizedBox(width: 20,),
                            DropdownMenu<ColorLabel>(
                              controller: colorController,
                              initialSelection: ColorLabel.blue,
                              label: const Text('Color'),
                              dropdownMenuEntries: colorEntries,
                              onSelected: (ColorLabel? color) {
                                setState(() {
                                  colorController.text = color!.label;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children:[
                            const SizedBox(width: 10,),
                            const Text('Theme Brightness', style: TextStyle(fontSize: 20),),
                            const SizedBox(width: 20,),
                            DropdownMenu<String>(
                              controller: themeController,
                              initialSelection: "Light",
                              label: const Text('Theme'),
                              dropdownMenuEntries: ThemeList,
                              onSelected: (String? theme) {
                                setState(() {
                                  themeController.text = theme!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        SizedBox(width: width*0.5,
                            child: ElevatedButton(
                              onPressed: (){

                              updateUserData(UserData["Email"].toString(),UserData["Password"].toString(),UserData["UserName"].toString(),UserData["Balance"].toString(),UserData["Income"].toString(),UserData["Expense"].toString(),UserData["imageURL"],themeController.text.trim().toString(),colorController.text.trim().toString(),UserData["chatRooms"].cast<String>(),UserData["location"] ,UserData['groupID'].toString());

                              },
                              style:ElevatedButton.styleFrom(
                                  backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),side: BorderSide.none, shape: const StadiumBorder()
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
            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      );
    }
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