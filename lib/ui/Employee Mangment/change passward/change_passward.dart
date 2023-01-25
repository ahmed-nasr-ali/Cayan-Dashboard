// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks, must_be_immutable, non_constant_identifier_names

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/customtextfiledforpassward/custom_text_form_feild_passward.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/change%20password%20error/change_password_error.dart';

import 'package:cayan/network/api_errors/server%20error/server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Employee%20Mangment/employee%20mangement%20screen/employee_mangement_screen.dart';

import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class ChangePassward extends StatefulWidget {
  int userId;
  ChangePassward({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ChangePassward> createState() => _ChangePasswardState();
}

class _ChangePasswardState extends State<ChangePassward> {
  late FocusNode _passwardFocusNode;
  late FocusNode _confirmPasswardFocusNode;

  final TextEditingController _userPassward = TextEditingController();
  final TextEditingController _ConfirmUserPassward = TextEditingController();

  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  bool _isLoading = false;

  final formKey = GlobalKey<FormState>();

  bool containerHeght = true;

  @override
  void initState() {
    super.initState();
    _passwardFocusNode = FocusNode();
    _confirmPasswardFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _confirmPasswardFocusNode.dispose();
    _passwardFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return NetworkIndicator(
      child: DraggableScrollableSheet(
        initialChildSize: containerHeght ? 0.53 : 0.6,
        //  isValidate ? 0.94 : 0.8608374384236453, //699 584
        maxChildSize: containerHeght ? 0.53 : 0.6,
        // isValidate ? 0.94 : 0.8608374384236453,
        minChildSize: 0.4,
        builder: (context, scrollController) => GestureDetector(
          onTap: () {
            setState(() {
              _confirmPasswardFocusNode.unfocus();
              _passwardFocusNode.unfocus();
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width, //width
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      MediaQuery.of(context).size.height / 81.2), //10
                  topRight: Radius.circular(
                      MediaQuery.of(context).size.height / 81.2)),
              color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
            ),
            child: Form(
              key: formKey,
              child: ListView(
                controller: scrollController,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            54.13333333333333, //15
                      ),
                      Center(
                        child: Container(
                          // margin: EdgeInsets.symmetric(horizontal: 0),
                          width: MediaQuery.of(context).size.width / 9.375, //40
                          height:
                              MediaQuery.of(context).size.height / 162.4, //5
                          decoration: BoxDecoration(
                              color: themeProvider.isDarkMode
                                  ? dividerDarkColor
                                  : containerColor,
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height /
                                      162.4)), //5
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40.6,
                      ), //20
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 25),
                              child: ShimmerWidget.circular(
                                hight:
                                    MediaQuery.of(context).size.height / 32.48,
                                width: MediaQuery.of(context).size.width / 3,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          23.4375), //16
                              child: SmallText(
                                text: AppLocalizations.of(context)!
                                    .translate("change passward"),
                                color: themeProvider.isDarkMode
                                    ? whiteColor
                                    : blackColor,
                                size: MediaQuery.of(context).size.height /
                                    50.75, //16
                                typeOfFontWieght: 1,
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 162.4,
                      ), //5
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 25),
                              child: ShimmerWidget.circular(
                                hight: MediaQuery.of(context).size.height /
                                    32.48, //25
                                width: MediaQuery.of(context).size.width /
                                    1.794258373205742, //209
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          23.4375), //16
                              child: SmallText(
                                text: AppLocalizations.of(context)!.translate(
                                  "will change password and exist user from all divces \n connect now and must to enter new passward",
                                ),
                                size: MediaQuery.of(context).size.height /
                                    58, //14
                                align: TextAlign.start,
                                textHight: 2,
                                color: textGrayColor,
                              ),
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            27.06666666666667, //30
                      ),

                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
                                children: [
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
                                ],
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          23.4375), //16,
                              child: SmallText(
                                text: AppLocalizations.of(context)!
                                    .translate("new_password"),
                                color: themeProvider.isDarkMode
                                    ? whiteColor
                                    : blackColor,
                                size: MediaQuery.of(context).size.height /
                                    62.46153846153846, //13
                              ),
                            ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height /
                              54.13333333333333), //15
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: ShimmerWidget.circular(
                                  hight: MediaQuery.of(context).size.height /
                                      18.04444444444444, //45
                                  width: MediaQuery.of(context).size.width,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height /
                                              81.2))),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          23.4375), //16,
                              child: CustomTextFieldPassward(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _passwardFocusNode,
                                controller: _userPassward,
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
                                    .translate("new_password"),
                                obscureText: _obscureText,
                                inputData: TextInputType.emailAddress,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      containerHeght = false;
                                    });
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "you must Enter your Passward");
                                  }
                                  if (_userPassward.text !=
                                      _ConfirmUserPassward.text) {
                                    setState(() {
                                      containerHeght = false;
                                    });
                                    return AppLocalizations.of(context)!.translate(
                                        "Password and Conform Password Not Same");
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
                            ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height /
                              54.13333333333333), //15

                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
                                children: [
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
                                ],
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          23.4375), //16,
                              child: SmallText(
                                text: AppLocalizations.of(context)!
                                    .translate("confirm_new_password"),
                                color: themeProvider.isDarkMode
                                    ? whiteColor
                                    : blackColor,
                                size: MediaQuery.of(context).size.height /
                                    62.46153846153846, //13
                              ),
                            ),

                      SizedBox(
                          height: MediaQuery.of(context).size.height /
                              54.13333333333333), //15
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: ShimmerWidget.circular(
                                  hight: MediaQuery.of(context).size.height /
                                      18.04444444444444, //45
                                  width: MediaQuery.of(context).size.width,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height /
                                              81.2))),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          23.4375), //16,
                              child: CustomTextFieldPassward(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _confirmPasswardFocusNode,
                                controller: _ConfirmUserPassward,
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
                                      _obscureTextConfirm =
                                          !_obscureTextConfirm;
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/images/show.png",
                                    color: _confirmPasswardFocusNode.hasFocus
                                        ? themeProvider.isDarkMode
                                            ? mainAppColor
                                            : mainAppColor
                                        : hintColor,
                                  ),
                                ),
                                hintText: AppLocalizations.of(context)!
                                    .translate("confirm_new_password"),
                                obscureText: _obscureTextConfirm,
                                inputData: TextInputType.emailAddress,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      containerHeght = false;
                                    });
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "you must Enter your Passward");
                                  }
                                  if (_userPassward.text !=
                                      _ConfirmUserPassward.text) {
                                    setState(() {
                                      containerHeght = false;
                                    });
                                    return AppLocalizations.of(context)!.translate(
                                        "Password and Conform Password Not Same");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _confirmPasswardFocusNode.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _confirmPasswardFocusNode.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _confirmPasswardFocusNode.unfocus(),
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40.6,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width /
                                  23.4375), //16,
                          child: _saveAndCancledButton(themeProvider)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _saveAndCancledButton(ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _isLoading
            ? ShimmerWidget.circular(
                hight:
                    MediaQuery.of(context).size.height / 18.04444444444444, //45
                width:
                    MediaQuery.of(context).size.width / 2.272727272727273, //165
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              )
            : CustomButton(
                height:
                    MediaQuery.of(context).size.height / 18.04444444444444, //45
                width:
                    MediaQuery.of(context).size.width / 2.272727272727273, //165
                btnLbl: "موافق",
                onPressedFunction: changeEmployeePasswoedMethed,
                btnColor: mainAppColor,
                btnStyle: TextStyle(color: blackColor),
                horizontalMargin: 0,
                verticalMargin: 0,
                lightBorderColor: mainAppColor,
                darkBorderColor: mainAppColor,
                addtionalWidgit: false,
                child: Center(
                  child: SmallText(
                    text: AppLocalizations.of(context)!.translate("agree"),
                    color: themeProvider.isDarkMode ? blackColor : blackColor,
                    typeOfFontWieght: 1,
                  ),
                ),
              ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 37.5, //10,
        ),
        _isLoading
            ? ShimmerWidget.circular(
                hight:
                    MediaQuery.of(context).size.height / 18.04444444444444, //45
                width:
                    MediaQuery.of(context).size.width / 2.272727272727273, //165
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              )
            : CustomButton(
                height:
                    MediaQuery.of(context).size.height / 18.04444444444444, //45
                width:
                    MediaQuery.of(context).size.width / 2.272727272727273, //165
                btnLbl: "الغاء",
                onPressedFunction: () {
                  Navigator.pop(context);
                },
                btnColor:
                    themeProvider.isDarkMode ? Color(0xff292828) : whiteColor,
                btnStyle: TextStyle(color: blackColor),
                horizontalMargin: 0,
                verticalMargin: 0,
                lightBorderColor: blackColor,
                darkBorderColor: Color(0xff292828),
                addtionalWidgit: false,
                child: Center(
                  child: SmallText(
                    text: AppLocalizations.of(context)!.translate("cancel"),
                    color: themeProvider.isDarkMode ? whiteColor : blackColor,
                    typeOfFontWieght: 1,
                  ),
                ),
              ),
      ],
    );
  }

  changeEmployeePasswoedMethed() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final changePasswordError =
        Provider.of<ChangePasswordError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    final serverError = Provider.of<ServerError>(context, listen: false);

    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final body = {
        "user_id": widget.userId,
        "password": _userPassward.text,
        "password_confirmation": _ConfirmUserPassward.text,
      };
      setState(() {
        _isLoading = true;
      });
      final response = await post(
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
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        Navigator.push(context,
            MaterialPageRoute(builder: (_) => EmployeeMangementScreen()));

        setState(() {
          _isLoading = false;

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
              });
        });
      } else if (response.statusCode == 401) {
        unauthorizedError.unauthorizedErrors401(context);
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 422) {
        var _body = jsonDecode(response.body);
        setState(() {
          changePasswordError.changePasswordError422(context, _body);
          _isLoading = false;
        });
      } else if (response.statusCode == 403) {
        setState(() {
          erro403.error403(context, response.statusCode);
          _isLoading = false;
        });
      } else {
        setState(() {
          serverError.serverError(context, response.statusCode);
          _isLoading = false;
        });
      }
    }
  }
}
