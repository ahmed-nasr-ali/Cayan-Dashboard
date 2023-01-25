// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class successOperation extends StatefulWidget {
  String operationName;
  successOperation({Key? key, required this.operationName}) : super(key: key);

  @override
  State<successOperation> createState() => _successOperationState();
}

class _successOperationState extends State<successOperation> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return NetworkIndicator(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3.641255605381166, //223
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft:
                  Radius.circular(MediaQuery.of(context).size.height / 81.2),
              topRight:
                  Radius.circular(MediaQuery.of(context).size.height / 81.2)),
          color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height:
                  MediaQuery.of(context).size.height / 54.13333333333333, //15
            ),
            Center(
              child: Container(
                // margin: EdgeInsets.symmetric(horizontal: 0),
                width: MediaQuery.of(context).size.width / 9.375, //40
                height: MediaQuery.of(context).size.height / 162.4, //5
                decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? dividerDarkColor
                        : containerColor,
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height / 162.4)), //5
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 16.24, //50
            ),
            Center(
              child: themeProvider.isDarkMode
                  ? Image.asset("assets/images/donedark.png")
                  : Image.asset("assets/images/done.png"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 32.48, //25
            ),
            Center(
              child: SmallText(
                text: AppLocalizations.of(context)!
                    .translate(widget.operationName),
                size: MediaQuery.of(context).size.height / 50.75, //16
                typeOfFontWieght: 1,
                color: themeProvider.isDarkMode ? whiteColor : blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
