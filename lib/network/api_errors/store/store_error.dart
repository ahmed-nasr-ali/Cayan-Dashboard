// ignore_for_file: prefer_const_constructors

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';

import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class StoreError extends ChangeNotifier {
  storeError422(BuildContext context, dynamic body) {
    ///user name error
    if (body["errors"]["name"] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: BigText(
                color: blackColor,
                text: AppLocalizations.of(context)!
                    .translate("User Name is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    ///=====================================================

    ///user gender error
    if (body["errors"]["gender"] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: BigText(
                color: blackColor,
                text: AppLocalizations.of(context)!
                    .translate("User Gender is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    ///=====================================================

    ///user Email error
    if (body["errors"]["email"] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: BigText(
                color: blackColor,
                text: AppLocalizations.of(context)!
                    .translate("User Email is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    ///=====================================================

    ///user country error
    if (body["errors"]["country_id"] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: BigText(
                color: blackColor,
                text: AppLocalizations.of(context)!
                    .translate("You must choose the country"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    ///=====================================================

    ///user phone error
    if (body["errors"]["phone"] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: Column(
                children: [
                  BigText(
                    size: 12,
                    color: blackColor,
                    text: AppLocalizations.of(context)!
                        .translate("User Phone is invaild"),
                    typeOfFontWieght: 1,
                  ),
                  SmallText(
                    text: UserData.getUSerLang() == "en"
                        ? "or arleady taken"
                        : "او رقم الجوال مستخدم من قبل",
                    size: 12,
                    color: blackColor,
                  )
                ],
              ),
            );
          });

      notifyListeners();
    }

    ///=====================================================

    ///user presmissions error
    if (body["errors"]["role_id"] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: BigText(
                color: blackColor,
                text: AppLocalizations.of(context)!
                    .translate("Must choose employee perimissions"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    ///=====================================================

    ///user password error
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

    if (body["errors"]["image"] != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: mainAppColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              title: BigText(
                color: blackColor,
                text: AppLocalizations.of(context)!
                    .translate("user image is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
  }
}
