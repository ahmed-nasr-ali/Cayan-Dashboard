// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = UserData.getUserMode() == ""
      ? ThemeMode.light
      : ThemeMode.dark; // theme of our app

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void changeTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  String? _currentLang;

  void setCurrentLanguage(String currentLang) {
    _currentLang = currentLang;
    notifyListeners();
  }

  String get currentLang => _currentLang!;
}

class MyThemes {
  static final lightTheme = ThemeData(
      primaryColor: mainAppColor,
      hintColor: hintColor,
      brightness: Brightness.light,
      buttonColor: mainAppColor,
      scaffoldBackgroundColor: Color(0xffFFFFFF),
      fontFamily: 'RB',
      appBarTheme: AppBarTheme(color: mainAppColor),
      canvasColor: Colors.transparent,
      textTheme: TextTheme(
        // app bar style
        headline1: TextStyle(
            color: mainAppColor, fontSize: 16, fontWeight: FontWeight.w500),

        // app bar with black text

        headline2: TextStyle(
            fontFamily: 'RB',
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w500),

        headline3: TextStyle(
            color: accentColor, fontSize: 16, fontWeight: FontWeight.w400),

        //bold headline text
        bodyText1: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),

        // hint style of text form
        headline4: TextStyle(
            color: hintColor, fontSize: 16, fontWeight: FontWeight.w400),

        button: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.0),
      ));

  static final darkThemes = ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade900,

      //chage color of text according on theme
      colorScheme: const ColorScheme.dark(),

      //use by Theme.of(context).primaryColor
      primaryColor: Colors.black,

      //this for icon colors
      iconTheme: IconThemeData(color: Colors.grey[300]));
}
