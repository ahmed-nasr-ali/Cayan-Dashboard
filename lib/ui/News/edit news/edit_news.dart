// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print, unused_local_variable, unused_field, prefer_final_fields, prefer_const_literals_to_create_immutables, prefer_const_constructors, nullable_type_in_catch_clause, no_leading_underscores_for_local_identifiers, prefer_if_null_operators, sized_box_for_whitespace, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:io';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/custom_container/custom_container.dart';
import 'package:cayan/custom_widgets/customtextformfield/custom_text_form_feild.dart';
import 'package:cayan/custom_widgets/open%20image/open_image.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/news%20errors/news_errors.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/News/news%20screen/news_secreen.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditNews extends StatefulWidget {
  int userId;
  String userArbicName;
  String userEnglisName;
  String userArbicDescription;
  String userEnglisDescription;
  String userShortArbicDescription;
  String userShortEnglisDescription;
  String url;
  String userimage;
  String is_active;
  String date;
  EditNews({
    Key? key,
    required this.userId,
    required this.userArbicName,
    required this.userEnglisName,
    required this.userArbicDescription,
    required this.userEnglisDescription,
    required this.userShortArbicDescription,
    required this.userShortEnglisDescription,
    required this.url,
    required this.userimage,
    required this.is_active,
    required this.date,
  }) : super(key: key);

  @override
  State<EditNews> createState() => _EditNewsState();
}

class _EditNewsState extends State<EditNews> {
  DateTime day1 = DateTime.now();

  DateTime day = DateTime(2022, 12, 24);

  bool _isDateCheck = false;

  File? imageSend;

  int imageChoosen = 0;

  late FocusNode _newsFouceArbicName;
  late FocusNode _newsFouceEnglishName;

  late FocusNode _newsFouceArbicDescribtion;
  late FocusNode _newsFouceEnglishDescribtion;

  late FocusNode _newsFouceArbicShortDescribtion;
  late FocusNode _newsFouceEnglishShortDescribtion;

  late FocusNode _newsFouceCartLink;

  TextEditingController _newsNameArbic = TextEditingController();
  TextEditingController _newsNameEnglish = TextEditingController();

  TextEditingController _newsDescribtionArbic = TextEditingController();
  TextEditingController _newsDescribtionEnglish = TextEditingController();

  TextEditingController _newsShortDescribtionArbic = TextEditingController();
  TextEditingController _newsShortDescribtionEnglish = TextEditingController();

  TextEditingController _newsCartLink = TextEditingController();

  bool _isLoading = false;
  bool isSelected = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print(widget.userId);

    print(widget.userArbicName);

    print(widget.userEnglisName);

    print(widget.userArbicDescription);

    print(widget.userEnglisDescription);

    print(widget.userShortArbicDescription);

    print(widget.userShortEnglisDescription);

    print(widget.is_active);

    print(widget.date);

    print(widget.url);

    print(widget.userimage);

    _newsFouceArbicName = FocusNode();
    _newsFouceEnglishName = FocusNode();

    _newsFouceArbicDescribtion = FocusNode();
    _newsFouceEnglishDescribtion = FocusNode();

    _newsFouceArbicShortDescribtion = FocusNode();
    _newsFouceEnglishShortDescribtion = FocusNode();

    _newsFouceCartLink = FocusNode();

    _newsNameArbic.text = "${widget.userArbicName} ";
    _newsNameEnglish.text = "${widget.userEnglisName} ";

    _newsDescribtionArbic.text = "${widget.userArbicDescription} ";
    _newsDescribtionEnglish.text = "${widget.userEnglisDescription} ";

    _newsShortDescribtionArbic.text = "${widget.userShortArbicDescription} ";
    _newsShortDescribtionEnglish.text = "${widget.userShortEnglisDescription} ";

    _newsCartLink.text = "${widget.url} ";
  }

  @override
  void dispose() {
    super.dispose();
    _newsFouceArbicName.dispose();
    _newsFouceEnglishName.dispose();
    _newsFouceArbicDescribtion.dispose();
    _newsFouceEnglishDescribtion.dispose();
    _newsFouceArbicShortDescribtion.dispose();
    _newsFouceEnglishShortDescribtion.dispose();
    _newsFouceCartLink.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return DraggableScrollableSheet(
      initialChildSize: .955,
      //  isValidate ? 0.94 : 0.8608374384236453, //699 584
      maxChildSize: 0.955,
      // isValidate ? 0.94 : 0.8608374384236453,
      minChildSize: 0.5,
      builder: (context, scrollController) => GestureDetector(
        onTap: () {
          _newsFouceArbicName.unfocus();
          _newsFouceEnglishName.unfocus();
          _newsFouceArbicDescribtion.unfocus();
          _newsFouceEnglishDescribtion.unfocus();
          _newsFouceEnglishShortDescribtion.unfocus();
          _newsFouceArbicShortDescribtion.unfocus();
          _newsFouceCartLink.unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(MediaQuery.of(context).size.height / 81.2),
                topRight:
                    Radius.circular(MediaQuery.of(context).size.height / 81.2)),
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
                        height: MediaQuery.of(context).size.height / 162.4, //5
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
                              hight: MediaQuery.of(context).size.height / 32.48,
                              width: MediaQuery.of(context).size.width / 3,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width /
                                    23.4375), //16
                            child: BigText(
                              text: AppLocalizations.of(context)!
                                  .translate("Edit the news"),
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
                                horizontal: MediaQuery.of(context).size.width /
                                    23.4375), //16
                            child: SmallText(
                              text: AppLocalizations.of(context)!.translate(
                                "Edit news and change its data",
                              ),
                              size:
                                  MediaQuery.of(context).size.height / 58, //14
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
                                    hight: MediaQuery.of(context).size.height /
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
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider, "News title in Arbic"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                horizontal: MediaQuery.of(context).size.height /
                                    50.75), //16
                            child: CustomTextField(
                              cursorColor: mainAppColor,
                              readOnly: false,
                              enabled: true,
                              maxLine: 1,
                              focusNode: _newsFouceArbicName,
                              controller: _newsNameArbic,
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
                                    _newsNameArbic.clear();
                                  });
                                }
                              },
                              validationFunc: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .translate(
                                          "News title in Arbic is required");
                                }
                                return null;
                              },
                              onTap: () {
                                setState(() {
                                  _newsFouceArbicName.hasFocus == true;
                                });
                              },
                              onEditingComplete: () =>
                                  _newsFouceArbicName.unfocus(),
                              onFieldSubmitted: (_) =>
                                  _newsFouceArbicName.unfocus(),
                            ),
                          ),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider, "News title in English"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                horizontal: MediaQuery.of(context).size.height /
                                    50.75), //16
                            child: CustomTextField(
                              cursorColor: mainAppColor,
                              readOnly: false,
                              enabled: true,
                              maxLine: 1,
                              focusNode: _newsFouceEnglishName,
                              controller: _newsNameEnglish,
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
                                    _newsNameEnglish.clear();
                                  });
                                }
                              },
                              validationFunc: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .translate(
                                    "News title in English is required",
                                  );
                                }
                                return null;
                              },
                              onTap: () {
                                setState(() {
                                  _newsFouceEnglishName.hasFocus == true;
                                });
                              },
                              onEditingComplete: () =>
                                  _newsFouceEnglishName.unfocus(),
                              onFieldSubmitted: (_) =>
                                  _newsFouceEnglishName.unfocus(),
                            ),
                          ),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider, "Added date"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                            onTap: () async {
                              setState(() {
                                _newsFouceArbicName.unfocus();
                                _newsFouceEnglishName.unfocus();

                                _newsFouceArbicDescribtion.unfocus();
                                _newsFouceEnglishDescribtion.unfocus();
                                _newsFouceArbicShortDescribtion.unfocus();
                                _newsFouceEnglishShortDescribtion.unfocus();
                                _newsFouceCartLink.unfocus();
                              });
                              DateTime? pickDate2 = await showDatePicker(
                                context: context,
                                initialDate: day1,
                                firstDate: DateTime(2010),
                                lastDate: DateTime(2050),
                              );
                              if (pickDate2 == null) return;

                              final newDateTime2 = DateTime(
                                pickDate2.year,
                                pickDate2.month,
                                pickDate2.day,
                              );

                              setState(() {
                                day = newDateTime2;
                                day1 = pickDate2; //for showing
                                _isDateCheck = true;

                                print("date to :  $day");
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
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height /
                                  16.24, //50
                              borderRadius: MediaQuery.of(context).size.height /
                                  81.2, //10
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        25, //15
                                  ),
                                  Image.asset(
                                    "assets/images/calendar.png",
                                    color: Color(0xFFCCCCCC),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        37.5,
                                  ),
                                  SmallText(
                                    text: AppLocalizations.of(context)!
                                            .translate("choose the data") +
                                        (_isDateCheck
                                            ? "  (${DateFormat('yyyy-MM-dd').format(day).toString()})"
                                            : "  (${widget.date})"),
                                    color: hintColor,
                                    size:
                                        MediaQuery.of(context).size.height / 58,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        themeProvider.isDarkMode
                                            ? Image.asset(
                                                "assets/images/calendar.png",
                                                color: mainAppColor,
                                              )
                                            : Image.asset(
                                                "assets/images/calendar.png",
                                                color: mainAppColor,
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
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider, "cart link"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                horizontal: MediaQuery.of(context).size.height /
                                    50.75), //16
                            child: CustomTextField(
                              cursorColor: mainAppColor,
                              readOnly: false,
                              enabled: true,
                              maxLine: 1,
                              focusNode: _newsFouceCartLink,
                              controller: _newsCartLink,
                              textStyleDarkColor: whiteColor,
                              textStyleLightColor: blackColor,
                              isFontBold: true,
                              fillDarkColor: Color(0xff292828),
                              fillLightColor: whiteColor,
                              labelText: '',
                              ispreffix: true,
                              ispreffixImage: true,
                              preffixImageUrl: "assets/images/cart.png",
                              isSuffix: false,
                              isSuffixImage: false,
                              hintText: widget.url,
                              inputData: TextInputType.name,
                              onChangedFunc: (value) {
                                if (value == " ") {
                                  setState(() {
                                    _newsCartLink.clear();
                                  });
                                }
                              },
                              validationFunc: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .translate("cart link is required");
                                }
                                return null;
                              },
                              onTap: () {
                                setState(() {
                                  _newsFouceCartLink.hasFocus == true;
                                });
                              },
                              onEditingComplete: () =>
                                  _newsFouceCartLink.unfocus(),
                              onFieldSubmitted: (_) =>
                                  _newsFouceCartLink.unfocus(),
                            ),
                          ),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider,
                            "Short description of the news in Arbic"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                horizontal: MediaQuery.of(context).size.height /
                                    50.75), //16
                            child: CustomTextField(
                              contentPadding:
                                  MediaQuery.of(context).size.width / 25,
                              cursorColor: mainAppColor,
                              readOnly: false,
                              enabled: true,
                              maxLine: 1,
                              focusNode: _newsFouceArbicShortDescribtion,
                              controller: _newsShortDescribtionArbic,
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
                                    _newsShortDescribtionArbic.clear();
                                  });
                                }
                              },
                              validationFunc: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!.translate(
                                      "Short description of the news in Arbic is required");
                                }
                                return null;
                              },
                              onTap: () {
                                setState(() {
                                  _newsFouceArbicShortDescribtion.hasFocus ==
                                      true;
                                });
                              },
                              onEditingComplete: () =>
                                  _newsFouceArbicShortDescribtion.unfocus(),
                              onFieldSubmitted: (_) =>
                                  _newsFouceArbicShortDescribtion.unfocus(),
                            ),
                          ),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider,
                            "Short description of the news in Englis"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                horizontal: MediaQuery.of(context).size.height /
                                    50.75), //16
                            child: CustomTextField(
                              contentPadding:
                                  MediaQuery.of(context).size.width / 25,
                              cursorColor: mainAppColor,
                              readOnly: false,
                              enabled: true,
                              maxLine: 1,
                              focusNode: _newsFouceEnglishShortDescribtion,
                              controller: _newsShortDescribtionEnglish,
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
                                    _newsShortDescribtionEnglish.clear();
                                  });
                                }
                              },
                              validationFunc: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!.translate(
                                      "Short description of the news in Englis is required");
                                }
                                return null;
                              },
                              onTap: () {
                                setState(() {
                                  _newsFouceEnglishShortDescribtion.hasFocus ==
                                      true;
                                });
                              },
                              onEditingComplete: () =>
                                  _newsFouceEnglishShortDescribtion.unfocus(),
                              onFieldSubmitted: (_) =>
                                  _newsFouceEnglishShortDescribtion.unfocus(),
                            ),
                          ),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider,
                            "Detailed description of the news in Arbic"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                horizontal: MediaQuery.of(context).size.height /
                                    50.75), //16
                            child: CustomTextField(
                              contentPadding:
                                  MediaQuery.of(context).size.width / 25,
                              cursorColor: mainAppColor,
                              readOnly: false,
                              enabled: true,
                              maxLine: 4,
                              focusNode: _newsFouceArbicDescribtion,
                              controller: _newsDescribtionArbic,
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
                              hintText: widget.userArbicDescription,
                              inputData: TextInputType.name,
                              onChangedFunc: (value) {
                                if (value == " ") {
                                  setState(() {
                                    _newsDescribtionArbic.clear();
                                  });
                                }
                              },
                              validationFunc: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!.translate(
                                      "Detailed description of the news in Arbic is required");
                                }
                                return null;
                              },
                              onTap: () {
                                setState(() {
                                  _newsFouceArbicDescribtion.hasFocus == true;
                                });
                              },
                              onEditingComplete: () =>
                                  _newsFouceArbicDescribtion.unfocus(),
                              onFieldSubmitted: (_) =>
                                  _newsFouceArbicDescribtion.unfocus(),
                            ),
                          ),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider,
                            "Detailed description of the news in Englis"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                horizontal: MediaQuery.of(context).size.height /
                                    50.75), //16
                            child: CustomTextField(
                              contentPadding:
                                  MediaQuery.of(context).size.width / 25,
                              cursorColor: mainAppColor,
                              readOnly: false,
                              enabled: true,
                              maxLine: 4,
                              focusNode: _newsFouceEnglishDescribtion,
                              controller: _newsDescribtionEnglish,
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
                              hintText: widget.userEnglisDescription,
                              inputData: TextInputType.name,
                              onChangedFunc: (value) {
                                if (value == " ") {
                                  setState(() {
                                    _newsDescribtionEnglish.clear();
                                  });
                                }
                              },
                              validationFunc: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!.translate(
                                      "Detailed description of the news in Englis is required");
                                }
                                return null;
                              },
                              onTap: () {
                                setState(() {
                                  _newsFouceArbicDescribtion.hasFocus == true;
                                });
                              },
                              onEditingComplete: () =>
                                  _newsFouceArbicDescribtion.unfocus(),
                              onFieldSubmitted: (_) =>
                                  _newsFouceArbicDescribtion.unfocus(),
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
                  btnLbl: "??????",
                  onPressedFunction: editNewsMethod,
                  btnColor: mainAppColor,
                  btnStyle: TextStyle(color: blackColor),
                  horizontalMargin: 0,
                  verticalMargin: 0,
                  lightBorderColor: mainAppColor,
                  darkBorderColor: mainAppColor,
                  addtionalWidgit: false,
                  child: Center(
                    child: SmallText(
                      text: AppLocalizations.of(context)!.translate("save"),
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
                  btnLbl: "??????????",
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

  editNewsMethod() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final storError = Provider.of<NewsStoreError>(context, listen: false);

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
        "ar[name]": _newsNameArbic.text,
        "en[name]": _newsNameEnglish.text,
        "ar[description]": _newsDescribtionArbic.text,
        "en[description]": _newsDescribtionEnglish.text,
        "ar[short_description]": _newsShortDescribtionArbic.text,
        "en[short_description]": _newsShortDescribtionEnglish.text,
        "date":
            _isDateCheck ? DateFormat('yyyy-MM-dd').format(day) : widget.date,
        "link": _newsCartLink.text,
        "is_active": 1,
        "image": imageChoosen == 1
            ? await MultipartFile.fromFile(imageSend!.path, filename: fileName)
            : null,
      });

      final response = await Dio().post(
        ("${Urls.EDIT_NEWS_URL}${widget.userId}"),
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
        print("9999999999999999999999999999999999999999999999999999");
        setState(() {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => NewsScreen()));
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: successOperation(
                      operationName: "edit new News successfully"),
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
        print("6666666666666666666666666666666666");
        print(response.data);
        setState(() {
          storError.newsStoreError442(context, response.data);
          _isLoading = false;
        });
      } else if (response.statusCode == 403) {
        print(response.statusCode);
        setState(() {
          erro403.error403(context, response.statusCode!);
          _isLoading = false;
        });
      } else {
        print(response.statusCode);
        print(response.data);
        setState(() {
          homeServerError.serverError(context, response.statusCode!);
          _isLoading = false;
        });
      }
    }
  }
}
