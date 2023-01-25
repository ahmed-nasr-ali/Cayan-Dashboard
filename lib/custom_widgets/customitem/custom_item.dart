// ignore_for_file: sized_box_for_whitespace

import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomItem extends StatelessWidget {
  final double horzontalMargin;
  final double verticalMargin;
  final bool? hasLeadingImage;
  final Function? tapFunction;
  final String? imgUrl;
  final bool? hasLeadingWidget;
  final Widget? leadingWidget;
  final String? title;
  final bool? hasTrailingImage;
  final String? trailingImageUrl;
  final bool? hasTrailingWidget;
  final Widget? trailingWidget;
  final bool? hasCenterwidgit;
  final Widget? centerWidgit;

  const CustomItem(
      {super.key,
      this.tapFunction,
      this.hasLeadingImage,
      this.imgUrl,
      this.hasLeadingWidget,
      this.leadingWidget,
      required this.horzontalMargin,
      required this.verticalMargin,
      this.title,
      this.hasTrailingImage,
      this.trailingImageUrl,
      this.hasTrailingWidget,
      this.trailingWidget,
      this.hasCenterwidgit,
      this.centerWidgit});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height / 20.3, //40
      child: InkWell(
        onTap: () {
          tapFunction!();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                hasLeadingImage!
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: horzontalMargin,
                            vertical: verticalMargin),
                        child: Image.asset(
                          imgUrl!,
                        ),
                      )
                    : hasLeadingWidget!
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: horzontalMargin,
                                vertical: verticalMargin),
                            child: leadingWidget,
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: horzontalMargin,
                                vertical: verticalMargin),
                          ),
                !hasCenterwidgit!
                    ? SmallText(
                        text: title!,
                        color:
                            themeProvider.isDarkMode ? whiteColor : blackColor,
                      )
                    : Container(
                        child: centerWidgit,
                      )
              ],
            ),
            hasTrailingImage!
                ? Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: horzontalMargin, vertical: verticalMargin),
                    child: Image.asset(
                      trailingImageUrl!,
                      // color: mainAppColor,
                    ),
                  )
                : hasTrailingWidget!
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: horzontalMargin,
                            vertical: verticalMargin),
                        child: trailingWidget,
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
