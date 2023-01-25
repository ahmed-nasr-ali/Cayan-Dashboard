// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously, prefer_if_null_operators, sized_box_for_whitespace, unnecessary_string_interpolations, unused_catch_clause, empty_catches

import 'dart:io';
import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/custom_container/custom_container.dart';
import 'package:cayan/custom_widgets/customtextformfield/custom_text_form_feild.dart';
import 'package:cayan/custom_widgets/open%20image/open_image.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/services%20api%20error/services_api_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/services%20user%20data/services_user_data.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Services/add%20service/category%20bottom%20sheet/category_bottom_sheet.dart';
import 'package:cayan/ui/Services/services%20screen/services_screen.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key}) : super(key: key);

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  File? imageSend;

  int imageChoosen = 0;

  late FocusNode _serviceFouceArbicName;
  late FocusNode _serviceFouceEnglishName;

  late FocusNode _serviceFouceDescribtionArbic;
  late FocusNode _serviceFouceDescribtionEnglish;

  TextEditingController _serviceNameArbic = TextEditingController();
  TextEditingController _serviceNameEnglish = TextEditingController();

  TextEditingController _serviceeDescribtionArbic = TextEditingController();
  TextEditingController _serviceeDescribtionEnglish = TextEditingController();

  bool isValidate = false;

  bool _isLoading = false;
  bool isSelected = false;

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    _serviceFouceArbicName = FocusNode();
    _serviceFouceEnglishName = FocusNode();

    _serviceFouceDescribtionArbic = FocusNode();
    _serviceFouceDescribtionEnglish = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    _serviceFouceArbicName.dispose();
    _serviceFouceEnglishName.dispose();

    _serviceFouceDescribtionArbic.dispose();
    _serviceFouceDescribtionEnglish.dispose();
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
            setState(() {
              _serviceFouceArbicName.unfocus();
              _serviceFouceEnglishName.unfocus();

              _serviceFouceDescribtionArbic.unfocus();
              _serviceFouceDescribtionEnglish.unfocus();
            });
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 1.16, //700
            //  isValidate
            // ? MediaQuery.of(context).size.height / 1.153409090909091
            // : MediaQuery.of(context).size.height /
            //     1.187134502923977, //714 684,
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
                                    .translate("create new service"),
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
                                  "Fill in the following data to create a new service",
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
                          : _addServicesPhoto(themeProvider),
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
                          : _dimenssion(
                              themeProvider, "service name in arabic"),
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
                                focusNode: _serviceFouceArbicName,
                                controller: _serviceNameArbic,
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
                                hintText: "تنظيف الاسنان",
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      isValidate = true;
                                    });
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "servicies name is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _serviceFouceArbicName.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _serviceFouceArbicName.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _serviceFouceArbicName.unfocus(),
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
                              themeProvider, "service name in english"),
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
                                focusNode: _serviceFouceEnglishName,
                                controller: _serviceNameEnglish,
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
                                hintText: "cleaning teeth",
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      isValidate = true;
                                    });
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "servicies name is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _serviceFouceEnglishName.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _serviceFouceEnglishName.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _serviceFouceEnglishName.unfocus(),
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
                          : _dimenssion(themeProvider, "category"),
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
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  _serviceFouceArbicName.unfocus();
                                  _serviceFouceEnglishName.unfocus();

                                  _serviceFouceDescribtionArbic.unfocus();
                                  _serviceFouceDescribtionEnglish.unfocus();
                                });
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: CategroyBottomSheet(),
                                    );
                                  },
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                              child: CustomContainer(
                                color: themeProvider.isDarkMode
                                    ? Color(0xff292828)
                                    : whiteColor,
                                hasHorizontalMargin: true,
                                horizontalMargin:
                                    MediaQuery.of(context).size.height /
                                        50.75, //16
                                verticalMargin: 0,
                                hasVerticalMargin: false,
                                isSelected: isSelected,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height /
                                    16.24, //50
                                borderRadius:
                                    MediaQuery.of(context).size.height /
                                        81.2, //10
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          23.4375, //16
                                    ),
                                    Image.asset(
                                      "assets/images/category.png",
                                      color:
                                          isSelected ? mainAppColor : hintColor,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          37.5, //5
                                    ),
                                    SmallText(
                                      text: ServicesUserData
                                                  .getCategoryName() ==
                                              ""
                                          ? AppLocalizations.of(context)!
                                              .translate("category")
                                          : ServicesUserData.getCategoryName(),
                                      color:
                                          isSelected ? mainAppColor : hintColor,
                                      size: MediaQuery.of(context).size.height /
                                          58,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          themeProvider.isDarkMode
                                              ? Image.asset(
                                                  "assets/images/downdark.png",
                                                  color: hintColor)
                                              : Image.asset(
                                                  "assets/images/down.png",
                                                  color: hintColor,
                                                ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                31.25, //12
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
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
                              "Detailed description of the service in arbic"),
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
                                focusNode: _serviceFouceDescribtionArbic,
                                controller: _serviceeDescribtionArbic,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl: "assets/images/userac.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: "وصف تفصيلي للخدمة",
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      isValidate = true;
                                    });
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "servicies decribtion is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _serviceFouceDescribtionArbic.hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _serviceFouceDescribtionArbic.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _serviceFouceDescribtionArbic.unfocus(),
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
                              "Detailed description of the service in english"),
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
                                focusNode: _serviceFouceDescribtionEnglish,
                                controller: _serviceeDescribtionEnglish,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl: "assets/images/userac.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: "Detailed description of the service",
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      isValidate = true;
                                    });
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "servicies decribtion is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _serviceFouceDescribtionEnglish.hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _serviceFouceDescribtionEnglish.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _serviceFouceDescribtionEnglish.unfocus(),
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            16.91666666666667, //48
                      ),
                      _saveAndCancledButton(themeProvider),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40.6,
                      )
                    ],
                  )
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
              userImage: "https://dev.medical.cayan.co/images/service.png"),
        ),
      );

  _addServicesPhoto(ThemeProvider themeProvider) {
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
                        "https://dev.medical.cayan.co/images/service.png",
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
                  onPressedFunction: addServicesMethod,
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

  addServicesMethod() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final storError = Provider.of<ServicesStoreError>(context, listen: false);

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
        "en[name]": _serviceNameEnglish.text,
        "ar[name]": _serviceNameArbic.text,
        "ar[description]": _serviceeDescribtionArbic.text,
        "en[description]": _serviceNameEnglish.text,
        "category_id": ServicesUserData.getCategoryId(),
        "image": imageChoosen == 1
            ? await MultipartFile.fromFile(imageSend!.path, filename: fileName)
            : null,
      });

      final response = await Dio().post(
        Urls.ADD_SERVICES_URL,
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
          ServicesUserData.setCategoryId(0);
          ServicesUserData.setCategoryName("");
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => ServicesScreen()));
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: successOperation(
                      operationName: "add new services successfully"),
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
          storError.servicesStoreError442(context, response.data);
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
