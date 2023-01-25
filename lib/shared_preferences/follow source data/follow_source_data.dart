// ignore_for_file: unused_field

import 'package:shared_preferences/shared_preferences.dart';

class FollowSourceUserData {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///===========================================================================
  /// Follow source from  for search
  static setFollowSourcesHistoryFromSearch(String name) async =>
      await _preferences!.setString("_FollowSourcesHistoryFromSearch", name);

  static getFollowSourcesHistoryFromSearch() {
    return _preferences!.getString("_FollowSourcesHistoryFromSearch") ?? "";
  }

  ///===========================================================================
  /// Follow source to  for search
  static setFollowSourceHistoryToSearch(String name) async =>
      await _preferences!.setString("_FollowSourceHistoryToSearch", name);

  static getFollowSourceHistoryToSearch() {
    return _preferences!.getString("_FollowSourceHistoryToSearch") ?? "";
  }

  ///===========================================================================
  ///Follow sources Day for search
  static setFollowSourceDaySearch(String name) async =>
      await _preferences!.setString("_FollowSourceDaySearch", name);

  static getFollowSourceDaySearch() {
    return _preferences!.getString("_FollowSourceDaySearch") ?? "";
  }

  ///===========================================================================
  /// Follow source from  for Showing
  static setFollowSourcesHistoryFromShowing(String name) async =>
      await _preferences!.setString("_FollowSourcesHistoryFromShowing", name);

  static getFollowSourcesHistoryFromShowing() {
    return _preferences!.getString("_FollowSourcesHistoryFromShowing") ?? "";
  }

  ///===========================================================================
  /// Follow source to  for showinf
  static setFollowSourceHistoryToShowing(String name) async =>
      await _preferences!.setString("_FollowSourceHistoryToShowing", name);

  static getFollowSourceHistoryToShowing() {
    return _preferences!.getString("_FollowSourceHistoryToShowing") ?? "";
  }

  ///===========================================================================
  ///Follow sources Day for showing
  static setFollowSourceDayShowing(String name) async =>
      await _preferences!.setString("_FollowSourceDayShowing", name);

  static getFollowSourceDayShowing() {
    return _preferences!.getString("_FollowSourceDayShowing") ?? "";
  }
}
