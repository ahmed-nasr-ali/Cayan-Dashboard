// ignore_for_file: prefer_const_constructors

import 'package:cayan/ui/Control%20Panel/control%20panel%20screen/control_panel_screen.dart';
import 'package:cayan/ui/Edit/edit%20screeen/edit_screen.dart';
import 'package:cayan/ui/Orders/orders%20screen/order_screen.dart';
import 'package:cayan/ui/follwing%20source/follwing%20source%20screen/follwing_source_screen.dart';
import 'package:flutter/material.dart';

class NavigationBarScreen extends ChangeNotifier {
  int _navigationIndex = 0;

  void updateNavigationIndex(int value) {
    _navigationIndex = value;
    notifyListeners();
  }

  int get notificationIndex => _navigationIndex;

  List screen = [
    EditScreen(),
    FollwingSourceScreen(),
    OrdersScreen(),
    ControlPanelScreen(),
  ];

  Widget get screenCount => screen[_navigationIndex];
}
