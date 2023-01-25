import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class EditEmployeeError extends ChangeNotifier {
  editEmployeeError422(BuildContext context, dynamic body) {
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
              title: BigText(
                color: blackColor,
                text: AppLocalizations.of(context)!
                    .translate("User Phone is invaild"),
                typeOfFontWieght: 1,
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
              title: BigText(
                color: blackColor,
                text: AppLocalizations.of(context)!
                    .translate("User Passward is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
  }
}
