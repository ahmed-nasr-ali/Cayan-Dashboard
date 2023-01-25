// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, prefer_const_literals_to_create_immutables, unused_element, unnecessary_string_interpolations, unused_local_variable, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/customtextfiledforpassward/custom_text_form_feild_passward.dart';
import 'package:cayan/custom_widgets/safe_area/page_container.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer%20app%20bar/shimmer_app_bar.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';

import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/change%20password%20error/change_password_error.dart';
import 'package:cayan/network/api_errors/server%20error/server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isloading = false;

  http.Client clientApi = http.Client();

  bool _obscureTextOldPass = true;
  bool _obscureTextNewPass = true;
  bool _obscureTextConfirmPass = true;
  final formKey = GlobalKey<FormState>();

  late FocusNode _oldPasswordFocus;
  late FocusNode _newPasswordFocus;
  late FocusNode _confirmPasswordFocus;

  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  @override
  void initState() {
    super.initState();
    _oldPasswordFocus = FocusNode();
    _newPasswordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _oldPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();

    clientApi.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NetworkIndicator(
      child: PageContainer(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _oldPasswordFocus.unfocus();
              _newPasswordFocus.unfocus();
              _confirmPasswordFocus.unfocus();
            });
          },
          child: Scaffold(
            backgroundColor: themeProvider.isDarkMode ? blackColor : whiteColor,
            appBar: _isloading
                ? ShimmerAppbar()
                : AppBar(
                    backgroundColor: themeProvider.isDarkMode
                        ? containerdarkColor
                        : whiteColor,
                    elevation: 0,
                    centerTitle: true,
                    title: BigText(
                      typeOfFontWieght: 1,
                      text: AppLocalizations.of(context)!
                          .translate("change_password"),
                    ),
                    leadingWidth: MediaQuery.of(context).size.width /
                        8.333333333333333, //45
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                      color: themeProvider.isDarkMode ? whiteColor : blackColor,
                      iconSize: MediaQuery.of(context).size.height /
                          67.66666666666667, //12
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      // focusColor: Colors.transparent,
                    ),
                  ),
            body: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 25), //15
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height /
                              54.13333333333333, //15
                        ),
                        _isloading
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        54.13333333333333, //15
                                  ),
                                  ShimmerWidget.circular(
                                    hight: MediaQuery.of(context).size.height /
                                        32.48, //25
                                    width: MediaQuery.of(context).size.width /
                                        7.5, //50
                                    shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height /
                                              81.2 //10
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        81.2,
                                  )
                                ],
                              )
                            : _dimenssion(themeProvider, "old password"),
                        _isloading
                            ? ShimmerWidget.circular(
                                hight: MediaQuery.of(context).size.height /
                                    18.04444444444444, //45
                                width: MediaQuery.of(context).size.width,
                                shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height /
                                          81.2),
                                ),
                              )
                            : CustomTextFieldPassward(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _oldPasswordFocus,
                                controller: _oldPassword,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
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
                                      _obscureTextOldPass =
                                          !_obscureTextOldPass;
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/images/show.png",
                                    color: _oldPasswordFocus.hasFocus
                                        ? themeProvider.isDarkMode
                                            ? mainAppColor
                                            : mainAppColor
                                        : hintColor,
                                  ),
                                ),
                                hintText: AppLocalizations.of(context)!
                                    .translate("old password"),
                                obscureText: _obscureTextOldPass,
                                inputData: TextInputType.emailAddress,
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
                                    _oldPasswordFocus.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _oldPasswordFocus.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _oldPasswordFocus.unfocus(),
                              ),
                        _isloading
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        54.13333333333333, //15
                                  ),
                                  ShimmerWidget.circular(
                                    hight: MediaQuery.of(context).size.height /
                                        32.48, //25
                                    width: MediaQuery.of(context).size.width /
                                        7.5, //50
                                    shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height /
                                              81.2 //10
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        81.2,
                                  )
                                ],
                              )
                            : _dimenssion(themeProvider, "new_password"),
                        _isloading
                            ? ShimmerWidget.circular(
                                hight: MediaQuery.of(context).size.height /
                                    18.04444444444444, //45
                                width: MediaQuery.of(context).size.width,
                                shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height /
                                          81.2),
                                ),
                              )
                            : CustomTextFieldPassward(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _newPasswordFocus,
                                controller: _newPassword,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
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
                                      _obscureTextNewPass =
                                          !_obscureTextNewPass;
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/images/show.png",
                                    color: _newPasswordFocus.hasFocus
                                        ? themeProvider.isDarkMode
                                            ? mainAppColor
                                            : mainAppColor
                                        : hintColor,
                                  ),
                                ),
                                hintText: AppLocalizations.of(context)!
                                    .translate("new_password"),
                                obscureText: _obscureTextNewPass,
                                inputData: TextInputType.emailAddress,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "you must Enter your Passward");
                                  }
                                  if (_newPassword.text !=
                                      _confirmPassword.text) {
                                    return AppLocalizations.of(context)!.translate(
                                        "Password and Conform Password Not Same");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _newPasswordFocus.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _newPasswordFocus.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _newPasswordFocus.unfocus(),
                              ),
                        _isloading
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        54.13333333333333, //15
                                  ),
                                  ShimmerWidget.circular(
                                    hight: MediaQuery.of(context).size.height /
                                        32.48, //25
                                    width: MediaQuery.of(context).size.width /
                                        7.5, //50
                                    shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height /
                                              81.2 //10
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        81.2,
                                  )
                                ],
                              )
                            : _dimenssion(
                                themeProvider, "confirm_new_password"),
                        _isloading
                            ? ShimmerWidget.circular(
                                hight: MediaQuery.of(context).size.height /
                                    18.04444444444444, //45
                                width: MediaQuery.of(context).size.width,
                                shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height /
                                          81.2),
                                ),
                              )
                            : CustomTextFieldPassward(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _confirmPasswordFocus,
                                controller: _confirmPassword,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
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
                                      _obscureTextConfirmPass =
                                          !_obscureTextConfirmPass;
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/images/show.png",
                                    color: _confirmPasswordFocus.hasFocus
                                        ? themeProvider.isDarkMode
                                            ? mainAppColor
                                            : mainAppColor
                                        : hintColor,
                                  ),
                                ),
                                hintText: AppLocalizations.of(context)!
                                    .translate("confirm_new_password"),
                                obscureText: _obscureTextConfirmPass,
                                inputData: TextInputType.emailAddress,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "you must Enter your Passward");
                                  }
                                  if (_newPassword.text !=
                                      _confirmPassword.text) {
                                    return AppLocalizations.of(context)!.translate(
                                        "Password and Conform Password Not Same");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _confirmPasswordFocus.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _confirmPasswordFocus.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _confirmPasswordFocus.unfocus(),
                              ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height / 20.3, //40
                        ),
                        _isloading
                            ? ShimmerWidget.circular(
                                hight: MediaQuery.of(context).size.height /
                                    18.04444444444444, //45
                                width: MediaQuery.of(context).size.width,
                                shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height /
                                          81.2),
                                ),
                              )
                            : CustomButton(
                                width: MediaQuery.of(context).size.width /
                                    1.093294460641399, //343
                                height: MediaQuery.of(context).size.height /
                                    16.24, //50

                                btnLbl: "التالي",
                                onPressedFunction: userLogIn,
                                btnColor: mainAppColor,
                                btnStyle: Theme.of(context).textTheme.button!,
                                horizontalMargin: 0,
                                verticalMargin: 0,
                                lightBorderColor: mainAppColor,
                                darkBorderColor: mainAppColor,
                                addtionalWidgit: true,
                                child: Center(
                                  child: SmallText(
                                    text: AppLocalizations.of(context)!
                                        .translate("save edits"),
                                    color: blackColor,
                                    typeOfFontWieght: 1,
                                    size: MediaQuery.of(context).size.height /
                                        58, //14
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _dimenssion(ThemeProvider themeProvider, String name) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 54.13333333333333, //15
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0), //5
          child: SmallText(
            typeOfFontWieght: 0,
            text: AppLocalizations.of(context)!.translate("$name"),
            color: themeProvider.isDarkMode ? whiteColor : blackColor,
            size: MediaQuery.of(context).size.height / 62.46153846153846, //13
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 54.13333333333333, //15
        ),
      ],
    );
  }

  userLogIn() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final changePasswordError =
        Provider.of<ChangePasswordError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    final serverError = Provider.of<ServerError>(context, listen: false);
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final body = {
        "user_id": UserData.getUserId(),
        "old_password": _oldPassword.text,
        "password": _newPassword.text,
        "password_confirmation": _confirmPassword.text,
      };

      setState(() {
        _isloading = true;
      });

      final response = await clientApi.post(
        Uri.parse(Urls.CHANGE_PASSWORD_URL),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "Accept-Language": "en",
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        setState(
          () {
            _isloading = false;

            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: successOperation(
                      operationName: "password changed successfully"),
                );
              },
            );
          },
        );
      } else if (response.statusCode == 401) {
        unauthorizedError.unauthorizedErrors401(context);
        setState(() {
          _isloading = false;
        });
      } else if (response.statusCode == 422) {
        var _body = jsonDecode(response.body);

        setState(() {
          changePasswordError.changePasswordError422(context, _body);
          _isloading = false;
        });
      } else if (response.statusCode == 403) {
        setState(() {
          erro403.error403(context, response.statusCode);
          _isloading = false;
        });
      } else {
        setState(() {
          serverError.serverError(context, response.statusCode);
          _isloading = false;
        });
      }
    }
  }
}
