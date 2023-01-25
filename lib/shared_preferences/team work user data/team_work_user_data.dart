// ignore_for_file: unused_field

import 'package:shared_preferences/shared_preferences.dart';

class TeamWorkUserData {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///===========================================================================
  ///set user lang
  // static setIsGrid(bool isGrid) async {
  //   await _preferences!.setBool("_IsGrid", isGrid);
  // }

  // static bool getIsGrid() {
  //   return _preferences!.getBool("_IsGrid") ?? false;
  // }
}
