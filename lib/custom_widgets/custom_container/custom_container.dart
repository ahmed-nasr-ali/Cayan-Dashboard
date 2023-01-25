// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unnecessary_this

import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final bool? isSelected;
  final double? width;
  final double? height;
  final double? horizontalMargin;
  final double? verticalMargin;
  final double? borderRadius;
  final bool hasHorizontalMargin;
  final bool hasVerticalMargin;
  final Color color;

  const CustomContainer({
    Key? key,
    this.child,
    this.isSelected,
    this.width,
    this.height,
    this.horizontalMargin,
    this.verticalMargin,
    this.borderRadius,
    this.hasHorizontalMargin = true,
    this.hasVerticalMargin = true,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(
            horizontal: hasHorizontalMargin ? horizontalMargin! : 0,
            vertical: verticalMargin!),
        child: child,
        decoration: BoxDecoration(
          color: this.color,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
          border: Border.all(
              color: isSelected == true
                  ? mainAppColor
                  : themeProvider.isDarkMode
                      ? containerdarkColor
                      : containerColor),
        ),
      );
    });
  }
}
