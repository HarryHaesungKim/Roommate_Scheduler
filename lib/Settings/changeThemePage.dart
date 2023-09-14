
//Blance, accountInformation,register page, user_model

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roommates/Task/input_field.dart';
import 'package:roommates/User/user_model.dart';
class changeTheme extends StatefulWidget {
  const changeTheme({Key? key}) : super(key: key);

  @override
  State<changeTheme> createState() => _changeTheme();
}
class _changeTheme extends State<changeTheme> {
  final TextEditingController colorController = TextEditingController();
  final TextEditingController themeController = TextEditingController();
  ColorLabel? selectedColor;
  @override
  Widget build(BuildContext context) {
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
    String? _selectedTheme = 'Default';
    List<DropdownMenuEntry<String>> ThemeList = [
    const DropdownMenuEntry<String>(value: "Default", label:"Default"),
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
                  initialSelection: ColorLabel.green,
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
                  initialSelection: _selectedTheme,
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
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}