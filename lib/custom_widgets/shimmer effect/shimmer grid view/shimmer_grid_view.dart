import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGridView extends StatefulWidget {
  const ShimmerGridView({Key? key}) : super(key: key);

  @override
  State<ShimmerGridView> createState() => _ShimmerGridViewState();
}

class _ShimmerGridViewState extends State<ShimmerGridView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Shimmer.fromColors(
        baseColor:
            themeProvider.isDarkMode ? dividerDarkColor : Colors.grey[300]!,
        highlightColor: themeProvider.isDarkMode
            ? Colors.grey.shade800
            : Colors.grey.shade200,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio:
                  (MediaQuery.of(context).size.width / 2.286585365853659) /
                      (MediaQuery.of(context).size.height /
                          4.776470588235294), //169/170
              crossAxisCount: 2,
              crossAxisSpacing: MediaQuery.of(context).size.width / 30, //15
              mainAxisSpacing: MediaQuery.of(context).size.height / 64.96, //15
            ),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 30,
                vertical: MediaQuery.of(context).size.height / 64.96),
            itemCount: 8,
            itemBuilder: (contex, index) {
              return gridViewBody(index, themeProvider);
            }));
  }

  Widget gridViewBody(int index, ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.height / 81.2),
      ),
    );
  }
}
