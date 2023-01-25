// ignore_for_file: unused_field

import 'package:shared_preferences/shared_preferences.dart';

class OrderUserData {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///Category id
  static setCategoryId(int id) async =>
      await _preferences!.setInt("_CategoryId", id);

  static getCategoryId() {
    return _preferences!.getInt("_CategoryId") ?? 0;
  }

  ///Category name
  static setCategoryName(String name) async =>
      await _preferences!.setString("_CategoryName", name);

  static getCategoryName() {
    return _preferences!.getString("_CategoryName") ?? "";
  }

  ///===========================================================================
  ///Customer id
  static setCustomerId(int id) async =>
      await _preferences!.setInt("_CustomerId", id);

  static getCustomerId() {
    return _preferences!.getInt("_CustomerId") ?? 0;
  }

  ///Customer name
  static setCustomerName(String name) async =>
      await _preferences!.setString("_CustomerName", name);

  static getCustomerName() {
    return _preferences!.getString("_CustomerName") ?? "";
  }

  ///===========================================================================
  ///Branches id
  static setBrancheId(int id) async =>
      await _preferences!.setInt("_BrancheId", id);

  static getBrancheId() {
    return _preferences!.getInt("_BrancheId") ?? 0;
  }

  ///===========================================================================
  ///Branches Name
  static setBrancheName(String name) async =>
      await _preferences!.setString("_BrancheName", name);

  static getBrancheName() {
    return _preferences!.getString("_BrancheName") ?? "";
  }

  ///===========================================================================
  ///Source id
  static setSourceId(int id) async =>
      await _preferences!.setInt("_SourceId", id);

  static getSourceId() {
    return _preferences!.getInt("_SourceId") ?? 0;
  }

  ///Source name
  static setSourceName(String name) async =>
      await _preferences!.setString("_SourceName", name);

  static getSourceName() {
    return _preferences!.getString("_SourceName") ?? "";
  }

  ///===========================================================================
  ///Order Status id
  static setOrderStatusId(int id) async =>
      await _preferences!.setInt("_OrderStatusName", id);

  static getOrderStatusId() {
    return _preferences!.getInt("_OrderStatusName") ?? "";
  }

  ///===========================================================================
  ///Order Sub_Status id
  static setOrderSubStatusId(int id) async =>
      await _preferences!.setInt("_OrderSubStatusId", id);

  static getOrderSubStatusId() {
    return _preferences!.getInt("_OrderSubStatusId") ?? "";
  }

  ///===========================================================================
  ///Order Date and Time
  static setOrderFollowStatus(String name) async =>
      await _preferences!.setString("_OrderFollowStatus", name);

  static getOrderFollowStatus() {
    return _preferences!.getString("_OrderFollowStatus") ?? "";
  }

  ///===========================================================================
  ///Order Date and Time
  static setOrderDateAndTime(String date) async =>
      await _preferences!.setString("_OrderDateAndTime", date);

  static getOrderDateAndTime() {
    return _preferences!.getString("_OrderDateAndTime") ?? "";
  }

  ///===========================================================================
  ///Order Status Name for search
  static setOrderStatusNameForSearch(String name) async =>
      await _preferences!.setString("_OrderStatusNameForSearch", name);

  static getOrderStatusNameForSearch() {
    return _preferences!.getString("_OrderStatusNameForSearch") ?? "";
  }

  ///===========================================================================
  ///Order Status id for Search
  static setOrderStatusIdForSearch(int id) async =>
      await _preferences!.setInt("_OrderStatusIdForSearch", id);

  static getOrderStatusIdForSearch() {
    return _preferences!.getInt("_OrderStatusIdForSearch") ?? "";
  }

  ///===========================================================================
  ///Order History from  for search
  static setOrderHistoryFromSearch(String name) async =>
      await _preferences!.setString("_OrderHistoryFromSearch", name);

  static getOrderHistoryFromSearch() {
    return _preferences!.getString("_OrderHistoryFromSearch") ?? "";
  }

  ///===========================================================================
  ///Order History to  for search
  static setOrderHistoryToSearch(String name) async =>
      await _preferences!.setString("_OrderHistoryToSearch", name);

  static getOrderHistoryToSearch() {
    return _preferences!.getString("_OrderHistoryToSearch") ?? "";
  }

  ///===========================================================================
  ///Order Day for search
  static setOrderDaySearch(String name) async =>
      await _preferences!.setString("_OrderDaySearch", name);

  static getOrderDaySearch() {
    return _preferences!.getString("_OrderDaySearch") ?? "";
  }

  ///===========================================================================
  ///Order History from  for showing
  static setOrderHistoryFromShowing(String name) async =>
      await _preferences!.setString("_OrderHistoryFromShowing", name);

  static getOrderHistoryFromShowing() {
    return _preferences!.getString("_OrderHistoryFromShowing") ?? "";
  }

  ///===========================================================================
  ///Order History to  for showing
  static setOrderHistoryToShowing(String name) async =>
      await _preferences!.setString("_OrderHistoryToShowing", name);

  static getOrderHistoryToShowing() {
    return _preferences!.getString("_OrderHistoryToShowing") ?? "";
  }

  ///===========================================================================
  ///Order Day for show
  static setOrderDayShowing(String name) async =>
      await _preferences!.setString("_OrderDayShowing", name);

  static getOrderDayShowing() {
    return _preferences!.getString("_OrderDayShowing") ?? "";
  }
}
