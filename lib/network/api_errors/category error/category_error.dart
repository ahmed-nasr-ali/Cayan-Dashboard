import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryStoreError extends ChangeNotifier {
  servicesStoreError442(BuildContext context, dynamic body) {
    if (body["errors"]["en.name"] != null) {
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
                    .translate("category en.name is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["ar.name"] != null) {
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
                    .translate("category ar.name is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["en.description"] != null) {
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
                    .translate("category en.description is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["ar.description"] != null) {
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
                    .translate("category ar.description is invaild"),
                typeOfFontWieght: 1,
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
                size:
                    MediaQuery.of(context).size.height / 73.81818181818182, //11
                color: blackColor,
                text:
                    AppLocalizations.of(context)!.translate("image is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
  }
}
