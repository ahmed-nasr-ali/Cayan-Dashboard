// ignore_for_file: prefer_const_literals_to_create_immutables, sized_box_for_whitespace, must_be_immutable, unnecessary_this

import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowSourceWidget extends StatelessWidget {
  String name;
  int number;
  Color color;
  double? containerWidyh;
  FollowSourceWidget({
    Key? key,
    required this.name,
    required this.number,
    required this.color,
    this.containerWidyh = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height /
                  54.133333333333333333333 //13
              ),
          width: MediaQuery.of(context).size.width / 37.5,
          height: MediaQuery.of(context).size.height / 81.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: this.color,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 75,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmallText(
              align: TextAlign.start,
              size: MediaQuery.of(context).size.height / 67.66666666666667, //12
              color: this.color,
              text: name,
            ),
            Container(
              width: containerWidyh == 0
                  ? MediaQuery.of(context).size.width / 10.71428571428571
                  : containerWidyh, //50
              // color: mainAppColor,
              child: SmallText(
                align: TextAlign.start,
                size: MediaQuery.of(context).size.height / 58, //12
                color: themeProvider.isDarkMode ? whiteColor : blackColor,
                typeOfFontWieght: 1,
                text: number.toString(),
                maxLine: 2,
              ),
            ),
          ],
        )
      ],
    );
  }
}
