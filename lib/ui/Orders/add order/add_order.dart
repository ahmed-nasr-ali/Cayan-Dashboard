// ignore_for_file: unused_local_variable, prefer_const_literals_to_create_immutables, prefer_final_fields, prefer_const_constructors, unnecessary_string_interpolations, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/custom_container/custom_container.dart';
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
import 'package:cayan/ui/Orders/add%20order/branche%20bottom%20sheet/branch_bottom_sheet.dart';
import 'package:cayan/ui/Orders/add%20order/category%20bottom%20sheet/category_bottom_sheet.dart';
import 'package:cayan/ui/Orders/add%20order/customer%20bottom%20sheet/customer_bottom_sheet.dart';
import 'package:cayan/ui/Orders/add%20order/order%20status%20bottom%20sheet/order_status_bottom_sheet.dart';
import 'package:cayan/ui/Orders/add%20order/source%20bottom%20sheet/source_bottom_sheet.dart';
import 'package:cayan/ui/edit%20navigation%20bar/edit_navigation_bar.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({Key? key}) : super(key: key);

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return NetworkIndicator(
      child: DraggableScrollableSheet(
        initialChildSize: 0.95, //644
        maxChildSize: 0.95, //644 584
        minChildSize: 0.5,
        builder: (context, scrollController) => GestureDetector(
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
                                  .translate("Create a new order"),
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
                                "Fill in the following information to create a new order",
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
                        : _dimenssion(themeProvider, "category"),
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
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: CategoryBottomSheet(),
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
                              borderRadius: MediaQuery.of(context).size.height /
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
                                    color: hintColor,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        37.5, //5
                                  ),
                                  SmallText(
                                    text: OrderUserData.getCategoryName() == ""
                                        ? AppLocalizations.of(context)!
                                            .translate("category")
                                        : OrderUserData.getCategoryName(),
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
                        : _dimenssion(themeProvider, "Client"),
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
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: CustomerBottomSheet(),
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
                              borderRadius: MediaQuery.of(context).size.height /
                                  81.2, //10
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        23.4375, //16
                                  ),
                                  Image.asset(
                                    "assets/images/user.png",
                                    color: hintColor,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        37.5, //5
                                  ),
                                  SmallText(
                                    text: OrderUserData.getCustomerName() == ""
                                        ? AppLocalizations.of(context)!
                                            .translate("Client")
                                        : OrderUserData.getCustomerName(),
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
                        : _dimenssion(themeProvider, "Branche"),
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
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: BranchesBottomSheet(),
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
                              borderRadius: MediaQuery.of(context).size.height /
                                  81.2, //10
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        23.4375, //16
                                  ),
                                  Image.asset(
                                    "assets/images/locationgrey.png",
                                    color: hintColor,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        37.5, //5
                                  ),
                                  SmallText(
                                    text: OrderUserData.getBrancheName() == ""
                                        ? AppLocalizations.of(context)!
                                            .translate("Branche")
                                        : OrderUserData.getBrancheName(),
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
                        : _dimenssion(themeProvider, "Order status"),
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
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: OrderStatusBottomSheet(),
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
                              borderRadius: MediaQuery.of(context).size.height /
                                  81.2, //10
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        23.4375, //16
                                  ),
                                  Image.asset(
                                    "assets/images/task_square.png",
                                    color: hintColor,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        37.5, //5
                                  ),
                                  SmallText(
                                    text: AppLocalizations.of(context)!
                                        .translate("New"),
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
                        : _dimenssion(themeProvider, "Source"),
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
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: SourcesBottomSheet(),
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
                              borderRadius: MediaQuery.of(context).size.height /
                                  81.2, //10
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        23.4375, //16
                                  ),
                                  Image.asset(
                                    "assets/images/task_square.png",
                                    color: hintColor,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        37.5, //5
                                  ),
                                  SmallText(
                                    text: OrderUserData.getSourceName() == ""
                                        ? AppLocalizations.of(context)!
                                            .translate("Source")
                                        : OrderUserData.getSourceName(),
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
                        ? SizedBox(
                            height: 60,
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height /
                                16.91666666666667, //48
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
                  onPressedFunction: addNewOrder,
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

  addNewOrder() async {
    final navigatonBarScreen =
        Provider.of<NavigationBarScreen>(context, listen: false);

    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final storError = Provider.of<OrderStoreError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);
    bool x = true;
    if (x) {
      final body = {
        "user_id": OrderUserData.getCustomerId(),
        "source_id": OrderUserData.getSourceId(),
        "category_id": OrderUserData.getCategoryId(),
        "status_id": OrderUserData.getOrderStatusId(),
        "branch_id": OrderUserData.getBrancheId(),
      };
      setState(() {
        _isLoading = true;
      });

      final response = await post(
        Uri.parse(Urls.ADD_NEW_ORDER_URL),
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
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => EditNavigationBar()));
          navigatonBarScreen.updateNavigationIndex(2);
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: successOperation(
                    operationName: "add new order successfully",
                  ),
                );
              });

          ///sending to api
          OrderUserData.setCategoryId(0);
          OrderUserData.setCustomerId(0);
          OrderUserData.setBrancheId(0);
          OrderUserData.setSourceId(0);
          OrderUserData.setOrderStatusId(1);

          ///for showing
          OrderUserData.setCategoryName("");
          OrderUserData.setCustomerName("");
          OrderUserData.setBrancheName("");
          OrderUserData.setSourceName("");
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
