import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BrancheStoreError extends ChangeNotifier {
  brancheStoreError442(BuildContext context, dynamic body) {
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
                    .translate("source en.name is invaild"),
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
                    .translate("source ar.name is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    ///
    if (body["errors"]["en.full_description"] != null) {
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
                text: AppLocalizations.of(context)!.translate(
                    "Detailed description of the branch in english is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["ar.full_description"] != null) {
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
                text: AppLocalizations.of(context)!.translate(
                    "Detailed description of the branch in arbic is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    ///
    if (body["errors"]["en.city"] != null) {
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
                    .translate("City in english is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["ar.city"] != null) {
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
                    .translate("City in arbic is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    ///

    if (body["errors"]["en.address"] != null) {
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
                    .translate("Adress in english is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["ar.address"] != null) {
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
                    .translate("Adress in arbic is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    ///
    if (body["errors"]["telephone"] != null) {
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
                    .translate("Phone number in arbic is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["whatsapp"] != null) {
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
                    .translate("what's up in arbic is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["map"] != null) {
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
                    .translate("Map link in arbic is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
  }
}
