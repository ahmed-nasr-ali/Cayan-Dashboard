// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields, prefer_const_constructors, unnecessary_string_interpolations, unnecessary_new, unused_local_variable, prefer_interpolation_to_compose_strings, unused_field

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/custom_container/custom_container.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/order%20user%20data/order_user_data.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseTimeBottomSheet extends StatefulWidget {
  const ChooseTimeBottomSheet({Key? key}) : super(key: key);

  @override
  State<ChooseTimeBottomSheet> createState() => _ChooseTimeBottomSheetState();
}

class _ChooseTimeBottomSheetState extends State<ChooseTimeBottomSheet> {
  bool _isDataSelect = false;
  bool _isTimeSelect = false;
  DateTime data = DateTime.now(); //for show only in calendar

  DateTime dateTime = DateTime(2022, 12, 24, 12, 30);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, "0");
    final minuts = dateTime.minute.toString().padLeft(2, "0");
    final second = dateTime.second.toString().padLeft(2, "0");

    final themeProvider = Provider.of<ThemeProvider>(context);

    return NetworkIndicator(
      child: DraggableScrollableSheet(
        initialChildSize: 0.5665024630541872, //450
        maxChildSize: 0.5665024630541872, //450
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width / 23.4375), //16
                      child: BigText(
                        text: AppLocalizations.of(context)!
                            .translate("choose the data aad time"),
                        typeOfFontWieght: 1,
                        size: MediaQuery.of(context).size.height / 50.75, //16
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
                    _dimenssion(themeProvider, "choose the data"),
                    InkWell(
                      onTap: () async {
                        DateTime? pickDate = await showDatePicker(
                          context: context,
                          initialDate: data,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2050),
                        );

                        if (pickDate == null) return;

                        final newDateTime = DateTime(
                          pickDate.year,
                          pickDate.month,
                          pickDate.day,
                          dateTime.hour,
                          dateTime.minute,
                          dateTime.second,
                        );

                        setState(() {
                          dateTime = newDateTime;
                          data = pickDate; //for showing
                          _isDataSelect = true;
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
                              width: MediaQuery.of(context).size.width /
                                  18.75, //20
                            ),
                            SmallText(
                              text: AppLocalizations.of(context)!
                                  .translate("choose the data"),
                              color: hintColor,
                              size: MediaQuery.of(context).size.height / 58,
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
                    _dimenssion(themeProvider, "Choose the time"),
                    InkWell(
                      onTap: () async {
                        TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: dateTime.hour,
                            minute: dateTime.minute,
                          ),
                        );

                        if (time == null) return;

                        final newDateTime = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          time.hour,
                          time.minute,
                          dateTime.second,
                        );

                        setState(() {
                          dateTime = newDateTime;
                          _isTimeSelect = true;
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
                              width: MediaQuery.of(context).size.width /
                                  18.75, //20
                            ),
                            SmallText(
                              text: AppLocalizations.of(context)!
                                  .translate("Choose the time"),
                              color: hintColor,
                              size: MediaQuery.of(context).size.height / 58,
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
          CustomButton(
            height: MediaQuery.of(context).size.height / 18.04444444444444, //45
            width: MediaQuery.of(context).size.width / 2.272727272727273, //165
            btnLbl: "حفظ",
            onPressedFunction: () {
              String x =
                  _isDataSelect && _isTimeSelect ? dateTime.toString() : "";
              var y = x.split(".");
              // print(y[0]); // 2022-09-30 12:30:00
              OrderUserData.setOrderDateAndTime(y[0]);

              OrderUserData.getOrderDateAndTime() == ""
                  ? showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: mainAppColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          title: BigText(
                            size: MediaQuery.of(context).size.height /
                                73.81818181818182, //11
                            color: blackColor,
                            text: AppLocalizations.of(context)!
                                .translate("You must choose Date and Time"),
                            typeOfFontWieght: 1,
                          ),
                        );
                      })
                  : Navigator.pop(context);
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
