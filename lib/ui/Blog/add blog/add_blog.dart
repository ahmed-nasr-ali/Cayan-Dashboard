// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, unnecessary_string_interpolations, avoid_print, nullable_type_in_catch_clause, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace, prefer_if_null_operators, unused_local_variable, use_build_context_synchronously

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
import 'package:cayan/network/api_errors/blog%20errors/blog_errors.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Blog/blog%20screen/blog_screen.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({Key? key}) : super(key: key);

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  DateTime day1 = DateTime.now();

  DateTime day = DateTime(2022, 12, 24, 0, 0);

  bool _isdataCheck = false;

  File? imageSend;

  int imageChoosen = 0;

  late FocusNode _blogFouceArbicName;
  late FocusNode _blogFouceEnglishName;

  late FocusNode _blogFouceArbicDescribtion;
  late FocusNode _blogFouceEnglishDescribtion;

  late FocusNode _blogFouceArbicShortDescribtion;
  late FocusNode _blogFouceEnglishShortDescribtion;

  late FocusNode _blogFouceCartLink;

  TextEditingController _blogNameArbic = TextEditingController();
  TextEditingController _blogNameEnglish = TextEditingController();

  TextEditingController _blogDescribtionArbic = TextEditingController();
  TextEditingController _blogDescribtionEnglish = TextEditingController();

  TextEditingController blogShortDescribtionArbic = TextEditingController();
  TextEditingController blogShortDescribtionEnglish = TextEditingController();

  TextEditingController _blogCartLink = TextEditingController();

  bool _isLoading = false;
  bool isSelected = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _blogFouceArbicName = FocusNode();
    _blogFouceEnglishName = FocusNode();

    _blogFouceArbicDescribtion = FocusNode();
    _blogFouceEnglishDescribtion = FocusNode();
    _blogFouceArbicShortDescribtion = FocusNode();
    _blogFouceEnglishShortDescribtion = FocusNode();
    _blogFouceCartLink = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _blogFouceArbicName.dispose();
    _blogFouceEnglishName.dispose();
    _blogFouceArbicDescribtion.dispose();
    _blogFouceEnglishDescribtion.dispose();
    _blogFouceArbicShortDescribtion.dispose();
    _blogFouceEnglishShortDescribtion.dispose();
    _blogFouceCartLink.dispose();
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
            _blogFouceArbicName.unfocus();
            _blogFouceEnglishName.unfocus();
            _blogFouceArbicDescribtion.unfocus();
            _blogFouceEnglishDescribtion.unfocus();
            _blogFouceEnglishShortDescribtion.unfocus();
            _blogFouceArbicShortDescribtion.unfocus();
            _blogFouceCartLink.unfocus();
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
                                    .translate("Create a new article"),
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
                                  "Fill in the following information to create a new article",
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
                          : _dimenssion(themeProvider,
                              "The title of the article in Arabic"),
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
                                focusNode: _blogFouceArbicName,
                                controller: _blogNameArbic,
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
                                hintText: "عنوان المقالة بالغة العربيه",
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate(
                                        "The title of the article in Arabic is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _blogFouceArbicName.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _blogFouceArbicName.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _blogFouceArbicName.unfocus(),
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
                              "The title of the article in English"),
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
                                focusNode: _blogFouceEnglishName,
                                controller: _blogNameEnglish,
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
                                hintText: "Title of the news in English",
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate(
                                      "The title of the article in English is required",
                                    );
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _blogFouceEnglishName.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _blogFouceEnglishName.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _blogFouceEnglishName.unfocus(),
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
                          : _dimenssion(themeProvider, "Added date"),
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
                              onTap: () async {
                                setState(() {
                                  _blogFouceArbicName.unfocus();
                                  _blogFouceEnglishName.unfocus();

                                  _blogFouceArbicDescribtion.unfocus();
                                  _blogFouceEnglishDescribtion.unfocus();
                                  _blogFouceArbicShortDescribtion.unfocus();
                                  _blogFouceEnglishShortDescribtion.unfocus();
                                  _blogFouceCartLink.unfocus();
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
                                  day.hour,
                                  day.minute,
                                  day.second,
                                );

                                setState(() {
                                  day1 = newDateTime2;
                                  day = pickDate2; //for showing
                                  _isdataCheck = true;
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
                                borderRadius:
                                    MediaQuery.of(context).size.height /
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
                                      text: _isdataCheck
                                          ? "${day.toString().split(" ")[0]}"
                                          : AppLocalizations.of(context)!
                                              .translate("choose the data"),
                                      color: hintColor,
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
                          : _dimenssion(themeProvider, "cart link"),
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
                                focusNode: _blogFouceCartLink,
                                controller: _blogCartLink,
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
                                hintText: AppLocalizations.of(context)!
                                    .translate("cart link"),
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate("cart link is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _blogFouceCartLink.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _blogFouceCartLink.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _blogFouceCartLink.unfocus(),
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
                              "Short description of the article in Arbic"),
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
                                focusNode: _blogFouceArbicShortDescribtion,
                                controller: blogShortDescribtionArbic,
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
                                hintText: "وصف مختصر للمقال بالغة العربية",
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate(
                                        "Short description of the article in Arbic is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _blogFouceArbicShortDescribtion.hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _blogFouceArbicShortDescribtion.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _blogFouceArbicShortDescribtion.unfocus(),
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
                              "Short description of the article in English"),
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
                                focusNode: _blogFouceEnglishShortDescribtion,
                                controller: blogShortDescribtionEnglish,
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
                                hintText:
                                    "Short description of the article in Englis ",
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate(
                                        "Short description of the article in English is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _blogFouceEnglishShortDescribtion
                                            .hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _blogFouceEnglishShortDescribtion.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _blogFouceEnglishShortDescribtion.unfocus(),
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
                              "Detailed description of the article in Arbic"),
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
                                focusNode: _blogFouceArbicDescribtion,
                                controller: _blogDescribtionArbic,
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
                                hintText: "وصف تفصيلي للمقال بالغة العربية",
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate(
                                        "Detailed description of the article in Arbic is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _blogFouceArbicDescribtion.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _blogFouceArbicDescribtion.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _blogFouceArbicDescribtion.unfocus(),
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
                              "Detailed description of the article in English"),
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
                                focusNode: _blogFouceEnglishDescribtion,
                                controller: _blogDescribtionEnglish,
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
                                hintText:
                                    "Detailed description of the article in Englis ",
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!.translate(
                                        "Detailed description of the article in English is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _blogFouceEnglishDescribtion.hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _blogFouceEnglishDescribtion.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _blogFouceEnglishDescribtion.unfocus(),
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
              userImage: "https://dev.medical.cayan.co/images/service.png"),
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
                  onPressedFunction: addBlogMethod,
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

  addBlogMethod() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final storError = Provider.of<BlogStoreError>(context, listen: false);

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

      var x = DateFormat('yyyy-MM-dd').format(day);

      FormData formData = FormData.fromMap(
        {
          "ar[title]": _blogNameArbic.text,
          "en[title]": _blogNameEnglish.text,
          "ar[short_description]": blogShortDescribtionArbic.text,
          "en[short_description]": blogShortDescribtionEnglish.text,
          "ar[long_description]": _blogDescribtionArbic.text,
          "en[long_description]": _blogDescribtionEnglish.text,
          "date": x,
          "reference_link": _blogCartLink.text,
          "image": imageChoosen == 1
              ? await MultipartFile.fromFile(imageSend!.path,
                  filename: fileName)
              : null,
        },
      );

      final response = await Dio().post(
        Urls.ADD_BLOG_URL_,
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
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => BlogScreen()));
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: successOperation(
                      operationName: "add new article successfully"),
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
          storError.blogsStoreError442(context, response.data);
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

        setState(() {
          homeServerError.serverError(context, response.statusCode!);
          _isLoading = false;
        });
      }
    }
  }
}
