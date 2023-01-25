// ignore_for_file: must_be_immutable, unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerDataScreen extends StatefulWidget {
  Map orderInformation;
  CustomerDataScreen({
    Key? key,
    required this.orderInformation,
  }) : super(key: key);

  @override
  State<CustomerDataScreen> createState() => _CustomerDataScreenState();
}

class _CustomerDataScreenState extends State<CustomerDataScreen> {
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
          child: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return customerDataBody(index, themeProvider);
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customerDataBody(int index, ThemeProvider themeProvider) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 1.116918844566713, //727
          width: MediaQuery.of(context).size.width,
          color: themeProvider.isDarkMode ? blackColor : cardColor,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 32.48,
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height /
                        1.540796963946869, //527
                    color: Colors.transparent,
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 23.2,
                    child: Container(
                      width: MediaQuery.of(context).size.width -
                          (MediaQuery.of(context).size.width / 12.5), //30
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? containerdarkColor
                            : whiteColor,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height / 81.2, //10
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height / 11.6, //70
                          ),
                          SmallText(
                            text: widget.orderInformation["user_name"] ?? " ",
                            size: MediaQuery.of(context).size.height / 50.75,
                            color: themeProvider.isDarkMode
                                ? whiteColor
                                : blackColor,
                            typeOfFontWieght: 1,
                          ),
                          SmallText(
                            text: widget.orderInformation["category"] ?? " ",
                            size: MediaQuery.of(context).size.height /
                                67.66666666666667, //12
                            color: themeProvider.isDarkMode
                                ? mainAppColor
                                : textGrayColor,
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height / 162.4, //5
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 5, //75
                            height:
                                MediaQuery.of(context).size.height / 32.48, //25
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height / 40.6),
                              color: widget.orderInformation["status"]["id"] ==
                                      1
                                  ? blueColor
                                  : widget.orderInformation["status"]["id"] == 2
                                      ? orangeColor
                                      : widget.orderInformation["status"]
                                                  ["id"] ==
                                              3
                                          ? greenColor
                                          : redColor,
                            ),
                            child: Center(
                              child: SmallText(
                                text: widget.orderInformation["status"]
                                        ["name"] ??
                                    " ",
                                color: whiteColor,
                                typeOfFontWieght: 0,
                                size: MediaQuery.of(context).size.height /
                                    67.66666666666667, //12
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height /
                                27.06666666666667, //30
                          ),
                          Divider(
                            height: 0,
                            color: themeProvider.isDarkMode
                                ? dividerDarkColor
                                : containerColor,
                            indent:
                                MediaQuery.of(context).size.width / 18.75, //20
                            endIndent:
                                MediaQuery.of(context).size.width / 18.75, //20
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 40.6,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width /
                                  18.75, //20
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset("assets/images/mobile.png"),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          75, //5
                                    ),
                                    SmallText(
                                        size:
                                            MediaQuery.of(context).size.height /
                                                67.66666666666667, //12,

                                        color: themeProvider.isDarkMode
                                            ? whiteColor
                                            : textGrayColor,
                                        text: AppLocalizations.of(context)!
                                            .translate("phone_No"))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.75,
                                      // color: mainAppColor,
                                      child: SmallText(
                                        align: TextAlign.end,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                67.66666666666667, //12,

                                        color: themeProvider.isDarkMode
                                            ? whiteColor
                                            : textGrayColor,
                                        text: widget.orderInformation[
                                                "user_phone"] ??
                                            "",
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          75,
                                    ),
                                    Image.asset("assets/images/whatsapp.png"),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height / 40.6, //20
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width /
                                  18.75, //20
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/userfill.png",
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          75, //5
                                    ),
                                    SmallText(
                                      size: MediaQuery.of(context).size.height /
                                          67.66666666666667, //12,

                                      color: themeProvider.isDarkMode
                                          ? whiteColor
                                          : textGrayColor,
                                      text: AppLocalizations.of(context)!
                                          .translate("employee in charge"),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          3.75,
                                      // color: mainAppColor,
                                      child: SmallText(
                                        align: TextAlign.end,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                67.66666666666667, //12,

                                        color: themeProvider.isDarkMode
                                            ? whiteColor
                                            : textGrayColor,
                                        text: widget.orderInformation[
                                                "last_employee"] ??
                                            "",
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          75,
                                    ),
                                    CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.height /
                                              67.66666666666667, //12
                                      backgroundImage: widget.orderInformation[
                                                  "employee_avatar"] !=
                                              null
                                          ? NetworkImage(
                                              widget.orderInformation[
                                                  "employee_avatar"],
                                            )
                                          : null,
                                      backgroundColor: themeProvider.isDarkMode
                                          ? containerdarkColor
                                          : whiteColor,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height / 40.6, //20
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width /
                                  18.75, //20
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/resources.png",
                                      color: mainAppColor,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          75, //5
                                    ),
                                    SmallText(
                                      size: MediaQuery.of(context).size.height /
                                          67.66666666666667, //12,

                                      color: themeProvider.isDarkMode
                                          ? whiteColor
                                          : textGrayColor,
                                      text: AppLocalizations.of(context)!
                                          .translate("Source"),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      // color: mainAppColor,
                                      child: SmallText(
                                        align: TextAlign.end,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                67.66666666666667, //12,

                                        color: themeProvider.isDarkMode
                                            ? whiteColor
                                            : textGrayColor,
                                        text:
                                            widget.orderInformation["source"] ??
                                                "",
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 23,
                          )
                        ],
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.height / 20.3, //60
                    backgroundImage: widget.orderInformation["user_avatar"] !=
                            null
                        ? NetworkImage(widget.orderInformation["user_avatar"])
                        : AssetImage("assets/images/userphotoright.png")
                            as ImageProvider,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
