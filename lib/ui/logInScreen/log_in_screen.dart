// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, body_might_complete_normally_nullable, unused_local_variable, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, prefer_final_fields

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/customtextfiledforpassward/custom_text_form_feild_passward.dart';
import 'package:cayan/custom_widgets/customtextformfield/custom_text_form_feild.dart';
import 'package:cayan/custom_widgets/safe_area/page_container.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/auth%20errors/auth_log_in_error.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';

import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/edit%20navigation%20bar/edit_navigation_bar.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class logInScreen extends StatefulWidget {
  const logInScreen({Key? key}) : super(key: key);

  @override
  State<logInScreen> createState() => _logInScreenState();
}

class _logInScreenState extends State<logInScreen> {
  late FocusNode _emailFocusNode;
  late FocusNode _passwardFocusNode;
  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _userPassward = TextEditingController();
  final formkey = GlobalKey<FormState>();

  bool isLoading = false;

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    print(UserData.getUSerLang());
    _emailFocusNode = FocusNode();
    _passwardFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _emailFocusNode.dispose();
    _passwardFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return PageContainer(
      child: Scaffold(
        backgroundColor: themeProvider.isDarkMode ? blackColor : whiteColor,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: mainAppColor,
                ),
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _emailFocusNode.unfocus();
                    _passwardFocusNode.unfocus();
                  });
                },
                child: Form(
                  key: formkey,
                  child: ListView(
                    shrinkWrap: false,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 7, //116
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width / 25), //15
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width /
                                  4.156506317889603, //90.22
                              height: MediaQuery.of(context).size.height /
                                  7.735543488615795, //104.97
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: themeProvider.isDarkMode
                                      ? AssetImage("assets/images/logodark.png")
                                      : AssetImage("assets/images/logo.png"),
                                ),
                              ),
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.height /
                                    32.2606277314263), //26.17
                            BigText(
                              typeOfFontWieght: 1,
                              text: AppLocalizations.of(context)!
                                  .translate("welcome back"),
                              size: MediaQuery.of(context).size.height /
                                  36.90909090909091, //22
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  81.2, //10
                            ),
                            SmallText(
                              text: AppLocalizations.of(context)!.translate(
                                  "Log in to the system and fill in the required information"),
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.height /
                                    19.80487804878049), //41

                            SmallText(
                              text: AppLocalizations.of(context)!
                                  .translate("Username, mobile or email"),
                              color: themeProvider.isDarkMode
                                  ? whiteColor
                                  : blackColor,
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.height /
                                    54.13333333333333), //15

                            CustomTextField(
                              cursorColor: mainAppColor,
                              readOnly: false,
                              enabled: true,
                              maxLine: 1,
                              focusNode: _emailFocusNode,
                              controller: _userEmail,
                              textStyleDarkColor: whiteColor,
                              textStyleLightColor: blackColor,
                              isFontBold: true,
                              fillDarkColor: containerdarkColor,
                              fillLightColor: whiteColor,
                              labelText: "",
                              ispreffix: true,
                              ispreffixImage: true,
                              preffixImageUrl: "assets/images/mailac.png",
                              isSuffix: false,
                              isSuffixImage: false,
                              hintText: 'Cayan@gamil.com',
                              inputData: TextInputType.emailAddress,
                              validationFunc: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .translate("you must Enter your Email");
                                }
                                return null;
                              },
                              onTap: () {
                                setState(() {
                                  _emailFocusNode.hasFocus == true;
                                });
                              },
                              onEditingComplete: () =>
                                  _emailFocusNode.unfocus(),
                              onFieldSubmitted: (_) =>
                                  _emailFocusNode.unfocus(),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  54.13333333333333, //15
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: SmallText(
                                text: AppLocalizations.of(context)!
                                    .translate("passward"),
                                color: themeProvider.isDarkMode
                                    ? whiteColor
                                    : blackColor,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  54.13333333333333,
                            ), //15),
                            CustomTextFieldPassward(
                              cursorColor: mainAppColor,
                              readOnly: false,
                              enabled: true,
                              maxLine: 1,
                              focusNode: _passwardFocusNode,
                              controller: _userPassward,
                              textStyleDarkColor: whiteColor,
                              textStyleLightColor: blackColor,
                              isFontBold: true,
                              fillDarkColor: containerdarkColor,
                              fillLightColor: whiteColor,
                              labelText: "",
                              ispreffix: true,
                              ispreffixImage: true,
                              preffixImageUrl: "assets/images/pass.png",
                              isSuffix: true,
                              isSuffixImage: false,
                              suffixImageUrl: "assets/images/show.png",
                              suffixWidget: InkWell(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Image.asset(
                                  "assets/images/show.png",
                                  color: _passwardFocusNode.hasFocus
                                      ? themeProvider.isDarkMode
                                          ? mainAppColor
                                          : mainAppColor
                                      : hintColor,
                                ),
                              ),
                              hintText: AppLocalizations.of(context)!
                                  .translate("passward"),
                              obscureText: _obscureText,
                              inputData: TextInputType.emailAddress,
                              onChangedFunc: (value) {
                                if (value.isEmpty) {
                                  _userPassward.clear();
                                }
                                if (value.isNotEmpty) {
                                  value.trim();
                                }
                              },
                              validationFunc: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .translate(
                                          "you must Enter your Passward");
                                }
                                return null;
                              },
                              onTap: () {
                                setState(() {
                                  _passwardFocusNode.hasFocus == true;
                                });
                              },
                              onEditingComplete: () =>
                                  _passwardFocusNode.unfocus(),
                              onFieldSubmitted: (_) =>
                                  _passwardFocusNode.unfocus(),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  16.24, //50
                            ),
                            CustomButton(
                                width: MediaQuery.of(context).size.width /
                                    1.093294460641399, //343
                                height: MediaQuery.of(context).size.height /
                                    16.24, //50
                                addtionalWidgit: true,
                                btnLbl: "التالي",
                                onPressedFunction: userLogIn,
                                btnColor: mainAppColor,
                                btnStyle: Theme.of(context).textTheme.button!,
                                horizontalMargin: 0,
                                verticalMargin: 0,
                                lightBorderColor: mainAppColor,
                                darkBorderColor: mainAppColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          12.5, //30
                                    ),
                                    Expanded(
                                      child: SmallText(
                                        text: AppLocalizations.of(context)!
                                            .translate("Sign in"),
                                        color: blackColor,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                58,
                                        typeOfFontWieght: 1,
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 2.5),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                9.375, //40
                                        height:
                                            MediaQuery.of(context).size.height /
                                                20.3, //40
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  81.2), //10
                                        ),
                                        child: UserData.getUSerLang() == "ar"
                                            ? Image.asset(
                                                "assets/images/leftarrow.png",
                                              )
                                            : Image.asset(
                                                "assets/images/leftarrow.png",
                                              )),
                                  ],
                                )),

                            SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  8.12, //100
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  userLogIn() async {
    print("log in method");
    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    final _authLogInError = Provider.of<AuthLogInError>(context, listen: false);

    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      FocusScope.of(context).unfocus();
      print('come here');
      final body = {
        "username": _userEmail.text,
        "password": _userPassward.text,
      };
      final response = await post(
        Uri.parse(
          Urls.LOGIN_URL_,
        ),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "Accept-Language": UserData.getUSerLang(),
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        UserData.setUserApiToken(body["token"]);
        UserData.setUserId(body["data"]["id"]);
        var userapitoken = UserData.getUserApiToken();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => EditNavigationBar()),
            (route) => false).then((value) {
          setState(() {
            isLoading = false;
          });
        });
      } else if (response.statusCode == 422) {
        print(response.statusCode);
        var body = jsonDecode(response.body);
        print('66666666666666666666666666666666666');
        print(body);

        setState(() {
          _authLogInError.apiErrors(context, body, isLoading = false);
        });
      } else if (response.statusCode == 401) {
        print(response.statusCode);
        print("status cod is  ${response.statusCode}");
        final snackBar = SnackBar(
            content: Text(
              AppLocalizations.of(context)!.translate(
                  "there is some thing wrong check your email and passward"),
              textAlign: TextAlign.center,
            ),
            backgroundColor: mainAppColor);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == 403) {
        print(response.statusCode);
        setState(() {
          erro403.error403(context, response.statusCode);
          isLoading = false;
        });
      } else {
        print(response.statusCode);
        print(response.body);
        setState(() {
          homeServerError.serverError(context, response.statusCode);
        });
      }
    }
  }
}
