// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, unnecessary_new

import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/locale/locale_helper.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/shared_preferences_helper.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return NetworkIndicator(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3.184313725490196, //255
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
              height: MediaQuery.of(context).size.height / 40.6,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 18.75),
              child: SmallText(
                  size: MediaQuery.of(context).size.height / 50.75, //16,
                  typeOfFontWieght: 1,
                  color: themeProvider.isDarkMode ? whiteColor : blackColor,
                  text: AppLocalizations.of(context)!.translate("language")),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 162.4, //5
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 18.75),
              child: SmallText(
                  size: MediaQuery.of(context).size.height / 58, //14
                  typeOfFontWieght: 0,
                  color: textGrayColor,
                  text: AppLocalizations.of(context)!
                      .translate("choose your favourt language")),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 40.6, //20
            ),
            InkWell(
              onTap: () {
                setState(() {
                  print("ar");

                  SharedPreferencesHelper.setUserLang('ar');
                  UserData.setUserLang("ar");
                  helper.onLocaleChanged(new Locale('ar'));
                  themeProvider.setCurrentLanguage('ar');
                });
                Navigator.pop(context);
              },
              child: Column(
                children: [
                  Divider(
                    height: 0,
                    color: themeProvider.isDarkMode
                        ? dividerDarkColor
                        : containerColor,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40.6, //20
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 25, //15
                      ),
                      Image.asset("assets/images/arabic.png"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 37.5, //10
                      ),
                      SmallText(
                          text:
                              AppLocalizations.of(context)!.translate("arabic"),
                          typeOfFontWieght:
                              UserData.getUSerLang() == "ar" ? 1 : 0,
                          color: UserData.getUSerLang() == "ar"
                              ? themeProvider.isDarkMode
                                  ? whiteColor
                                  : blackColor
                              : textGrayColor),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                              visible:
                                  UserData.getUSerLang() == "ar" ? true : false,
                              child: Image.asset("assets/images/check.png")),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 25, //15
                          )
                        ],
                      ))
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40.6, //20
                  ),
                  Divider(
                    height: 0,
                    color: themeProvider.isDarkMode
                        ? dividerDarkColor
                        : containerColor,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                print("en");
                setState(() {
                  SharedPreferencesHelper.setUserLang('en');
                  UserData.setUserLang("en");
                  helper.onLocaleChanged(new Locale('en'));
                  themeProvider.setCurrentLanguage('en');
                });
                Navigator.pop(context);
              },
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40.6, //20
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 25, //15
                      ),
                      Image.asset("assets/images/english.png"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 37.5, //10
                      ),
                      SmallText(
                          text: AppLocalizations.of(context)!
                              .translate("english"),
                          typeOfFontWieght:
                              UserData.getUSerLang() == "en" ? 1 : 0,
                          color: UserData.getUSerLang() == "en"
                              ? themeProvider.isDarkMode
                                  ? whiteColor
                                  : blackColor
                              : textGrayColor),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                              visible:
                                  UserData.getUSerLang() == "en" ? true : false,
                              child: Image.asset("assets/images/check.png")),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 25, //15
                          )
                        ],
                      ))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
