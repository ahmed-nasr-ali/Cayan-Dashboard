// ignore_for_file: avoid_print

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class RolesAndPerimissionApiError extends ChangeNotifier {
  rolesAndPerimissionStoer442(BuildContext context, dynamic body) {
    if (body["errors"]["name"] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: BigText(
                size:
                    MediaQuery.of(context).size.height / 73.81818181818182, //11
                color: blackColor,
                text:
                    AppLocalizations.of(context)!.translate("name is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["requested_permissions"] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: BigText(
                size:
                    MediaQuery.of(context).size.height / 73.81818181818182, //11
                color: blackColor,
                text: AppLocalizations.of(context)!
                    .translate("must_choose_permission_category"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
  }
}
