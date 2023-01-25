// ignore_for_file: use_key_in_widget_constructors, unnecessary_this, sized_box_for_whitespace, unused_local_variable

import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double hight;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    required this.width,
    required this.hight,
  }) : this.shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular(
      {required this.hight,
      required this.width,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Shimmer.fromColors(
      baseColor:
          themeProvider.isDarkMode ? dividerDarkColor : Colors.grey[300]!,
      highlightColor: themeProvider.isDarkMode
          ? Colors.grey.shade800
          : Colors.grey.shade200,
      child: Container(
        width: this.width,
        height: this.hight,
        decoration: ShapeDecoration(
          shape: shapeBorder,
          color: Colors.grey,
        ),
      ),
    );
  }
}
