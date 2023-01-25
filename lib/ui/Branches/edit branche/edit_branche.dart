// ignore_for_file: must_be_immutable, unused_local_variable, unused_field, prefer_final_fields, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations, unused_element, nullable_type_in_catch_clause, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, prefer_if_null_operators, use_build_context_synchronously, unused_catch_clause, empty_catches

import 'dart:io';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/customtextformfield/custom_text_form_feild.dart';
import 'package:cayan/custom_widgets/open%20image/open_image.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/branche%20error/branche_error.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Branches/branch%20screen/branch_screen.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditBranche extends StatefulWidget {
  int userId;
  String userArbicName;
  String userEnglisName;
  String cityArbicName;
  String cityEnglishName;
  String adressArbicName;
  String adressEnglishName;
  String userArbicDescription;
  String userEnglisDescription;
  String telephone;
  String whatsApp;
  String map;
  String userImage;
  EditBranche({
    Key? key,
    required this.userId,
    required this.userArbicName,
    required this.userEnglisName,
    required this.cityArbicName,
    required this.cityEnglishName,
    required this.adressArbicName,
    required this.adressEnglishName,
    required this.userArbicDescription,
    required this.userEnglisDescription,
    required this.telephone,
    required this.whatsApp,
    required this.map,
    required this.userImage,
  }) : super(key: key);

  @override
  State<EditBranche> createState() => _EditBrancheState();
}

class _EditBrancheState extends State<EditBranche> {
  File? imageSend;

  int imageChoosen = 0;

  late FocusNode _brancheFouceArbicName;
  late FocusNode _brancheFouceEnglishName;

  late FocusNode _brancheFouceArbicCity;
  late FocusNode _brancheFouceEnglishCity;

  late FocusNode _brancheFouceArbicAdress;
  late FocusNode _brancheFouceEnglishAdress;

  late FocusNode _brancheFouceDescribtionArbic;
  late FocusNode _brancheFouceDescribtionEnglish;

  late FocusNode _brancheFouceTelephone;
  late FocusNode _brancheFouceWhatsapp;
  late FocusNode _brancheFouceMap;

  TextEditingController _brancheNameArbic = TextEditingController();
  TextEditingController _brancheNameEnglish = TextEditingController();

  TextEditingController _brancheCityArbic = TextEditingController();
  TextEditingController _brancheCityEnglish = TextEditingController();

  TextEditingController _brancheAdressArbic = TextEditingController();
  TextEditingController _brancheAdresssEnglish = TextEditingController();

  TextEditingController _brancheDescribtionArbic = TextEditingController();
  TextEditingController _brancheDescribtionEnglish = TextEditingController();

  TextEditingController _brancheTelephone = TextEditingController();
  TextEditingController _brancheWhatsapp = TextEditingController();
  TextEditingController _brancheMap = TextEditingController();

  bool _isLoading = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _brancheFouceArbicName = FocusNode();
    _brancheFouceEnglishName = FocusNode();

    _brancheFouceArbicCity = FocusNode();
    _brancheFouceEnglishCity = FocusNode();

    _brancheFouceArbicAdress = FocusNode();
    _brancheFouceEnglishAdress = FocusNode();

    _brancheFouceDescribtionArbic = FocusNode();
    _brancheFouceDescribtionEnglish = FocusNode();

    _brancheFouceTelephone = FocusNode();
    _brancheFouceWhatsapp = FocusNode();
    _brancheFouceMap = FocusNode();

    _brancheNameArbic.text = "${widget.userArbicName} ";

    _brancheNameEnglish.text = "${widget.userEnglisName} ";

    _brancheCityArbic.text = "${widget.cityArbicName} ";

    _brancheCityEnglish.text = "${widget.cityEnglishName} ";

    _brancheAdressArbic.text = "${widget.adressArbicName} ";

    _brancheAdresssEnglish.text = "${widget.adressEnglishName} ";

    _brancheDescribtionArbic.text = "${widget.userArbicDescription} ";

    _brancheDescribtionEnglish.text = "${widget.userEnglisDescription} ";

    _brancheTelephone.text = "${widget.telephone} ";

    _brancheWhatsapp.text = "${widget.whatsApp} ";

    _brancheMap.text = "${widget.map} ";
  }

  @override
  void dispose() {
    super.dispose();

    _brancheFouceArbicName.dispose();
    _brancheFouceEnglishName.dispose();

    _brancheFouceArbicCity.dispose();
    _brancheFouceEnglishCity.dispose();

    _brancheFouceArbicAdress.dispose();
    _brancheFouceEnglishAdress.dispose();

    _brancheFouceDescribtionArbic.dispose();
    _brancheFouceDescribtionEnglish.dispose();

    _brancheFouceTelephone.dispose();
    _brancheFouceWhatsapp.dispose();
    _brancheFouceMap.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return NetworkIndicator(
      child: DraggableScrollableSheet(
        initialChildSize: .955,
        //  isValidate ? 0.94 : 0.8608374384236453, //699 584
        maxChildSize: 0.955,
        // isValidate ? 0.94 : 0.8608374384236453,
        minChildSize: 0.5,
        builder: (context, scrollController) => GestureDetector(
          onTap: () {
            setState(
              () {
                _brancheFouceArbicName.unfocus();
                _brancheFouceEnglishName.unfocus();

                _brancheFouceArbicCity.unfocus();
                _brancheFouceEnglishCity.unfocus();

                _brancheFouceArbicAdress.unfocus();
                _brancheFouceEnglishAdress.unfocus();

                _brancheFouceDescribtionArbic.unfocus();
                _brancheFouceDescribtionEnglish.unfocus();

                _brancheFouceTelephone.unfocus();
                _brancheFouceWhatsapp.unfocus();
                _brancheFouceMap.unfocus();
              },
            );
          },
          child: Container(
            // height: MediaQuery.of(context).size.height / 1.16, //700
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      MediaQuery.of(context).size.height / 81.2),
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
                          width: MediaQuery.of(context).size.width / 9.375, //40
                          height:
                              MediaQuery.of(context).size.height / 162.4, //5
                          decoration: BoxDecoration(
                            color: themeProvider.isDarkMode
                                ? dividerDarkColor
                                : containerColor,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height / 162.4),
                          ), //5
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40.6, //20
                      ),
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
                              child: BigText(
                                text: AppLocalizations.of(context)!
                                    .translate("edit new branche"),
                                typeOfFontWieght: 1,
                                size: MediaQuery.of(context).size.height /
                                    50.75, //16
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            135.3333333333333, //6
                      ),
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
                                  "Fill in the following information to create a new branche",
                                ),
                                size: MediaQuery.of(context).size.height /
                                    58, //14
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40.6, //20
                      ),
                      Divider(
                        color: themeProvider.isDarkMode
                            ? Color(0xff363637)
                            : containerColor,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40.6, //20
                      ),
                      _isLoading
                          ? Column(
                              children: [
                                Center(
                                  child: ShimmerWidget.circular(
                                      hight:
                                          MediaQuery.of(context).size.height /
                                              9.552941176470588,
                                      //85
                                      width: MediaQuery.of(context).size.width /
                                          4.411764705882353 //85
                                      ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height /
                                      81.2, //10
                                ),
                                ShimmerWidget.circular(
                                  width: MediaQuery.of(context).size.width /
                                      3.125, //120
                                  hight: MediaQuery.of(context).size.height /
                                      40.6, //20
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height /
                                              162.4 //5
                                          )),
                                )
                              ],
                            )
                          : _addOfferPhoto(themeProvider),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50.75, //16
                      ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
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
                              ),
                            )
                          : _dimenssion(themeProvider, "Name in arbic"),
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
                                      MediaQuery.of(context).size.height /
                                          50.75), //16
                              child: CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _brancheFouceArbicName,
                                controller: _brancheNameArbic,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl: "assets/images/note.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.userArbicName,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _brancheNameArbic.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate("Name in arbic is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _brancheFouceArbicName.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _brancheFouceArbicName.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _brancheFouceArbicName.unfocus(),
                              ),
                            ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
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
                              ),
                            )
                          : _dimenssion(themeProvider, "Name in english"),
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
                                      MediaQuery.of(context).size.height /
                                          50.75), //16
                              child: CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _brancheFouceEnglishName,
                                controller: _brancheNameEnglish,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl: "assets/images/note.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.userEnglisName,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _brancheNameEnglish.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "Name in english is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _brancheFouceEnglishName.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _brancheFouceEnglishName.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _brancheFouceEnglishName.unfocus(),
                              ),
                            ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
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
                              ),
                            )
                          : _dimenssion(themeProvider, "City in arbic"),
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
                                      MediaQuery.of(context).size.height /
                                          50.75), //16
                              child: CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _brancheFouceArbicCity,
                                controller: _brancheCityArbic,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl:
                                    "assets/images/locationgrey.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.cityArbicName,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _brancheCityArbic.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate("City in arbic is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _brancheFouceArbicCity.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _brancheFouceArbicCity.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _brancheFouceArbicCity.unfocus(),
                              ),
                            ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
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
                              ),
                            )
                          : _dimenssion(themeProvider, "City in english"),
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
                                      MediaQuery.of(context).size.height /
                                          50.75), //16
                              child: CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _brancheFouceEnglishCity,
                                controller: _brancheCityEnglish,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl:
                                    "assets/images/locationgrey.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.cityEnglishName,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _brancheCityEnglish.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "City in english is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _brancheFouceEnglishCity.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _brancheFouceEnglishCity.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _brancheFouceEnglishCity.unfocus(),
                              ),
                            ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
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
                              ),
                            )
                          : _dimenssion(themeProvider, "Adress in arbic"),
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
                                      MediaQuery.of(context).size.height /
                                          50.75), //16
                              child: CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _brancheFouceArbicAdress,
                                controller: _brancheAdressArbic,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl:
                                    "assets/images/locationgrey.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.adressArbicName,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _brancheAdressArbic.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "Adress in arbic is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _brancheFouceArbicAdress.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _brancheFouceArbicAdress.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _brancheFouceArbicAdress.unfocus(),
                              ),
                            ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
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
                              ),
                            )
                          : _dimenssion(themeProvider, "Adress in english"),
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
                                      MediaQuery.of(context).size.height /
                                          50.75), //16
                              child: CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _brancheFouceEnglishAdress,
                                controller: _brancheAdresssEnglish,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl:
                                    "assets/images/locationgrey.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.adressEnglishName,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _brancheAdresssEnglish.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "Adress in english is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _brancheFouceEnglishAdress.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _brancheFouceEnglishAdress.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _brancheFouceEnglishAdress.unfocus(),
                              ),
                            ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
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
                              ),
                            )
                          : _dimenssion(themeProvider, "Map link"),
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
                                      MediaQuery.of(context).size.height /
                                          50.75), //16
                              child: CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _brancheFouceMap,
                                controller: _brancheMap,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl:
                                    "assets/images/locationgrey.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.map,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _brancheMap.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate("Map link is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _brancheFouceMap.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _brancheFouceMap.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _brancheFouceMap.unfocus(),
                              ),
                            ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
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
                              ),
                            )
                          : _dimenssion(themeProvider, "what's up"),
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
                                      MediaQuery.of(context).size.height /
                                          50.75), //16
                              child: CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _brancheFouceWhatsapp,
                                controller: _brancheWhatsapp,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl:
                                    "assets/images/whatsappgrey.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.whatsApp,
                                inputData: TextInputType.number,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _brancheWhatsapp.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate("what's up is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _brancheFouceWhatsapp.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _brancheFouceWhatsapp.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _brancheFouceWhatsapp.unfocus(),
                              ),
                            ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
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
                              ),
                            )
                          : _dimenssion(themeProvider, "Phone number"),
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
                                      MediaQuery.of(context).size.height /
                                          50.75), //16
                              child: CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _brancheFouceTelephone,
                                controller: _brancheTelephone,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl: "assets/images/phonegrey.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.telephone,
                                inputData: TextInputType.number,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _brancheTelephone.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate("Phone number is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _brancheFouceTelephone.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _brancheFouceTelephone.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _brancheFouceTelephone.unfocus(),
                              ),
                            ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
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
                              ),
                            )
                          : _dimenssion(themeProvider,
                              "Detailed description of the branch in arbic"),
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
                                      MediaQuery.of(context).size.height /
                                          50.75), //16
                              child: CustomTextField(
                                contentPadding:
                                    MediaQuery.of(context).size.width /
                                        18.75, //20
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 4,
                                focusNode: _brancheFouceDescribtionArbic,
                                controller: _brancheDescribtionArbic,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: false,
                                ispreffixImage: false,
                                preffixImageUrl: "assets/images/userac.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.userArbicDescription,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _brancheDescribtionArbic.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate(
                                        "Detailed description of the branch in arbic is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _brancheFouceDescribtionArbic.hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _brancheFouceDescribtionArbic.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _brancheFouceDescribtionArbic.unfocus(),
                              ),
                            ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
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
                              ),
                            )
                          : _dimenssion(themeProvider,
                              "Detailed description of the branch in english"),
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
                                      MediaQuery.of(context).size.height /
                                          50.75), //16
                              child: CustomTextField(
                                contentPadding:
                                    MediaQuery.of(context).size.width /
                                        18.75, //20
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 4,
                                focusNode: _brancheFouceDescribtionEnglish,
                                controller: _brancheDescribtionEnglish,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: false,
                                ispreffixImage: false,
                                preffixImageUrl: "assets/images/userac.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.userEnglisDescription,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _brancheDescribtionEnglish.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate(
                                        "Detailed description of the branch in english is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _brancheFouceDescribtionEnglish.hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _brancheFouceDescribtionEnglish.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _brancheFouceDescribtionEnglish.unfocus(),
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            27.06666666666667, //30
                      ),
                      _saveAndCancledButton(themeProvider),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40.6,
                      )
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

  void openGallery() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OpenImage(
              imageSend: imageSend != null ? imageSend : null,
              userImage: widget.userImage),
        ),
      );

  _addOfferPhoto(ThemeProvider themeProvider) {
    return Column(children: [
      Center(
        child: InkWell(
          onTap: openGallery,
          child: ClipOval(
            child: CircleAvatar(
              backgroundColor:
                  themeProvider.isDarkMode ? containerdarkColor : whiteColor,
              radius: MediaQuery.of(context).size.height / 20.3, // 40 todo
              child: Container(
                height:
                    MediaQuery.of(context).size.height / 9.552941176470588, //85
                width:
                    MediaQuery.of(context).size.width / 4.411764705882353, //85
                child: imageSend != null
                    ? Image.file(
                        imageSend!,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.userImage,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 135.3333333333333, //6
      ),
      InkWell(
        onTap: () {
          pickImage();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/changepic.png"),
            SizedBox(
              width: MediaQuery.of(context).size.width / 62.5, //6
            ),
            Text(
              AppLocalizations.of(context)!.translate("Add a profile picture"),
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: mainAppColor,
                  fontSize: MediaQuery.of(context).size.height /
                      67.66666666666667, //12
                  fontFamily: "RB"),
            ),
          ],
        ),
      )
    ]);
  }

  Future pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final ImageTemporary = File(image.path);
      setState(() {
        imageSend = ImageTemporary;
        imageChoosen = 1;
      });
    } on PlatformException catch (e) {}
  }

  _dimenssion(ThemeProvider themeProvider, String name) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 54.13333333333333, //15
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 23.4375), //16
          child: SmallText(
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

  _saveAndCancledButton(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _isLoading
              ? ShimmerWidget.circular(
                  hight: MediaQuery.of(context).size.height /
                      18.04444444444444, //45
                  width: MediaQuery.of(context).size.width /
                      2.272727272727273, //165
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                )
              : CustomButton(
                  height: MediaQuery.of(context).size.height /
                      18.04444444444444, //45
                  width: MediaQuery.of(context).size.width /
                      2.272727272727273, //165
                  btnLbl: "حفظ",
                  onPressedFunction: _editBrancheMethod,
                  btnColor: mainAppColor,
                  btnStyle: TextStyle(color: blackColor),
                  horizontalMargin: 0,
                  verticalMargin: 0,
                  lightBorderColor: mainAppColor,
                  darkBorderColor: mainAppColor,
                  addtionalWidgit: false,
                  child: Center(
                    child: SmallText(
                      text: AppLocalizations.of(context)!.translate("add"),
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
                  hight: MediaQuery.of(context).size.height /
                      18.04444444444444, //45
                  width: MediaQuery.of(context).size.width /
                      2.272727272727273, //165
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                )
              : CustomButton(
                  height: MediaQuery.of(context).size.height /
                      18.04444444444444, //45
                  width: MediaQuery.of(context).size.width /
                      2.272727272727273, //165
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
      ),
    );
  }

  _editBrancheMethod() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final storError = Provider.of<BrancheStoreError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });

      String? fileName =
          imageChoosen == 1 ? imageSend!.path.split('/').last : "";

      FormData formData = FormData.fromMap({
        "ar[name]": _brancheNameArbic.text,
        "en[name]": _brancheNameEnglish.text,
        "ar[city]": _brancheCityArbic.text,
        "en[city]": _brancheCityEnglish.text,
        "ar[address]": _brancheAdressArbic.text,
        "en[address]": _brancheAdresssEnglish.text,
        "ar[full_description]": _brancheDescribtionArbic.text,
        "en[full_description]": _brancheDescribtionEnglish.text,
        "telephone": _brancheTelephone.text,
        "whatsapp": _brancheWhatsapp.text,
        "map": _brancheMap.text,
        "image": imageChoosen == 1
            ? await MultipartFile.fromFile(imageSend!.path, filename: fileName)
            : null,
      });

      final response = await Dio().post(
        ("${Urls.EDIT_BRANCHE_URL}${widget.userId}"),
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          followRedirects: false,
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            "Accept-Language": UserData.getUSerLang(),
            "Authorization": "Bearer ${UserData.getUserApiToken()}"
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => BrancheScreen()));
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: successOperation(
                      operationName: "edit branche successfully"),
                );
              });
        });
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        unauthorizedError.unauthorizedErrors401(context);
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 422) {
        setState(() {
          storError.brancheStoreError442(context, response.data);
          _isLoading = false;
        });
      } else if (response.statusCode == 403) {
        setState(() {
          erro403.error403(context, response.statusCode!);
          _isLoading = false;
        });
      } else {
        setState(() {
          homeServerError.serverError(context, response.statusCode!);
          _isLoading = false;
        });
      }
    }
  }
}
