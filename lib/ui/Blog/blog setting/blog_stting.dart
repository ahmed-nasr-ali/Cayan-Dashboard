// ignore_for_file: non_constant_identifier_names, must_be_immutable, unused_local_variable, avoid_print

import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/customitem/custom_item.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/ui/Blog/delete%20blog/delete_blog.dart';
import 'package:cayan/ui/Blog/disable%20blog/disable_block.dart';
import 'package:cayan/ui/Blog/edit%20blog/edit_blog.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlogSetting extends StatefulWidget {
  int userId;
  String userArbicTitle;
  String userEnglisTitle;
  String userArbicDescription;
  String userEnglisDescription;
  String userShortArbicDescription;
  String userShortEnglisDescription;
  String reference_link;
  String userimage;
  bool is_block;
  String date;
  BlogSetting({
    Key? key,
    required this.userId,
    required this.userArbicTitle,
    required this.userEnglisTitle,
    required this.userArbicDescription,
    required this.userEnglisDescription,
    required this.userShortArbicDescription,
    required this.userShortEnglisDescription,
    required this.reference_link,
    required this.userimage,
    required this.is_block,
    required this.date,
  }) : super(key: key);

  @override
  State<BlogSetting> createState() => _BlogSettingState();
}

class _BlogSettingState extends State<BlogSetting> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NetworkIndicator(
      child: Container(
        height: MediaQuery.of(context).size.height / 3.690909090909091, //286
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
                            child: EditBlog(
                              userId: widget.userId,
                              userArbicTitle: widget.userArbicTitle,
                              userEnglisTitle: widget.userEnglisTitle,
                              userArbicDescription: widget.userArbicDescription,
                              userEnglisDescription:
                                  widget.userEnglisDescription,
                              userShortArbicDescription:
                                  widget.userShortArbicDescription,
                              userShortEnglisDescription:
                                  widget.userShortEnglisDescription,
                              reference_link: widget.reference_link,
                              userimage: widget.userimage,
                              is_block: widget.is_block,
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
                          child: DisableBlog(
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
                          child: DeleteBlog(
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
