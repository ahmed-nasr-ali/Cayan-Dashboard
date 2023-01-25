// ignore_for_file: unused_field

import 'package:shared_preferences/shared_preferences.dart';

class FollowPrefUserData {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///===========================================================================
  /// Follow pref from  for search
  static setFollowPrefHistoryFromSearch(String name) async =>
      await _preferences!.setString("_FollowPrefHistoryFromSearch", name);

  static getFollowPrefHistoryFromSearch() {
    return _preferences!.getString("_FollowPrefHistoryFromSearch") ?? "";
  }

  ///===========================================================================
  /// Follow pref to  for search
  static setFollowprefHistoryToSearch(String name) async =>
      await _preferences!.setString("_FollowprefHistoryToSearch", name);

  static getFollowprefHistoryToSearch() {
    return _preferences!.getString("_FollowprefHistoryToSearch") ?? "";
  }

  ///===========================================================================
  ///Follow pref Day for search
  static setFollowprefDaySearch(String name) async =>
      await _preferences!.setString("_FollowprefDaySearch", name);

  static getFollowprefDaySearch() {
    return _preferences!.getString("_FollowprefDaySearch") ?? "";
  }

  ///===========================================================================
  /// Follow pref from  for Showing
  static setFollowprefHistoryFromShowing(String name) async =>
      await _preferences!.setString("_FollowprefHistoryFromShowing", name);

  static getFollowprefHistoryFromShowing() {
    return _preferences!.getString("_FollowprefHistoryFromShowing") ?? "";
  }

  ///===========================================================================
  /// Follow source to  for showinf
  static setFollowprefHistoryToShowing(String name) async =>
      await _preferences!.setString("_FollowprefHistoryToShowing", name);

  static getFollowprefHistoryToShowing() {
    return _preferences!.getString("_FollowprefHistoryToShowing") ?? "";
  }

  ///===========================================================================
  ///Follow sources Day for showing
  static setFollowprefDayShowing(String name) async =>
      await _preferences!.setString("_FollowprefDayShowing", name);

  static getFollowprefDayShowing() {
    return _preferences!.getString("_FollowprefDayShowing") ?? "";
  }
}
