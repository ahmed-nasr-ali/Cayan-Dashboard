import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomerError extends ChangeNotifier {
  customerError422(BuildContext context, dynamic body) {
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
    if (body["errors"]["email"] != null) {
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
                        .translate("User Email is invaild"),
                    typeOfFontWieght: 1,
                  ),
                  BigText(
                    size: 12,
                    color: blackColor,
                    text: AppLocalizations.of(context)!
                        .translate("Or email arleady exist"),
                    typeOfFontWieght: 1,
                  ),
                ],
              ),
            );
          });

      notifyListeners();
    }

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
                    text: AppLocalizations.of(context)!
                        .translate("Or phone number arleady exist"),
                    color: blackColor,
                  )
                ],
              ),
            );
          });

      notifyListeners();
    }
  }
}
