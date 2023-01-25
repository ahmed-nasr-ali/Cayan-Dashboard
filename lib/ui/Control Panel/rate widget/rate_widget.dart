// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RateWidget extends StatelessWidget {
  double precentageNo;
  String rateName;
  int ordersCount;
  int allNumber;
  Color rateColor;
  RateWidget({
    Key? key,
    required this.precentageNo,
    required this.rateName,
    required this.ordersCount,
    required this.allNumber,
    required this.rateColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width / 2.205882352941176,
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.height / 81.2),
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 27.06666666666667, //30
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5, //75
            height: MediaQuery.of(context).size.height / 10.82666666666667, //75
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: precentageNo,
                  valueColor: AlwaysStoppedAnimation(rateColor),
                  strokeWidth: MediaQuery.of(context).size.width / 37.5,
                  backgroundColor: containerColor,
                ),
                Center(
                  child: SmallText(
                    color: themeProvider.isDarkMode ? whiteColor : blackColor,
                    text: UserData.getUSerLang() == "ar"
                        ? "%" + (precentageNo * 100).toStringAsFixed(0)
                        : (precentageNo * 100).toStringAsFixed(0) + "%",
                    typeOfFontWieght: 1,
                    size: MediaQuery.of(context).size.height /
                        54.13333333333333, //16
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 81.2, //5
          ),
          SmallText(
            text: rateName,
            color: themeProvider.isDarkMode ? whiteColor : blackColor,
            size: MediaQuery.of(context).size.height / 58, //18
            typeOfFontWieght: 1,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 67.66666666666667, //12
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 6.25,
                height: MediaQuery.of(context).size.height / 32.48,
                decoration: BoxDecoration(
                    color: rateColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: rateColor.withOpacity(0.2))),
                child: Center(
                  child: SmallText(
                    text: ordersCount.toString(),
                    color: rateColor,
                    size:
                        MediaQuery.of(context).size.height / 67.66666666666667,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 75,
              ),
              SmallText(text: "-"),
              SizedBox(
                width: MediaQuery.of(context).size.width / 75,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 6.25,
                height: MediaQuery.of(context).size.height / 32.48,
                decoration: BoxDecoration(
                  color: dividerDarkColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: SmallText(
                    text: allNumber.toString(),
                    size:
                        MediaQuery.of(context).size.height / 67.66666666666667,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 27.06666666666667, //30
          ),
        ],
      ),
    );
  }
}
