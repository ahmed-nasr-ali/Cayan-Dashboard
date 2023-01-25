// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, use_build_context_synchronously, unused_element, unused_field, prefer_final_fields, unused_local_variable, prefer_const_constructors_in_immutables, must_be_immutable, body_might_complete_normally_nullable, prefer_const_declarations, sized_box_for_whitespace

import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/order%20user%20data/order_user_data.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'follow bottom sheet/follow_bottom_sheet.dart';

class FollowUpTheOrderDetailsScreen extends StatefulWidget {
  Map orderInformation;
  List orderHistory;
  int orderId;

  FollowUpTheOrderDetailsScreen({
    Key? key,
    required this.orderInformation,
    required this.orderHistory,
    required this.orderId,
  }) : super(key: key);

  @override
  State<FollowUpTheOrderDetailsScreen> createState() =>
      _FollowUpTheOrderDetailsScreenState();
}

class _FollowUpTheOrderDetailsScreenState
    extends State<FollowUpTheOrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NetworkIndicator(
      child: Builder(
        builder: (context) => NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              // print("come her");

              ///load next page here
              // _loadMore();
              //romove part of controller from loadmore
            }
            return true;
          },
          child: Column(
            // physics: NeverScrollableScrollPhysics(),
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context)),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height /
                                    54.13333333333333, //15
                                color: themeProvider.isDarkMode
                                    ? blackColor
                                    : cardColor,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 40.6,
                              )
                            ],
                          );
                        },
                        childCount: 1,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return widget.orderHistory.isNotEmpty
                              ? followUpOrderBody(index, themeProvider)
                              : noHistoryBody(index, themeProvider);
                        },
                        childCount: widget.orderHistory.isNotEmpty
                            ? widget.orderHistory.length
                            : 1,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width /
                                  23.4375, //16
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.orderHistory.isEmpty
                                    ? Container()
                                    : Image.asset(
                                        "assets/images/check.png",
                                        fit: BoxFit.cover,
                                      ),
                                widget.orderHistory.isEmpty
                                    ? Container()
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                81.2, //60
                                      ),
                              ],
                            ),
                          );
                        },
                        childCount: 1,
                      ),
                    ),
                  ],
                ),
              ),
              buildActionButton(themeProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget followUpOrderBody(int index, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 23.4375, //16
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/images/circle.png",
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 50, //7.5
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2.5,
                child: SmallText(
                  align: TextAlign.start,
                  size: MediaQuery.of(context).size.height /
                      67.66666666666667, //12
                  color: themeProvider.isDarkMode ? whiteColor : textGrayColor,
                  text: widget.orderHistory[index]["last_update"] ?? "",
                ),
              )
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                  width: (MediaQuery.of(context).size.width / 23.4375) +
                      (MediaQuery.of(context).size.width / 15.625) / 2 +
                      MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.width),
              VerticalDivider(
                width: 0,
                thickness: 1,
                color: themeProvider.isDarkMode
                    ? Colors.grey.shade800
                    : containerColor,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 18.75,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height /
                      54.13333333333333, //15
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width /
                      1.221498371335505, //297
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height / 81.2 //10
                        ),
                    color:
                        themeProvider.isDarkMode ? dividerDarkColor : cardColor,
                  ),
                  child: bulidfollowUpOrderDetails(index, themeProvider),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget noHistoryBody(int index, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 23.4375, //16
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/images/circle.png",
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 50, //7.5
              ),
              SmallText(
                size:
                    MediaQuery.of(context).size.height / 67.66666666666667, //12
                color: themeProvider.isDarkMode ? whiteColor : textGrayColor,
                text: widget.orderInformation["created_at"] ?? "",
              )
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width / 23.4375) +
                    (MediaQuery.of(context).size.width / 15.625) / 2,
              ),
              VerticalDivider(
                width: 0,
                thickness: 1,
                color: themeProvider.isDarkMode
                    ? Colors.grey.shade800
                    : containerColor,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 18.75,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height /
                      54.13333333333333, //15
                ),
                child: Container(
                    width: MediaQuery.of(context).size.width /
                        1.221498371335505, //297
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height / 81.2 //10
                          ),
                      color: themeProvider.isDarkMode
                          ? dividerDarkColor
                          : cardColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 25, //15
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height / 40.6, //20
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.height /
                                    32.48, //15
                                backgroundImage: widget
                                            .orderInformation["user_avatar"] !=
                                        null
                                    ? NetworkImage(
                                        widget.orderInformation["user_avatar"])
                                    : AssetImage(
                                            "assets/images/userphotoright.png")
                                        as ImageProvider,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    31.25, //12
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.875, //170
                                          // color: mainAppColor,
                                          child: SmallText(
                                            align: TextAlign.start,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                58, //14
                                            text: widget.orderInformation[
                                                    "user_name"] ??
                                                " ",
                                            color: themeProvider.isDarkMode
                                                ? whiteColor
                                                : blackColor,
                                            typeOfFontWieght: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              81.2,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          5, //75
                                      height:
                                          MediaQuery.of(context).size.height /
                                              32.48, //25
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.height /
                                                40.6),
                                        color: widget.orderInformation["status"]
                                                    ["id"] ==
                                                1
                                            ? blueColor
                                            : widget.orderInformation["status"]
                                                        ["id"] ==
                                                    2
                                                ? orangeColor
                                                : widget.orderInformation[
                                                            "status"]["id"] ==
                                                        3
                                                    ? greenColor
                                                    : redColor,
                                      ),
                                      child: Center(
                                        child: SmallText(
                                          text:
                                              widget.orderInformation["status"]
                                                      ["name"] ??
                                                  AppLocalizations.of(context)!
                                                      .translate("New"),
                                          color: whiteColor,
                                          typeOfFontWieght: 0,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              67.66666666666667, //12
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height /
                                46.4, //17.5
                          ),
                          Divider(
                            height: 0,
                            color: themeProvider.isDarkMode
                                ? Colors.grey.shade700
                                : containerColor,
                            endIndent:
                                MediaQuery.of(context).size.width / 75, //5
                            indent: MediaQuery.of(context).size.width / 75, //5
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height /
                                54.13333333333333, //15
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 75, //5
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: SmallText(
                                align: TextAlign.start,
                                text: AppLocalizations.of(context)!
                                    .translate("No Contact with client"),
                                size: MediaQuery.of(context).size.height /
                                    62.46153846153846, //13
                                color: themeProvider.isDarkMode
                                    ? whiteColor
                                    : blackColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height /
                                54.13333333333333, //15
                          ),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 23.4375, //16
          ),
          child: Image.asset(
            "assets/images/check.png",
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget bulidfollowUpOrderDetails(int index, ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 25, //15
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 40.6, //20
          ),
          Row(
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.height / 32.48, //15
                backgroundImage: widget.orderInformation["user_avatar"] != null
                    ? NetworkImage(widget.orderInformation["user_avatar"])
                    : AssetImage("assets/images/userphotoright.png")
                        as ImageProvider,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 31.25, //12
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // color: mainAppColor,
                          width: MediaQuery.of(context).size.width /
                              2.777777777777778, //135
                          child: SmallText(
                            align: TextAlign.start,
                            size: MediaQuery.of(context).size.height / 58, //14
                            text: widget.orderInformation["user_name"] ?? " ",
                            color: themeProvider.isDarkMode
                                ? whiteColor
                                : blackColor,
                            typeOfFontWieght: 1,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 5, //75
                          child: SmallText(
                            text: widget.orderHistory[index]["sub_status"]
                                    ["name"] ??
                                "",
                            size: MediaQuery.of(context).size.height /
                                67.666666666667, //12
                            color: widget.orderHistory[index]["status"]["id"] ==
                                    1
                                ? blueColor
                                : widget.orderHistory[index]["status"]["id"] ==
                                        2
                                    ? orangeColor
                                    : widget.orderHistory[index]["status"]
                                                ["id"] ==
                                            3
                                        ? greenColor
                                        : redColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 81.2,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 5, //75
                      height: MediaQuery.of(context).size.height / 32.48, //25
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height / 40.6),
                        color: widget.orderHistory[index]["status"]["id"] == 1
                            ? blueColor
                            : widget.orderHistory[index]["status"]["id"] == 2
                                ? orangeColor
                                : widget.orderHistory[index]["status"]["id"] ==
                                        3
                                    ? greenColor
                                    : redColor,
                      ),
                      child: Center(
                        child: SmallText(
                          text: widget.orderHistory[index]["status"]["name"] ??
                              " ",
                          color: whiteColor,
                          typeOfFontWieght: 0,
                          size: MediaQuery.of(context).size.height /
                              67.66666666666667, //12
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 46.4, //17.5
          ),
          Divider(
            height: 0,
            color: themeProvider.isDarkMode
                ? Colors.grey.shade700
                : containerColor,
            endIndent: MediaQuery.of(context).size.width / 75, //5
            indent: MediaQuery.of(context).size.width / 75, //5
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 54.13333333333333, //15
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 75, //5
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: SmallText(
                align: TextAlign.start,
                text: widget.orderHistory[index]["description"] ?? "",
                size:
                    MediaQuery.of(context).size.height / 62.46153846153846, //13
                color: themeProvider.isDarkMode ? whiteColor : blackColor,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 54.13333333333333, //15
          ),
          widget.orderHistory[index]["status"]["id"] == 2
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 0,
                      color: themeProvider.isDarkMode
                          ? Colors.grey.shade700
                          : containerColor,
                      endIndent: MediaQuery.of(context).size.width / 75, //5
                      indent: MediaQuery.of(context).size.width / 75, //5
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height /
                          67.66666666666667, //12
                    ),
                    SmallText(
                      text: AppLocalizations.of(context)!
                          .translate("Follow up date"),
                      size: MediaQuery.of(context).size.height /
                          67.66666666666667, //12,
                      color: textGrayColor,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 101.5, //8
                    ),
                    Row(
                      children: [
                        Image.asset("assets/images/clock.png"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 75, //5
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: SmallText(
                            align: TextAlign.start,
                            text:
                                widget.orderHistory[index]["created_at"] ?? "",
                            color: themeProvider.isDarkMode
                                ? whiteColor
                                : blackColor,
                            size: MediaQuery.of(context).size.height /
                                67.66666666666667, //12,,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height /
                          62.46153846153846, //13
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget buildActionButton(ThemeProvider themeProvider) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 23.4375),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                height: MediaQuery.of(context).size.height / 20.6, //40
                width:
                    MediaQuery.of(context).size.width / 3.504672897196262, //117
                btnLbl: "حفظ",
                onPressedFunction: () {
                  setState(() {
                    OrderUserData.setOrderSubStatusId(0);
                    OrderUserData.setOrderFollowStatus("");
                    OrderUserData.setOrderDateAndTime("");
                  });
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: FollowBottomSheet(
                            neededTime: 0,
                            orderId: widget.orderId,
                          ),
                        );
                      }).then((value) {
                    setState(() {});
                  });
                },
                btnColor: orangeColor,
                btnStyle: TextStyle(color: blackColor),
                horizontalMargin: 0,
                verticalMargin: 0,
                lightBorderColor: orangeColor,
                darkBorderColor: orangeColor,
                addtionalWidgit: false,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 18.75, //20
                    ),
                    Image.asset("assets/images/timer.png"),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 93.75,
                    ),
                    SmallText(
                      text: AppLocalizations.of(context)!.translate("Follow"),
                      color: themeProvider.isDarkMode ? whiteColor : whiteColor,
                      typeOfFontWieght: 1,
                    ),
                  ],
                ),
              ),
              CustomButton(
                height: MediaQuery.of(context).size.height / 20.6, //40
                width:
                    MediaQuery.of(context).size.width / 3.504672897196262, //117
                btnLbl: "حفظ",
                onPressedFunction: () {
                  setState(() {
                    OrderUserData.setOrderSubStatusId(0);
                    OrderUserData.setOrderFollowStatus("");
                    OrderUserData.setOrderDateAndTime("");
                  });
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: FollowBottomSheet(
                            neededTime: 1,
                            orderId: widget.orderId,
                          ),
                        );
                      }).then((value) {
                    setState(() {});
                  });
                },
                btnColor: greenColor,
                btnStyle: TextStyle(color: blackColor),
                horizontalMargin: 0,
                verticalMargin: 0,
                lightBorderColor: greenColor,
                darkBorderColor: greenColor,
                addtionalWidgit: false,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 18.75, //20
                    ),
                    Image.asset("assets/images/card_tick.png"),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 93.75,
                    ),
                    SmallText(
                      text: AppLocalizations.of(context)!.translate("Paid"),
                      color: themeProvider.isDarkMode ? whiteColor : whiteColor,
                      typeOfFontWieght: 1,
                    ),
                  ],
                ),
              ),
              CustomButton(
                height: MediaQuery.of(context).size.height / 20.6, //40
                width:
                    MediaQuery.of(context).size.width / 3.504672897196262, //117

                btnLbl: "حفظ",
                onPressedFunction: () {
                  setState(() {
                    OrderUserData.setOrderSubStatusId(0);
                    OrderUserData.setOrderFollowStatus("");
                    OrderUserData.setOrderDateAndTime("");
                  });
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: FollowBottomSheet(
                            neededTime: 3,
                            orderId: widget.orderId,
                          ),
                        );
                      }).then((value) {
                    setState(() {});
                  });
                },
                btnColor: redColor,
                btnStyle: TextStyle(color: blackColor),
                horizontalMargin: 0,
                verticalMargin: 0,
                lightBorderColor: redColor,
                darkBorderColor: redColor,
                addtionalWidgit: false,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 18.75, //20
                    ),
                    Image.asset("assets/images/close_circle.png"),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 93.75,
                    ),
                    SmallText(
                      text: AppLocalizations.of(context)!.translate("Fail"),
                      color: themeProvider.isDarkMode ? whiteColor : whiteColor,
                      typeOfFontWieght: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 81.2,
        )
      ],
    );
  }
}
