// ignore_for_file: prefer_const_constructors, prefer_equal_for_default_values, use_key_in_widget_constructors

import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const ShimmerAppbar({
    this.preferredSize: const Size.fromHeight(55.0),
  });

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
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(),
          color: Colors.grey,
        ),
      ),
    );
  }
}
