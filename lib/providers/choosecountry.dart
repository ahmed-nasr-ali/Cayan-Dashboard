// ignore_for_file: prefer_final_fields, unused_field

import 'package:flutter/material.dart';

class ChooseCountryData extends ChangeNotifier {
  String? _data = '';

  void setcounntryinfor(String data) {
    _data = data;
    notifyListeners();
  }

  String get data => _data!;

  ///===========================================================================
  String? _editData = '';

  void setEitCounntryinfor(String data) {
    _editData = data;
    notifyListeners();
  }

  String get editData => _editData!;

  ///===========================================================================
  bool? _employeeMangement = false;

  void setEmployeeMangement(bool employeeMangement) {
    _employeeMangement = employeeMangement;
    notifyListeners();
  }

  bool get employeeMangement => _employeeMangement!;
}
