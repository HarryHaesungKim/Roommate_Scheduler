import 'package:flutter/material.dart';
//Default is light



ThemeData showOption(String themeBrightness) {
  if (themeBrightness == "Dark") {
    return ThemeData(
        brightness: Brightness.dark,
    );
  }else{
    return  ThemeData(
      brightness: Brightness.light,
    );
  }
}
Color? setAppBarColor(String themeColor, String themeBrightness){
  if (themeColor == "Blue" && themeBrightness == "Light") {
    return Colors.blue[700];
  }
  if (themeColor == "Pink" && themeBrightness == "Light") {
    return Colors.pink[700];
  }
  if (themeColor == "Green" && themeBrightness == "Light") {
    return Colors.green[700];
  }
  if (themeColor == "Yellow" && themeBrightness == "Light") {
    return Colors.yellow[700];
  }
  if (themeColor == "Orange" && themeBrightness == "Light") {
    return Colors.orange[700];
  }
  if (themeColor == "Purple" && themeBrightness == "Light") {
    return Colors.purple[700];
  }
  if (themeColor == "Red" && themeBrightness == "Light") {
    return Colors.red;
  }
  return Colors.grey[700];
}
Color? setBackGroundBarColor(String themeBrightness){
  if (themeBrightness == "Light") {
    return Colors.white;
  }
  return Colors.black54;
}
Color transparent(String themeColor, String themeBrightness){
  if (themeColor == "Blue"  && themeBrightness == "Light" ){
    return Colors.blue.shade300;
  }
  if (themeColor == "Pink" && themeBrightness == "Light" ) {
    return Colors.pink.shade300;
  }
  if (themeColor == "Green" && themeBrightness == "Light") {
    return Colors.green.shade300;
  }
  if (themeColor == "Purple" && themeBrightness == "Light") {
    return Colors.purple.shade300;
  }
  if (themeColor == "Yellow" && themeBrightness == "Light") {
    return  Colors.yellow.shade300;
  }
  if (themeColor == "Orange" && themeBrightness == "Light") {
    return Colors.orange.shade300;
  }
  if (themeColor == "Red" && themeBrightness == "Light") {
    return Colors.red.shade300;
  }
  return Colors.grey.shade300;
}
Color deep(String themeColor, String themeBrightness){
  if (themeColor == "Blue"  && themeBrightness == "Light" ){
    return Colors.blue.shade500;
  }
  if (themeColor == "Pink" && themeBrightness == "Light" ) {
    return Colors.pink.shade500;
  }
  if (themeColor == "Green" && themeBrightness == "Light") {
    return Colors.green.shade500;
  }
  if (themeColor == "Yellow" && themeBrightness == "Light") {
    return Colors.yellow.shade500;
  }
  if (themeColor == "Orange" && themeBrightness == "Light") {
    return  Colors.orange.shade500;
  }
  if (themeColor == "Purple" && themeBrightness == "Light") {
    return Colors.purple.shade500;
  }
  if (themeColor == "Red" && themeBrightness == "Light") {
    return Colors.red.shade500;
  }
  return  Colors.grey.shade500;
}

