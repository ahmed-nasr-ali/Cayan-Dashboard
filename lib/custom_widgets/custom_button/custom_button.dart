// ignore_for_file: prefer_if_null_operators, deprecated_member_use, unnecessary_null_comparison, unnecessary_string_interpolations, use_key_in_widget_constructors, prefer_const_constructors

import 'package:cayan/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatelessWidget {
  final bool addtionalWidgit;

  final Widget? child;
  final Color btnColor;
  final String btnLbl;
  final double horizontalMargin;
  final double verticalMargin;
  final bool enableCircleBorder;
  final double? height;
  final double? width;
  final Function onPressedFunction;
  final TextStyle btnStyle;

  // final Color borderColor;

  final Color lightBorderColor;
  final Color darkBorderColor;

  const CustomButton({
    required this.btnLbl,
    required this.onPressedFunction,
    required this.btnColor,
    required this.btnStyle,
    // required this.borderColor,
    this.enableCircleBorder = false,
    this.height,
    this.width,
    required this.horizontalMargin,
    required this.verticalMargin,
    required this.lightBorderColor,
    required this.darkBorderColor,
    required this.addtionalWidgit,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: height == null
          ? MediaQuery.of(context).size.height / 16.24
          : height, //50
      width: width == null
          ? MediaQuery.of(context).size.width / 2.706666666666667
          : width, //300
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
      child: Builder(
        builder: (context) => RaisedButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            onPressedFunction();
          },
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: themeProvider.isDarkMode
                      ? darkBorderColor
                      : lightBorderColor
                  // color: borderColor != null
                  //     ? borderColor
                  //     : btnColor != null
                  //         ? btnColor
                  //         : Theme.of(context).primaryColor
                  ),
              borderRadius: BorderRadius.circular(enableCircleBorder
                  ? MediaQuery.of(context).size.height / 32.48
                  : MediaQuery.of(context).size.height / 81.2)),
          color: btnColor != null ? btnColor : Theme.of(context).primaryColor,
          child: child,
          // child: Container(
          //   alignment: Alignment.center,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Center(
          //         child: Text(
          //           '$btnLbl',
          //           style: btnStyle == null
          //               ? Theme.of(context).textTheme.button
          //               : btnStyle,
          //         ),
          //       ),
          //       addtionalWidgit ? child! : Container(),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
