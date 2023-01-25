// ignore_for_file: prefer_const_constructors

import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AuthLogInError extends ChangeNotifier {
  apiErrors(
    BuildContext context,
    dynamic body,
    bool isLoading,
  ) {
    ///userEmail error
    if (body["errors"]["username"] != null) {
      isLoading = false;
      final snackBar = SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate("User Email is invaild"),
            textAlign: TextAlign.center,
          ),
          backgroundColor: mainAppColor);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      notifyListeners();
    }

    ///userpassward error
    if (body["errors"]["password"] != null) {
      isLoading = false;
      final snackBar = SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate("User Passward is invaild"),
            textAlign: TextAlign.center,
          ),
          backgroundColor: mainAppColor);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      notifyListeners();
    }
  }
}
