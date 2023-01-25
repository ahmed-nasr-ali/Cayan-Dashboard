// ignore_for_file: prefer_const_constructors

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/ui/Employee%20Mangment/employee%20mangement%20screen/employee%20mangement%20server%20error/home_server_error_screen.dart';

import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomeServerError extends ChangeNotifier {
  serverError(BuildContext context, int response) {
    if (response != 200 && response != 403 && response != 422) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => EmployeeMangmentServerError()),
          (route) => false);

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: BigText(
                color: blackColor,
                text: AppLocalizations.of(context)!.translate("there is error"),
                typeOfFontWieght: 1,
                size: 12,
              ),
            );
          });
      notifyListeners();
    }
  }
}
