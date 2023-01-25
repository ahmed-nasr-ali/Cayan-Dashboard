// ignore_for_file: non_constant_identifier_names, must_be_immutable, unused_field, prefer_final_fields, unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations, unused_element, avoid_print, nullable_type_in_catch_clause, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, prefer_if_null_operators, use_build_context_synchronously

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
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/project%20error/project_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Projects/project%20screen/project_screen.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProject extends StatefulWidget {
  int userId;
  String userArbicName;
  String userEnglisName;
  String userArbicclassification;
  String userEnglisclassification;
  String userShortArbicDescription;
  String userShortEnglisDescription;
  String userArbicFullDescription;
  String userEnglisFullDescription;
  String userimage;
  EditProject({
    Key? key,
    required this.userId,
    required this.userArbicName,
    required this.userEnglisName,
    required this.userArbicclassification,
    required this.userEnglisclassification,
    required this.userShortArbicDescription,
    required this.userShortEnglisDescription,
    required this.userArbicFullDescription,
    required this.userEnglisFullDescription,
    required this.userimage,
  }) : super(key: key);

  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  File? imageSend;

  int imageChoosen = 0;

  late FocusNode _projectFouceArbicName;
  late FocusNode _projectFouceEnglishName;

  late FocusNode _projectFouceArbicClassification;
  late FocusNode _projectFouceEnglisClassification;

  late FocusNode _projectFouceArbicShortDescribtion;
  late FocusNode _projectFouceEnglishShortDescribtion;

  late FocusNode _projectFouceArbicFullDescribtion;
  late FocusNode _projectFouceEnglisFullhDescribtion;

  TextEditingController _projectNameArbic = TextEditingController();
  TextEditingController _projectNameEnglish = TextEditingController();

  TextEditingController _projectClassificationArbic = TextEditingController();
  TextEditingController _projectClassificationEnglish = TextEditingController();

  TextEditingController _projectFullDescribtionArbic = TextEditingController();
  TextEditingController _projectFullDescribtionEnglish =
      TextEditingController();

  TextEditingController _projectShortDescribtionArbic = TextEditingController();
  TextEditingController _projectShortDescribtionEnglish =
      TextEditingController();

  bool _isLoading = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _projectFouceArbicName = FocusNode();
    _projectFouceEnglishName = FocusNode();

    _projectFouceArbicClassification = FocusNode();
    _projectFouceEnglisClassification = FocusNode();

    _projectFouceArbicShortDescribtion = FocusNode();
    _projectFouceEnglishShortDescribtion = FocusNode();

    _projectFouceArbicFullDescribtion = FocusNode();
    _projectFouceEnglisFullhDescribtion = FocusNode();

    _projectNameArbic.text = "${widget.userArbicName} ";
    _projectNameEnglish.text = "${widget.userEnglisName} ";

    _projectClassificationArbic.text = "${widget.userArbicclassification} ";
    _projectClassificationEnglish.text = "${widget.userEnglisclassification} ";

    _projectShortDescribtionArbic.text = "${widget.userShortArbicDescription} ";
    _projectShortDescribtionEnglish.text =
        "${widget.userShortEnglisDescription} ";

    _projectFullDescribtionArbic.text = "${widget.userArbicFullDescription} ";
    _projectFullDescribtionEnglish.text =
        "${widget.userEnglisFullDescription} ";
  }

  @override
  void dispose() {
    super.dispose();
    _projectFouceArbicName.dispose();
    _projectFouceEnglishName.dispose();

    _projectFouceArbicClassification.dispose();
    _projectFouceEnglisClassification.dispose();

    _projectFouceArbicShortDescribtion.dispose();
    _projectFouceEnglishShortDescribtion.dispose();

    _projectFouceArbicFullDescribtion.dispose();
    _projectFouceEnglisFullhDescribtion.dispose();
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
            _projectFouceArbicName.unfocus();
            _projectFouceEnglishName.unfocus();

            _projectFouceArbicClassification.unfocus();
            _projectFouceEnglisClassification.unfocus();

            _projectFouceArbicShortDescribtion.unfocus();
            _projectFouceEnglishShortDescribtion.unfocus();

            _projectFouceArbicFullDescribtion.unfocus();
            _projectFouceEnglisFullhDescribtion.unfocus();
          },
          child: Container(
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
                                    .translate("Edit project"),
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
                                  "Edit the project and change its data",
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
                          : _dimenssion(themeProvider, "project name in Arbic"),
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
                                focusNode: _projectFouceArbicName,
                                controller: _projectNameArbic,
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
                                      _projectNameArbic.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                      "project name in Arbicis requied",
                                    );
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _projectFouceArbicName.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _projectFouceArbicName.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _projectFouceArbicName.unfocus(),
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
                          : _dimenssion(
                              themeProvider, "project name in English"),
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
                                focusNode: _projectFouceEnglishName,
                                controller: _projectNameEnglish,
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
                                      _projectNameEnglish.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                      "project name in English is requied",
                                    );
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _projectFouceEnglishName.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _projectFouceEnglishName.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _projectFouceEnglishName.unfocus(),
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
                          : _dimenssion(
                              themeProvider, "Classification Project in Arbic"),
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
                                focusNode: _projectFouceArbicClassification,
                                controller: _projectClassificationArbic,
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
                                hintText: widget.userArbicclassification,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _projectClassificationArbic.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                      "Classification Project in Arbic is requied",
                                    );
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _projectFouceArbicClassification.hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _projectFouceArbicClassification.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _projectFouceArbicClassification.unfocus(),
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
                          : _dimenssion(
                              themeProvider,
                              "Classification Project in English",
                            ),
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
                                focusNode: _projectFouceEnglisClassification,
                                controller: _projectClassificationEnglish,
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
                                hintText: widget.userEnglisclassification,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _projectClassificationEnglish.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                      "Classification Project in English is requied",
                                    );
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _projectFouceEnglisClassification
                                            .hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _projectFouceEnglisClassification.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _projectFouceEnglisClassification.unfocus(),
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
                          : _dimenssion(
                              themeProvider, "Description Project in Arbic"),
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
                                    MediaQuery.of(context).size.width / 25,
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _projectFouceArbicShortDescribtion,
                                controller: _projectShortDescribtionArbic,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: false,
                                ispreffixImage: false,
                                preffixImageUrl: "assets/images/Coupon.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.userShortArbicDescription,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _projectShortDescribtionArbic.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                      "Description Project in Arbic is requied",
                                    );
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _projectFouceArbicShortDescribtion
                                            .hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _projectFouceArbicShortDescribtion
                                        .unfocus(),
                                onFieldSubmitted: (_) =>
                                    _projectFouceArbicShortDescribtion
                                        .unfocus(),
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
                              "Description Project in English is requied"),
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
                                    MediaQuery.of(context).size.width / 25,
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _projectFouceEnglishShortDescribtion,
                                controller: _projectShortDescribtionEnglish,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: false,
                                ispreffixImage: false,
                                preffixImageUrl: "assets/images/Coupon.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.userShortEnglisDescription,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _projectShortDescribtionEnglish.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                      "Description Project in English is requied",
                                    );
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _projectFouceEnglishShortDescribtion
                                            .hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _projectFouceEnglishShortDescribtion
                                        .unfocus(),
                                onFieldSubmitted: (_) =>
                                    _projectFouceEnglishShortDescribtion
                                        .unfocus(),
                              ),
                            ),

                      ///
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
                              "Full description Project in Arbic"),
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
                                    MediaQuery.of(context).size.width / 25,
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 4,
                                focusNode: _projectFouceArbicFullDescribtion,
                                controller: _projectFullDescribtionArbic,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: false,
                                ispreffixImage: false,
                                preffixImageUrl: "assets/images/Coupon.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.userArbicFullDescription,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _projectFullDescribtionArbic.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                      "Full description Project in Arbic is requied",
                                    );
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _projectFouceArbicFullDescribtion
                                            .hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _projectFouceArbicFullDescribtion.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _projectFouceArbicFullDescribtion.unfocus(),
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
                              "Full description Project in English"),
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
                                    MediaQuery.of(context).size.width / 25,
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 4,
                                focusNode: _projectFouceEnglisFullhDescribtion,
                                controller: _projectFullDescribtionEnglish,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: false,
                                ispreffixImage: false,
                                preffixImageUrl: "assets/images/Coupon.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: widget.userEnglisFullDescription,
                                inputData: TextInputType.name,
                                onChangedFunc: (value) {
                                  if (value == " ") {
                                    setState(() {
                                      _projectFullDescribtionEnglish.clear();
                                    });
                                  }
                                },
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                      "Full description Project in English is requied",
                                    );
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _projectFouceEnglisFullhDescribtion
                                            .hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _projectFouceEnglisFullhDescribtion
                                        .unfocus(),
                                onFieldSubmitted: (_) =>
                                    _projectFouceEnglisFullhDescribtion
                                        .unfocus(),
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
              userImage: widget.userimage),
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
                        widget.userimage,
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
          print("add photo");
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

        print('*************************************');
        print(imageSend);
      });
    } on PlatformException catch (e) {
      print("failed to pich image $e");
    }
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
                  onPressedFunction: editProjectMethod,
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

  editProjectMethod() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final storError = Provider.of<ProjectStoreError>(context, listen: false);

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
        "ar[name]": _projectNameArbic.text,
        "en[name]": _projectNameEnglish.text,
        "ar[classification]": _projectClassificationArbic.text,
        "en[classification]": _projectClassificationEnglish.text,
        "ar[short_description]": _projectShortDescribtionArbic.text,
        "en[short_description]": _projectShortDescribtionEnglish.text,
        "ar[full_description]": _projectFullDescribtionArbic.text,
        "en[full_description]": _projectFullDescribtionEnglish.text,
        "image": imageChoosen == 1
            ? await MultipartFile.fromFile(imageSend!.path, filename: fileName)
            : null,
      });
      final response = await Dio().post(
        ("${Urls.ADD_Project_URL}/${widget.userId}"),
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
              context, MaterialPageRoute(builder: (_) => ProjectScreen()));
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: successOperation(
                      operationName: "edit project successfully"),
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
          storError.projectStoreError442(context, response.data);
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
