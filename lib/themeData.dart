import 'package:flutter/material.dart';
//Default is light

ThemeData showOption(String themeBrightness) {
  if (themeBrightness == "Dark") {
    return ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          background: Colors.black,
          primary: Colors.grey[900]!,
          secondary: Colors.grey[800]!,
        )
    );
  }else{
    return  ThemeData(
      brightness: Brightness.light,
    );
  }
}

