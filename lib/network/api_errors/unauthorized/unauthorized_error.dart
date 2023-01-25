// ignore_for_file: prefer_const_constructors

import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/ui/logInScreen/log_in_screen.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class UnauthorizedError extends ChangeNotifier {
  unauthorizedErrors401(BuildContext context) {
    final snackBar = SnackBar(
        content: Text(
          AppLocalizations.of(context)!.translate("log in agin"),
          textAlign: TextAlign.center,
        ),
        backgroundColor: mainAppColor);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => logInScreen()),
        (route) => false);

    notifyListeners();
  }
}
