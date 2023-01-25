// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, unrelated_type_equality_checks

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/custom_container/custom_container.dart';
import 'package:cayan/custom_widgets/safe_area/page_container.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/locale/locale_helper.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/shared_preferences_helper.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/logInScreen/log_in_screen.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool _arbiLang = false;
  bool _englisLang = false;
  String language = '';
  String checklang = '';

  Future<String> _getLanguage() async {
    String language = await SharedPreferencesHelper.getUserLang();
    return language;
  }

  @override
  void initState() {
    super.initState();
    UserData.setUserMode("");

    UserData.setIsGridOrNot(true);

    _arbiLang = false;
    _englisLang = false;
    _getLanguage().then((value) {
      checklang = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return PageContainer(
      child: Scaffold(
        backgroundColor: themeProvider.isDarkMode ? blackColor : whiteColor,
        body: ListView(
          shrinkWrap: false,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height /
                      5.413333333333333), //150
              width: MediaQuery.of(context).size.width / 2.5, //150
              height:
                  MediaQuery.of(context).size.height / 5.413333333333333, //150
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: themeProvider.isDarkMode
                      ? AssetImage("assets/images/chlanguagedark.png")
                      : AssetImage("assets/images/chlanguage.png"),
                ),
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height /
                    31.23076923076923), //26
            BigText(
              text: AppLocalizations.of(context)!.translate("choose_lang"),
              typeOfFontWieght: 1,
              color: themeProvider.isDarkMode ? whiteColor : blackColor,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height /
                    67.66666666666667), //12
            SmallText(
              text: AppLocalizations.of(context)!.translate(
                "Please choose the language in which you want to display the application",
              ),
              color: textGrayColor,
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 20.3), //40

            CustomContainer(
              color:
                  themeProvider.isDarkMode ? containerdarkColor : accentColor,
              isSelected: _arbiLang,
              width:
                  MediaQuery.of(context).size.width / 1.194267515923567, //314
              height: MediaQuery.of(context).size.height / 16.24, //50
              horizontalMargin:
                  MediaQuery.of(context).size.width / 23.4375, //16
              verticalMargin: 0,
              hasHorizontalMargin: true,
              borderRadius: MediaQuery.of(context).size.height / 81.2, //10
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (!_arbiLang) {
                      _arbiLang = true;
                      _englisLang = false;
                      SharedPreferencesHelper.setUserLang('ar');
                      UserData.setUserLang("ar");
                      helper.onLocaleChanged(new Locale('ar'));
                      themeProvider.setCurrentLanguage('ar');
                      checklang = 'ar';
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 37.5, //10
                        ),
                        Image.asset(
                          "assets/images/arabic.png",
                          width:
                              MediaQuery.of(context).size.width / 15.625, //24
                          height: MediaQuery.of(context).size.height /
                              33.83333333333333, //24,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 75, //5,
                        ),
                        SmallText(
                          text:
                              AppLocalizations.of(context)!.translate("arabic"),
                          typeOfFontWieght: _arbiLang ? 1 : 0,
                          color: _arbiLang
                              ? themeProvider.isDarkMode
                                  ? whiteColor
                                  : blackColor
                              : textGrayColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: SharedPreferencesHelper.getUserLang() != 'ar'
                          ? MediaQuery.of(context).size.width /
                              2.329192546583851 //161
                          : 0,
                    ), //todo check lang
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width / 37.5), //10
                      child: Visibility(
                        visible: _arbiLang ? true : false,
                        child: Image.asset(
                          "assets/images/check.png",
                          color: _arbiLang ? mainAppColor : mainAppColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height:
                  MediaQuery.of(context).size.height / 54.13333333333333, //15
            ),
            CustomContainer(
              color:
                  themeProvider.isDarkMode ? containerdarkColor : accentColor,
              isSelected: _englisLang,
              width:
                  MediaQuery.of(context).size.width / 1.194267515923567, //314,
              height: MediaQuery.of(context).size.height / 16.24, //50
              horizontalMargin:
                  MediaQuery.of(context).size.width / 23.4375, //16,
              verticalMargin: 0,
              hasHorizontalMargin: true,
              borderRadius: MediaQuery.of(context).size.height / 81.2, //10,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (!_englisLang) {
                      _arbiLang = false;
                      _englisLang = true;
                      SharedPreferencesHelper.setUserLang('en');
                      UserData.setUserLang("en");
                      helper.onLocaleChanged(new Locale('en'));
                      themeProvider.setCurrentLanguage('en');
                      checklang = 'en';
                    }
                  });
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 37.5, //10,
                    ),
                    Image.asset(
                      "assets/images/english.png",
                      width: MediaQuery.of(context).size.width / 15.625, //24
                      height: MediaQuery.of(context).size.height /
                          33.83333333333333, //24,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 37.5, //10
                    ),
                    SmallText(
                      text: AppLocalizations.of(context)!.translate("english"),
                      typeOfFontWieght: _englisLang ? 1 : 0,
                      color: _englisLang
                          ? themeProvider.isDarkMode
                              ? whiteColor
                              : blackColor
                          : textGrayColor,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width /
                            1.704545454545455), //220
                    Visibility(
                      visible: _englisLang ? true : false,
                      child: Image.asset(
                        "assets/images/check.png",
                        color: _englisLang ? mainAppColor : whiteColor,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 75, //5
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 16.24), //50
            CustomButton(
                width:
                    MediaQuery.of(context).size.width / 1.093294460641399, //343
                height: MediaQuery.of(context).size.height / 16.24, //50
                addtionalWidgit: true,
                btnLbl: "التالي",
                onPressedFunction: () {
                  if (_arbiLang || _englisLang) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => logInScreen(),
                      ),
                    );
                  } else {
                    final snackBar = SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!
                              .translate("you needed to choose language frist"),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: mainAppColor);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    print(themeProvider.currentLang);
                  }
                },
                btnColor: mainAppColor,
                btnStyle: Theme.of(context).textTheme.button!,
                horizontalMargin:
                    MediaQuery.of(context).size.width / 23.4375, //16
                verticalMargin: 0,
                lightBorderColor: mainAppColor,
                darkBorderColor: mainAppColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 7.5, //50
                    ),
                    Expanded(
                      child: SmallText(
                        text: AppLocalizations.of(context)!.translate("next"),
                        color: blackColor,
                        size: MediaQuery.of(context).size.height / 58, //14
                        typeOfFontWieght: 1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width / 150), //2.5
                      width: MediaQuery.of(context).size.width / 9.375, //40
                      height: MediaQuery.of(context).size.height / 20.3, //40
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height / 81.2), //10
                      ),
                      child: checklang == "en"
                          ? Image.asset(
                              "assets/images/leftarrow.png",
                            )
                          : Image.asset(
                              "assets/images/leftarrow.png",
                            ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
