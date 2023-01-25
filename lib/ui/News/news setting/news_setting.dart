// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print, unused_local_variable, prefer_const_constructors

import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/ui/News/disable%20news/disable_news.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cayan/custom_widgets/customitem/custom_item.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/ui/News/delete_news/delete_news.dart';
import 'package:cayan/ui/News/edit%20news/edit_news.dart';
import 'package:cayan/utils/app_colors.dart';

class NewsSetting extends StatefulWidget {
  int userId;
  String userArbicName;
  String userEnglisName;
  String userArbicDescription;
  String userEnglisDescription;
  String userShortArbicDescription;
  String userShortEnglisDescription;
  String url;
  String userimage;
  String is_active;
  String date;
  bool is_block;

  NewsSetting({
    Key? key,
    required this.userId,
    required this.userArbicName,
    required this.userEnglisName,
    required this.userArbicDescription,
    required this.userEnglisDescription,
    required this.userShortArbicDescription,
    required this.userShortEnglisDescription,
    required this.url,
    required this.userimage,
    required this.is_active,
    required this.date,
    required this.is_block,
  }) : super(key: key);

  @override
  State<NewsSetting> createState() => _NewsSettingState();
}

class _NewsSettingState extends State<NewsSetting> {
  @override
  void initState() {
    super.initState();
    print(widget.is_active);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NetworkIndicator(
      child: Container(
        height: MediaQuery.of(context).size.height / 3.67420814479638, //286
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MediaQuery.of(context).size.height / 81.2),
            topRight:
                Radius.circular(MediaQuery.of(context).size.height / 81.2),
          ),
          color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
        ),
        child: Column(
          children: [
            SizedBox(
              height:
                  MediaQuery.of(context).size.height / 54.13333333333333, //15
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
              height: MediaQuery.of(context).size.height / 32.48, //25
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 23.4375), //16
              child: CustomItem(
                hasCenterwidgit: false,
                imgUrl: "assets/images/edit.png",
                hasLeadingWidget: false,
                hasTrailingWidget: false,
                hasLeadingImage: true,
                title: AppLocalizations.of(context)!.translate("edit"),
                hasTrailingImage: false,
                tapFunction: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: EditNews(
                              userId: widget.userId,
                              userArbicName: widget.userArbicName,
                              userEnglisName: widget.userEnglisName,
                              userArbicDescription: widget.userArbicDescription,
                              userEnglisDescription:
                                  widget.userEnglisDescription,
                              userShortArbicDescription:
                                  widget.userShortArbicDescription,
                              userShortEnglisDescription:
                                  widget.userShortEnglisDescription,
                              url: widget.url,
                              userimage: widget.userimage,
                              is_active: widget.is_active,
                              date: widget.date,
                            ));
                      });
                },
                horzontalMargin:
                    MediaQuery.of(context).size.width / 53.57142857142857, //7
                verticalMargin: 0,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 81.2, //10
            ),
            Divider(
              height: 0,
              indent: MediaQuery.of(context).size.width / 37.5, //10
              endIndent: MediaQuery.of(context).size.width / 37.5, //10
              color:
                  themeProvider.isDarkMode ? dividerDarkColor : containerColor,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 81.2, //10
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 23.4375), //16
              child: CustomItem(
                hasCenterwidgit: false,
                imgUrl: "assets/images/blocksetting.png",
                hasLeadingWidget: false,
                hasTrailingWidget: false,
                hasLeadingImage: true,
                title: widget.is_block == true
                    ? AppLocalizations.of(context)!.translate("Active")
                    : AppLocalizations.of(context)!.translate("disable"),
                hasTrailingImage: false,
                tapFunction: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: DisableNews(
                            userId: widget.userId,
                            is_block: widget.is_block,
                          ),
                        );
                      });
                },
                horzontalMargin:
                    MediaQuery.of(context).size.width / 53.57142857142857, //7
                verticalMargin: 0,
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height / 81.2, //10
            ),
            Divider(
              height: 0,
              indent: MediaQuery.of(context).size.width / 37.5, //10
              endIndent: MediaQuery.of(context).size.width / 37.5, //10
              color:
                  themeProvider.isDarkMode ? dividerDarkColor : containerColor,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 81.2,
            ), //10
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 23.4375), //16
              child: CustomItem(
                hasCenterwidgit: false,
                imgUrl: "assets/images/delete.png",
                hasLeadingWidget: false,
                hasTrailingWidget: false,
                hasLeadingImage: true,
                title: AppLocalizations.of(context)!.translate("delete"),
                hasTrailingImage: false,
                tapFunction: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: DeleteNews(
                            id: widget.userId,
                          ),
                        );
                      });
                },
                horzontalMargin:
                    MediaQuery.of(context).size.width / 53.57142857142857, //7
                verticalMargin: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
