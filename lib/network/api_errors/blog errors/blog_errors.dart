import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BlogStoreError extends ChangeNotifier {
  blogsStoreError442(BuildContext context, dynamic body) {
    if (body["errors"]["ar.title"] != null) {
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
                    .translate("article aret in Arbic is invalid"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    if (body["errors"]["en.title"] != null) {
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
                    .translate("article aret in English is invalid"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }

    if (body["errors"]["en.short_description"] != null) {
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
                    "Short description of the article in Englis is invalid"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["ar.short_description"] != null) {
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
                    "Short description of the article in Arbic is invalid"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["en.long_description"] != null) {
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
                    "Detailed description of the article in Englis is invalid"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["ar.long_description"] != null) {
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
                    "Detailed description of the article in Arbic is invalid"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["reference_link"] != null) {
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
                    AppLocalizations.of(context)!.translate("Link is invaild"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
    if (body["errors"]["date"] != null) {
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
                    .translate("Added date is invalid"),
                typeOfFontWieght: 1,
              ),
            );
          });

      notifyListeners();
    }
  }
}
