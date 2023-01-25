// ignore_for_file: unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations, prefer_final_fields, unused_field, avoid_print, must_be_immutable

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/custom_container/custom_container.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/navigation_bar_screen.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/control%20panel/control_panel.dart';
import 'package:cayan/shared_preferences/follow%20source%20data/follow_source_data.dart';
import 'package:cayan/shared_preferences/follow_prefrmance/follow_prefromance_data.dart';
import 'package:cayan/shared_preferences/order%20user%20data/order_user_data.dart';
import 'package:cayan/ui/Follwing%20performance/follwing%20performance%20screen/follwing_performance_screen.dart';
import 'package:cayan/ui/edit%20navigation%20bar/edit_navigation_bar.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class OrderDateFilterationBottomSheet extends StatefulWidget {
  String pageName;
  OrderDateFilterationBottomSheet({
    Key? key,
    required this.pageName,
  }) : super(key: key);

  @override
  State<OrderDateFilterationBottomSheet> createState() =>
      _OrderDateFilterationBottomSheetState();
}

class _OrderDateFilterationBottomSheetState
    extends State<OrderDateFilterationBottomSheet> {
  bool _isDataFromSelect = false;
  bool _isDataToSelect = false;
  bool _checkDate = false;

  bool _isday = false;

  DateTime data1 = DateTime.now(); //for show only in calendar
  DateTime data2 = DateTime.now(); //for show only in calendar

  DateTime day1 = DateTime.now(); //for show only in calendar

  DateTime dateFrom = DateTime(2022, 12, 24, 0, 0);
  DateTime dateTo = DateTime(2022, 12, 24, 0, 0);

  DateTime day = DateTime(2022, 12, 24, 0, 0);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final navigatonBarScreen =
        Provider.of<NavigationBarScreen>(context, listen: false);

    return DraggableScrollableSheet(
      initialChildSize: 0.7019704433497537, //644
      maxChildSize: 0.7019704433497537, //644 584
      minChildSize: 0.5,
      builder: (context, scrollController) => GestureDetector(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.241590214067278, //654
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(MediaQuery.of(context).size.height / 81.2),
                topRight:
                    Radius.circular(MediaQuery.of(context).size.height / 81.2)),
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width / 23.4375), //16
                    child: BigText(
                      text: AppLocalizations.of(context)!
                          .translate("Date and Time"),
                      typeOfFontWieght: 1,
                      size: MediaQuery.of(context).size.height / 50.75, //16
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height /
                        135.3333333333333, //6
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width / 23.4375), //16
                    child: SmallText(
                      text: AppLocalizations.of(context)!.translate(
                        "You can now specify the time to follow up on your orders",
                      ),
                      size: MediaQuery.of(context).size.height / 58, //14
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
                    height: MediaQuery.of(context).size.height / 50.75, //20
                  ),
                  _dimenssion(themeProvider, "History from"),
                  InkWell(
                    onTap: () async {
                      DateTime? pickDate1 = await showDatePicker(
                        context: context,
                        initialDate: data1,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2050),
                      );
                      if (pickDate1 == null) return;

                      final newDateTime = DateTime(
                        pickDate1.year,
                        pickDate1.month,
                        pickDate1.day,
                        dateFrom.hour,
                        dateFrom.minute,
                        dateFrom.second,
                      );

                      setState(() {
                        dateFrom = newDateTime;
                        data1 = pickDate1; //for showing
                        _isDataFromSelect = true;
                        _checkDate = true;
                        print("date from  $dateFrom");
                        widget.pageName == "orders"
                            ? OrderUserData.setOrderHistoryFromShowing(
                                data1.toString().split(" ")[0])
                            : widget.pageName == "follow_source"
                                ? FollowSourceUserData
                                    .setFollowSourcesHistoryFromShowing(
                                        data1.toString().split(" ")[0])
                                : widget.pageName == "control_panel"
                                    ? ControlPanleUserData
                                        .setControlPanelHistoryFromShowing(
                                            data1.toString().split(" ")[0])
                                    : FollowPrefUserData
                                        .setFollowprefHistoryFromShowing(
                                            data1.toString().split(" ")[0]);
                      });
                    },
                    child: CustomContainer(
                      color: themeProvider.isDarkMode
                          ? Color(0xff292828)
                          : whiteColor,
                      hasHorizontalMargin: true,
                      horizontalMargin:
                          MediaQuery.of(context).size.height / 50.75, //16
                      verticalMargin: 0,
                      hasVerticalMargin: false,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 16.24, //50
                      borderRadius:
                          MediaQuery.of(context).size.height / 81.2, //10
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width / 18.75, //20
                          ),
                          SmallText(
                            text: widget.pageName == "orders"
                                ? OrderUserData.getOrderHistoryFromShowing() ==
                                        ""
                                    ? AppLocalizations.of(context)!
                                        .translate("choose the data")
                                    : OrderUserData.getOrderHistoryFromShowing()
                                : widget.pageName == "follow_source"
                                    ? FollowSourceUserData
                                                .getFollowSourcesHistoryFromShowing() ==
                                            ""
                                        ? AppLocalizations.of(context)!
                                            .translate("choose the data")
                                        : FollowSourceUserData
                                            .getFollowSourcesHistoryFromShowing()
                                    : widget.pageName == "control_panel"
                                        ? ControlPanleUserData
                                                    .getControlPanelHistoryFromShowing() ==
                                                ""
                                            ? AppLocalizations.of(context)!
                                                .translate("choose the data")
                                            : ControlPanleUserData
                                                .getControlPanelHistoryFromShowing()
                                        : FollowPrefUserData
                                                    .getFollowprefHistoryFromShowing() ==
                                                ""
                                            ? AppLocalizations.of(context)!
                                                .translate("choose the data")
                                            : FollowPrefUserData
                                                .getFollowprefHistoryFromShowing(),
                            color: hintColor,
                            size: MediaQuery.of(context).size.height / 58,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                themeProvider.isDarkMode
                                    ? Image.asset("assets/images/downdark.png",
                                        color: hintColor)
                                    : Image.asset(
                                        "assets/images/down.png",
                                        color: hintColor,
                                      ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      31.25, //12
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  _dimenssion(themeProvider, "History To"),
                  InkWell(
                    onTap: () async {
                      DateTime? pickDate2 = await showDatePicker(
                        context: context,
                        initialDate: data2,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2050),
                      );
                      if (pickDate2 == null) return;

                      final newDateTime2 = DateTime(
                        pickDate2.year,
                        pickDate2.month,
                        pickDate2.day,
                        dateTo.hour,
                        dateTo.minute,
                        dateTo.second,
                      );

                      setState(() {
                        dateTo = newDateTime2;
                        data2 = pickDate2; //for showing
                        _isDataToSelect = true;
                        _checkDate = true;
                        print("date to :  $dateTo");
                        widget.pageName == "orders"
                            ? OrderUserData.setOrderHistoryToShowing(
                                data2.toString().split(" ")[0])
                            : widget.pageName == "follow_source"
                                ? FollowSourceUserData
                                    .setFollowSourceHistoryToShowing(
                                        data2.toString().split(" ")[0])
                                : widget.pageName == "control_panel"
                                    ? ControlPanleUserData
                                        .setControlPanelHistoryToShowing(
                                            data2.toString().split(" ")[0])
                                    : FollowPrefUserData
                                        .setFollowprefHistoryToShowing(
                                            data2.toString().split(" ")[0]);
                      });
                    },
                    child: CustomContainer(
                      color: themeProvider.isDarkMode
                          ? Color(0xff292828)
                          : whiteColor,
                      hasHorizontalMargin: true,
                      horizontalMargin:
                          MediaQuery.of(context).size.height / 50.75, //16
                      verticalMargin: 0,
                      hasVerticalMargin: false,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 16.24, //50
                      borderRadius:
                          MediaQuery.of(context).size.height / 81.2, //10
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width / 18.75, //20
                          ),
                          SmallText(
                            text: widget.pageName == "orders"
                                ? OrderUserData.getOrderHistoryToShowing() == ""
                                    ? AppLocalizations.of(context)!
                                        .translate("choose the data")
                                    : OrderUserData.getOrderHistoryToShowing()
                                : widget.pageName == "follow_source"
                                    ? FollowSourceUserData
                                                .getFollowSourceHistoryToShowing() ==
                                            ""
                                        ? AppLocalizations.of(context)!
                                            .translate("choose the data")
                                        : FollowSourceUserData
                                            .getFollowSourceHistoryToShowing()
                                    : widget.pageName == "control_panel"
                                        ? ControlPanleUserData
                                                    .getControlPanelHistoryToShowing() ==
                                                ""
                                            ? AppLocalizations.of(context)!
                                                .translate("choose the data")
                                            : ControlPanleUserData
                                                .getControlPanelHistoryToShowing()
                                        : FollowPrefUserData
                                                    .getFollowprefHistoryToShowing() ==
                                                ""
                                            ? AppLocalizations.of(context)!
                                                .translate("choose the data")
                                            : FollowPrefUserData
                                                .getFollowprefHistoryToShowing(),
                            color: hintColor,
                            size: MediaQuery.of(context).size.height / 58,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                themeProvider.isDarkMode
                                    ? Image.asset("assets/images/downdark.png",
                                        color: hintColor)
                                    : Image.asset(
                                        "assets/images/down.png",
                                        color: hintColor,
                                      ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      31.25, //12
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  _dimenssion(themeProvider, "today"),
                  InkWell(
                    onTap: () async {
                      DateTime? pickDate3 = await showDatePicker(
                        context: context,
                        initialDate: day1,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2050),
                      );
                      if (pickDate3 == null) return;

                      final newDateTime3 = DateTime(
                        pickDate3.year,
                        pickDate3.month,
                        pickDate3.day,
                        day.hour,
                        day.minute,
                        day.second,
                      );

                      setState(() {
                        day = newDateTime3;
                        day = pickDate3; //for showing
                        _isday = true;
                        _checkDate = true;
                        print("day: $day");
                        widget.pageName == "orders"
                            ? OrderUserData.setOrderDayShowing(
                                day.toString().split(" ")[0])
                            : widget.pageName == "follow_source"
                                ? FollowSourceUserData
                                    .setFollowSourceDayShowing(
                                        day.toString().split(" ")[0])
                                : widget.pageName == "control_panel"
                                    ? ControlPanleUserData
                                        .setControlPanelDayShowing(
                                            day.toString().split(" ")[0])
                                    : FollowPrefUserData
                                        .setFollowprefDayShowing(
                                            day.toString().split(" ")[0]);
                      });
                    },
                    child: CustomContainer(
                      color: themeProvider.isDarkMode
                          ? Color(0xff292828)
                          : whiteColor,
                      hasHorizontalMargin: true,
                      horizontalMargin:
                          MediaQuery.of(context).size.height / 50.75, //16
                      verticalMargin: 0,
                      hasVerticalMargin: false,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 16.24, //50
                      borderRadius:
                          MediaQuery.of(context).size.height / 81.2, //10
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width / 18.75, //20
                          ),
                          SmallText(
                            text: widget.pageName == "orders"
                                ? OrderUserData.getOrderDayShowing() == ""
                                    ? AppLocalizations.of(context)!
                                        .translate("Choose the Day")
                                    : OrderUserData.getOrderDayShowing()
                                : widget.pageName == "follow_source"
                                    ? FollowSourceUserData
                                                .getFollowSourceDayShowing() ==
                                            ""
                                        ? AppLocalizations.of(context)!
                                            .translate("choose the data")
                                        : FollowSourceUserData
                                            .getFollowSourceDayShowing()
                                    : widget.pageName == "control_panel"
                                        ? ControlPanleUserData
                                                    .getControlPanelDayShowing() ==
                                                ""
                                            ? AppLocalizations.of(context)!
                                                .translate("choose the data")
                                            : ControlPanleUserData
                                                .getControlPanelDayShowing()
                                        : FollowPrefUserData
                                                    .getFollowprefDayShowing() ==
                                                ""
                                            ? AppLocalizations.of(context)!
                                                .translate("choose the data")
                                            : FollowPrefUserData
                                                .getFollowprefDayShowing(),
                            color: hintColor,
                            size: MediaQuery.of(context).size.height / 58,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                themeProvider.isDarkMode
                                    ? Image.asset("assets/images/downdark.png",
                                        color: hintColor)
                                    : Image.asset(
                                        "assets/images/down.png",
                                        color: hintColor,
                                      ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      31.25, //12
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height /
                        16.91666666666667, //48
                  ),
                  _saveAndCancledButton(themeProvider, navigatonBarScreen),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40.6,
                  )
                ],
              ),
            ],
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

  _saveAndCancledButton(
      ThemeProvider themeProvider, NavigationBarScreen navigatonBarScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            height: MediaQuery.of(context).size.height / 18.04444444444444, //45
            width: MediaQuery.of(context).size.width / 2.272727272727273, //165
            btnLbl: "حفظ",
            onPressedFunction: () {
              _isDataFromSelect == true &&
                      _isDataToSelect == true &&
                      _isday == false
                  ? //filter by  to date history from history to
                  setState(() {
                      print("1");
                      widget.pageName == "orders"
                          ? OrderUserData.setOrderHistoryFromSearch(
                              dateFrom.toString())
                          : widget.pageName == "follow_source"
                              ? FollowSourceUserData
                                  .setFollowSourcesHistoryFromSearch(
                                      dateFrom.toString())
                              : widget.pageName == "control_panel"
                                  ? ControlPanleUserData
                                      .setControlPanelHistoryFromSearch(
                                          dateFrom.toString())
                                  : FollowPrefUserData
                                      .setFollowPrefHistoryFromSearch(
                                          dateFrom.toString());

                      widget.pageName == "orders"
                          ? OrderUserData.setOrderHistoryToSearch(
                              dateTo.toString())
                          : widget.pageName == "follow_source"
                              ? FollowSourceUserData
                                  .setFollowSourceHistoryToSearch(
                                      dateTo.toString())
                              : widget.pageName == "control_panel"
                                  ? ControlPanleUserData
                                      .setControlPanelHistoryToSearch(
                                          dateTo.toString())
                                  : FollowPrefUserData
                                      .setFollowprefHistoryToSearch(
                                          dateTo.toString());

                      widget.pageName == "orders"
                          ? OrderUserData.setOrderDaySearch("")
                          : widget.pageName == "follow_source"
                              ? FollowSourceUserData.setFollowSourceDaySearch(
                                  "")
                              : widget.pageName == "control_panel"
                                  ? ControlPanleUserData
                                      .setControlPanelDaySearch("")
                                  : FollowPrefUserData.setFollowprefDaySearch(
                                      "");

                      print(
                          "history From is ${OrderUserData.getOrderHistoryFromSearch()} \n history From is ${OrderUserData.getOrderHistoryToSearch()} ");
                      Navigator.pop(context);
                      Navigator.pop(context);
                      widget.pageName == "123"
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => FollwingPerformanceScreen()))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditNavigationBar()));
                      widget.pageName == "123"
                          ? ""
                          : navigatonBarScreen.updateNavigationIndex(
                              widget.pageName == "orders"
                                  ? 2
                                  : widget.pageName == "follow_source"
                                      ? 1
                                      : 3,
                            );
                    })
                  : _isday == true &&
                          _isDataFromSelect == false &&
                          _isDataToSelect == false
                      ? setState(() {
                          print("2");
                          widget.pageName == "orders"
                              ? OrderUserData.setOrderHistoryFromSearch("")
                              : widget.pageName == "follow_source"
                                  ? FollowSourceUserData
                                      .setFollowSourcesHistoryFromSearch(
                                          day.toString())
                                  : widget.pageName == "control_panel"
                                      ? ControlPanleUserData
                                          .setControlPanelHistoryFromSearch(
                                              day.toString())
                                      : FollowPrefUserData
                                          .setFollowPrefHistoryFromSearch(
                                              day.toString());

                          widget.pageName == "orders"
                              ? OrderUserData.setOrderHistoryToSearch("")
                              : widget.pageName == "follow_source"
                                  ? FollowSourceUserData
                                      .setFollowSourceHistoryToSearch(
                                          day.toString())
                                  : widget.pageName == "control_panel"
                                      ? ControlPanleUserData
                                          .setControlPanelHistoryToSearch(
                                              day.toString())
                                      : FollowPrefUserData
                                          .setFollowprefHistoryToSearch(
                                              day.toString());

                          widget.pageName == "orders"
                              ? OrderUserData.setOrderDaySearch(day.toString())
                              : widget.pageName == "follow_source"
                                  ? FollowSourceUserData
                                      .setFollowSourceDaySearch(day.toString())
                                  : widget.pageName == "control_panel"
                                      ? ControlPanleUserData
                                          .setControlPanelDaySearch(
                                              day.toString())
                                      : FollowPrefUserData
                                          .setFollowprefDaySearch(
                                              day.toString());

                          print("day is ${OrderUserData.getOrderDaySearch()}");

                          Navigator.pop(context);
                          Navigator.pop(context);
                          widget.pageName == "123"
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          FollwingPerformanceScreen()))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => EditNavigationBar()));
                          widget.pageName == "123"
                              ? ""
                              : navigatonBarScreen.updateNavigationIndex(
                                  widget.pageName == "orders"
                                      ? 2
                                      : widget.pageName == "follow_source"
                                          ? 1
                                          : 3,
                                );
                        }) //filter by day only //day

                      : setState(() {
                          ///for showing
                          widget.pageName == "orders"
                              ? OrderUserData.setOrderHistoryFromShowing("")
                              : widget.pageName == "follow_source"
                                  ? FollowSourceUserData
                                      .setFollowSourcesHistoryFromShowing("")
                                  : widget.pageName == "control_panel"
                                      ? ControlPanleUserData
                                          .setControlPanelHistoryFromShowing("")
                                      : FollowPrefUserData
                                          .setFollowprefHistoryFromShowing("");
                          widget.pageName == "orders"
                              ? OrderUserData.setOrderHistoryToShowing("")
                              : widget.pageName == "follow_source"
                                  ? FollowSourceUserData
                                      .setFollowSourceHistoryToShowing("")
                                  : widget.pageName == "control_panel"
                                      ? ControlPanleUserData
                                          .setControlPanelHistoryToShowing("")
                                      : FollowPrefUserData
                                          .setFollowprefHistoryToShowing("");
                          widget.pageName == "orders"
                              ? OrderUserData.setOrderDayShowing("")
                              : widget.pageName == "follow_source"
                                  ? FollowSourceUserData
                                      .setFollowSourceDayShowing("")
                                  : widget.pageName == "control_panel"
                                      ? ControlPanleUserData
                                          .setControlPanelDayShowing("")
                                      : FollowPrefUserData
                                          .setFollowprefDayShowing("");

                          ///for get data
                          widget.pageName == "orders"
                              ? OrderUserData.setOrderHistoryFromSearch("")
                              : widget.pageName == "follow_source"
                                  ? FollowSourceUserData
                                      .setFollowSourcesHistoryFromSearch("name")
                                  : widget.pageName == "control_panel"
                                      ? ControlPanleUserData
                                          .setControlPanelHistoryFromSearch("")
                                      : FollowPrefUserData
                                          .setFollowPrefHistoryFromSearch("");
                          widget.pageName == "orders"
                              ? OrderUserData.setOrderHistoryToSearch("")
                              : widget.pageName == "follow_source"
                                  ? FollowSourceUserData
                                      .setFollowSourceHistoryToSearch("name")
                                  : widget.pageName == "control_panel"
                                      ? ControlPanleUserData
                                          .setControlPanelHistoryToSearch("")
                                      : FollowPrefUserData
                                          .setFollowprefHistoryToSearch("");
                          widget.pageName == "orders"
                              ? OrderUserData.setOrderDaySearch("")
                              : widget.pageName == "follow_source"
                                  ? FollowSourceUserData
                                      .setFollowSourceDaySearch("")
                                  : widget.pageName == "control_panel"
                                      ? ControlPanleUserData
                                          .setControlPanelDaySearch("")
                                      : FollowPrefUserData
                                          .setFollowprefDaySearch("");

                          _isDataFromSelect = false;
                          _isDataToSelect = false;
                          _isday = false;

                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: mainAppColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  title: Column(
                                    children: [
                                      BigText(
                                        size:
                                            MediaQuery.of(context).size.height /
                                                73.81818181818182, //11
                                        color: blackColor,
                                        text: AppLocalizations.of(context)!
                                            .translate(
                                                "Must choose history from and history to only"),

                                        typeOfFontWieght: 1,
                                      ),
                                      BigText(
                                        size:
                                            MediaQuery.of(context).size.height /
                                                73.81818181818182, //11
                                        color: blackColor,
                                        text: AppLocalizations.of(context)!
                                            .translate(
                                          "Or choose Today only",
                                        ),
                                        typeOfFontWieght: 1,
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }); //filter by day only //day
            },
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
          CustomButton(
            height: MediaQuery.of(context).size.height / 18.04444444444444, //45
            width: MediaQuery.of(context).size.width / 2.272727272727273, //165
            btnLbl: "الغاء",
            onPressedFunction: () {
              Navigator.pop(context);
            },
            btnColor: themeProvider.isDarkMode ? Color(0xff292828) : whiteColor,
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
}
