// ignore_for_file: unused_local_variable, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations, must_be_immutable, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/custom_container/custom_container.dart';
import 'package:cayan/custom_widgets/customtextformfield/custom_text_form_feild.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/order%20error/order_api_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/navigation_bar_screen.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/order%20user%20data/order_user_data.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Orders/follow%20up%20the%20order/follow%20up%20the%20order%20details%20screen/follow%20bottom%20sheet/choose%20time%20bottom%20sheet/choose_time_bottom_sheet.dart';
import 'package:cayan/ui/Orders/follow%20up%20the%20order/follow%20up%20the%20order%20details%20screen/follow%20bottom%20sheet/fail%20bottom%20sheet/failed_bottom_sheet.dart';
import 'package:cayan/ui/Orders/follow%20up%20the%20order/follow%20up%20the%20order%20details%20screen/follow%20bottom%20sheet/paid%20bottom%20sheet/paid_bottom_sheet.dart';
import 'package:cayan/ui/Orders/follow%20up%20the%20order/follow_up_the_order_screen.dart';
import 'package:cayan/ui/edit%20navigation%20bar/edit_navigation_bar.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'customer case bottom sheet/customer_case_bottom_sheet.dart';

class FollowBottomSheet extends StatefulWidget {
  int neededTime;
  int orderId;
  FollowBottomSheet({
    Key? key,
    required this.neededTime,
    required this.orderId,
  }) : super(key: key);

  @override
  State<FollowBottomSheet> createState() => _FollowBottomSheetState();
}

class _FollowBottomSheetState extends State<FollowBottomSheet> {
  late FocusNode _whatHappenFocus;

  TextEditingController _whatHappen = TextEditingController();

  bool _isLoading = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _whatHappenFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _whatHappenFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NetworkIndicator(
      child: DraggableScrollableSheet(
        initialChildSize: widget.neededTime == 0
            ? 0.6896551724137931 //644
            : 0.5665024630541872, //450
        maxChildSize: widget.neededTime == 0
            ? 0.6896551724137931 //644
            : 0.5665024630541872, //450
        minChildSize: 0.5,
        builder: (context, scrollController) => GestureDetector(
          onTap: () {
            setState(() {
              _whatHappenFocus.unfocus();
            });
          },
          child: Container(
            height:
                MediaQuery.of(context).size.height / 1.241590214067278, //654
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
                                text: widget.neededTime == 0
                                    ? AppLocalizations.of(context)!
                                        .translate("Follow")
                                    : widget.neededTime == 1
                                        ? AppLocalizations.of(context)!
                                            .translate("Paid")
                                        : AppLocalizations.of(context)!
                                            .translate("Fail"),
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
                                text: widget.neededTime == 0
                                    ? AppLocalizations.of(context)!.translate(
                                        "You can now follow up on the customer, mention the customer's status, and set the time",
                                      )
                                    : widget.neededTime == 1
                                        ? AppLocalizations.of(context)!
                                            .translate("Change status to Paid")
                                        : AppLocalizations.of(context)!
                                            .translate(
                                            "Changing the status to failed for any of the following reasons",
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
                              widget.neededTime == 3 ? "Why" : "customer case"),
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
                                widget.neededTime == 0
                                    ? showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child:
                                                CustomerCaseBottomSheet(), //متابعه
                                          );
                                        }).then((value) {
                                        setState(() {});
                                      })
                                    : widget.neededTime == 1
                                        ? showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child:
                                                    PaidBottomSheet(), //تم الدفع
                                              );
                                            }).then((value) {
                                            setState(() {});
                                          })
                                        : widget.neededTime == 3
                                            ? showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (context) {
                                                  return Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    child:
                                                        FailedBottomSheet(), // فشل
                                                  );
                                                }).then((value) {
                                                setState(() {});
                                              })
                                            : Container();
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
                                          18.75, //20
                                    ),
                                    SmallText(
                                      text: OrderUserData
                                                  .getOrderFollowStatus() ==
                                              ""
                                          ? widget.neededTime == 3
                                              ? AppLocalizations.of(context)!
                                                  .translate("Why")
                                              : AppLocalizations.of(context)!
                                                  .translate("customer case")
                                          : OrderUserData
                                              .getOrderFollowStatus(),
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
                          : _dimenssion(themeProvider, "What happen"),
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
                                    MediaQuery.of(context).size.width / 18.75,
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _whatHappenFocus,
                                controller: _whatHappen,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: false,
                                ispreffixImage: false,
                                preffixImageUrl: "assets/images/note.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: AppLocalizations.of(context)!
                                    .translate("What happen"),
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate("what happen is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _whatHappenFocus.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _whatHappenFocus.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _whatHappenFocus.unfocus(),
                              ),
                            ),
                      widget.neededTime == 0
                          ? _isLoading
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width /
                                              18.75),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                54.13333333333333, //15
                                      ),
                                      ShimmerWidget.circular(
                                        hight:
                                            MediaQuery.of(context).size.height /
                                                32.48, //25
                                        width:
                                            MediaQuery.of(context).size.width /
                                                7.5, //50
                                        shapeBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  81.2 //10
                                              ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                81.2,
                                      )
                                    ],
                                  ),
                                )
                              : OrderUserData.getOrderDateAndTime() == ""
                                  ? _dimenssion(
                                      themeProvider, "Choose the time")
                                  : _dimenssion(
                                      themeProvider, "Choosen date and time")
                          : Container(),
                      widget.neededTime == 0
                          ? _isLoading
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width /
                                              18.75),
                                  child: ShimmerWidget.circular(
                                      hight:
                                          MediaQuery.of(context).size.height /
                                              18.04444444444444, //45
                                      width: MediaQuery.of(context).size.width,
                                      shapeBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  81.2))),
                                )
                              : InkWell(
                                  onTap: () {
                                    _whatHappenFocus.unfocus();
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: ChooseTimeBottomSheet(),
                                          );
                                        }).then((value) {
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
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        16.24, //50
                                    borderRadius:
                                        MediaQuery.of(context).size.height /
                                            81.2, //10
                                    child: OrderUserData
                                                .getOrderDateAndTime() ==
                                            ""
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    18.75, //20
                                              ),
                                              SmallText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .translate(
                                                        "Choose the time"),
                                                color: hintColor,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              31.25, //12
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SmallText(
                                                text: OrderUserData
                                                        .getOrderDateAndTime()
                                                    .toString(),
                                                color: hintColor,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    58,
                                              ),
                                            ],
                                          ),
                                  ),
                                )
                          : Container(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 20.6 //20
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
                  onPressedFunction: widget.neededTime == 0
                      ? OrderUserData.getOrderDateAndTime() == ""
                          ? dataError
                          : addNewFollowOrder
                      : addNewFollowOrder,
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

  dataError() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: mainAppColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: BigText(
              size: MediaQuery.of(context).size.height / 73.81818181818182, //11
              color: blackColor,
              text: AppLocalizations.of(context)!
                  .translate("You must choose Date and Time"),
              typeOfFontWieght: 1,
            ),
          );
        });
  }

  addNewFollowOrder() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final storError = Provider.of<OrderStoreError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    final navigatonBarScreen =
        Provider.of<NavigationBarScreen>(context, listen: false);

    if (formKey.currentState!.validate()) {
      final body = {
        "order_id": widget.orderId,
        "sub_status_id": OrderUserData.getOrderSubStatusId(),
        "description": _whatHappen.text,
        "duration":
            widget.neededTime == 0 ? OrderUserData.getOrderDateAndTime() : null,
      };
      setState(() {
        _isLoading = true;
      });

      final response = await post(
        Uri.parse(Urls.ADD_NEW_FOLLOW_ORDER_URL),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "Accept-Language": "en",
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        setState(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => EditNavigationBar()),
              (route) => false);
          navigatonBarScreen.updateNavigationIndex(2);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FollowUpTheOrderScreen(orderId: widget.orderId)));

          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: successOperation(
                    operationName: "A new user status has been created",
                  ),
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
        var _body = jsonDecode(response.body);
        setState(() {
          storError.orderStoreError442(context, _body);
          _isLoading = false;
        });
      } else if (response.statusCode == 403) {
        setState(() {
          erro403.error403(context, response.statusCode);
          _isLoading = false;
        });
      } else {
        setState(() {
          homeServerError.serverError(context, response.statusCode);
          _isLoading = false;
        });
      }
    }
  }
}
