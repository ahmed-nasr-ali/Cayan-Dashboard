// ignore_for_file: must_be_immutable

import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListView extends StatefulWidget {
  double hight;
  int? itemLength;
  ShimmerListView({
    Key? key,
    this.itemLength = 0,
    required this.hight,
  }) : super(key: key);

  @override
  State<ShimmerListView> createState() => _ShimmerListViewState();
}

class _ShimmerListViewState extends State<ShimmerListView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Shimmer.fromColors(
        baseColor:
            themeProvider.isDarkMode ? dividerDarkColor : Colors.grey[300]!,
        highlightColor: themeProvider.isDarkMode
            ? Colors.grey.shade800
            : Colors.grey.shade200,
        child: ListView.builder(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 25,
                right: MediaQuery.of(context).size.width / 25,
                top: MediaQuery.of(context).size.height /
                    54.13333333333333), //15
            itemCount: widget.itemLength == 0 ? 6 : widget.itemLength,
            itemBuilder: (context, index) {
              return listViewBody(index, themeProvider);
            }));
  }

  Widget listViewBody(int index, ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height / 54.13333333333333, //15
      ), //15
      width: MediaQuery.of(context).size.width,
      height: widget.hight,
      decoration: BoxDecoration(
          color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.height / 81.2)),
    );
  }
}
