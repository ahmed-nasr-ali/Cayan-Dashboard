// ignore_for_file: unnecessary_string_interpolations, prefer_adjacent_string_concatenation

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class OfferStoreError extends ChangeNotifier {
  offerStoreError442(BuildContext context, dynamic body) {
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
                    .translate("offer en.name is invaild"),
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
                    .translate("offer ar.name is invaild"),
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
                    .translate("offer en.description is invaild"),
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
                    .translate("offer ar.description is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    if (body["errors"]["price"] != null) {
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
                    .translate("price is required"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    if (body["errors"]["discount_percentage"] != null) {
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
                    "${AppLocalizations.of(context)!.translate("Discount Percentage can not be more than 100 %")}" +
                        "%",
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    if (body["errors"]["url"] != null) {
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
                    .translate("cart link is required"),
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
