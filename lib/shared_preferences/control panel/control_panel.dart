// ignore_for_file: unused_field

import 'package:shared_preferences/shared_preferences.dart';

class ControlPanleUserData {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///===========================================================================
  /// Control panel from  for search
  static setControlPanelHistoryFromSearch(String name) async =>
      await _preferences!.setString("_ControlPanelHistoryFromSearch", name);

  static getControlPanelHistoryFromSearch() {
    return _preferences!.getString("_ControlPanelHistoryFromSearch") ?? "";
  }

  ///===========================================================================
  /// Control panel to  for search
  static setControlPanelHistoryToSearch(String name) async =>
      await _preferences!.setString("_ControlPanelHistoryToSearch", name);

  static getControlPanelHistoryToSearch() {
    return _preferences!.getString("_ControlPanelHistoryToSearch") ?? "";
  }

  ///===========================================================================
  ///Control panel Day for search
  static setControlPanelDaySearch(String name) async =>
      await _preferences!.setString("_ControlPanelDaySearch", name);

  static getControlPanelDaySearch() {
    return _preferences!.getString("_ControlPanelDaySearch") ?? "";
  }

  ///===========================================================================
  /// Control panel from  for search
  static setControlPanelHistoryFromShowing(String name) async =>
      await _preferences!.setString("_ControlPanelHistoryFromShowing", name);

  static getControlPanelHistoryFromShowing() {
    return _preferences!.getString("_ControlPanelHistoryFromShowing") ?? "";
  }

  ///===========================================================================
  /// Control panel to  for search
  static setControlPanelHistoryToShowing(String name) async =>
      await _preferences!.setString("_ControlPanelHistoryToShowing", name);

  static getControlPanelHistoryToShowing() {
    return _preferences!.getString("_ControlPanelHistoryToShowing") ?? "";
  }

  ///===========================================================================
  ///Control panel Day for search
  static setControlPanelDayShowing(String name) async =>
      await _preferences!.setString("_ControlPanelDayShowing", name);

  static getControlPanelDayShowing() {
    return _preferences!.getString("_ControlPanelDayShowing") ?? "";
  }
}
