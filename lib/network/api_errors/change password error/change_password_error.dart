// ignore_for_file: prefer_const_constructors

import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ChangePasswordError extends ChangeNotifier {
  changePasswordError422(BuildContext context, dynamic body) {
    if (body["errors"]["user_id"] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: Column(
                children: [
                  SmallText(
                    size: 12,
                    color: blackColor,
                    text: AppLocalizations.of(context)!
                        .translate("There is an internet connection error"),
                    typeOfFontWieght: 1,
                  ),
                ],
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["old_password"] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SmallText(
                    size: 12,
                    color: blackColor,
                    text: "the current password is wrong",
                    typeOfFontWieght: 1,
                  ),
                  SmallText(
                    size: MediaQuery.of(context).size.height / 116,
                    color: blackColor,
                    text: UserData.getUSerLang() == "ar"
                        ? "يجب أن يكون الحقلان كلمة المرور القديمة و كلمة المرور مُختلفين"
                        : "The old password and password must be different",
                    typeOfFontWieght: 1,
                  ),
                ],
              ),
            );
          });

      notifyListeners();
    }

    if (body["errors"]["password"] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SmallText(
                    size: MediaQuery.of(context).size.height / 116,
                    color: blackColor,
                    text:
                        "the password must contain at least one uppercase and one lowercase letter",
                    typeOfFontWieght: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SmallText(
                    size: MediaQuery.of(context).size.height / 116,
                    color: blackColor,
                    text: "The password must contain at least one symbol",
                    typeOfFontWieght: 1,
                  ),
                ],
              ),
            );
          });

      notifyListeners();
    }
  }
}
