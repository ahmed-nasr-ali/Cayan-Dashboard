// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:cayan/custom_widgets/customitem/custom_item.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/ui/Projects/delete%20project/delete_project.dart';
import 'package:cayan/ui/Projects/disable%20project/disable_project.dart';
import 'package:cayan/ui/Projects/edit%20project/edit_project.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingProject extends StatefulWidget {
  int userId;
  String userArbicName;
  String userEnglisName;
  String userArbicclassification;
  String userEnglisclassification;
  String userShortArbicDescription;
  String userShortEnglisDescription;
  String userArbicFullDescription;
  String userEnglisFullDescription;
  String userimage;
  bool is_block;
  SettingProject({
    Key? key,
    required this.userId,
    required this.userArbicName,
    required this.userEnglisName,
    required this.userArbicclassification,
    required this.userEnglisclassification,
    required this.userShortArbicDescription,
    required this.userShortEnglisDescription,
    required this.userArbicFullDescription,
    required this.userEnglisFullDescription,
    required this.userimage,
    required this.is_block,
  }) : super(key: key);

  @override
  State<SettingProject> createState() => _SettingProjectState();
}

class _SettingProjectState extends State<SettingProject> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height / 4.06, //286
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MediaQuery.of(context).size.height / 81.2),
          topRight: Radius.circular(MediaQuery.of(context).size.height / 81.2),
        ),
        color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 54.13333333333333, //15
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
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: EditProject(
                            userId: widget.userId,
                            userArbicName: widget.userArbicName,
                            userEnglisName: widget.userEnglisName,
                            userArbicclassification:
                                widget.userArbicclassification,
                            userEnglisclassification:
                                widget.userEnglisclassification,
                            userShortArbicDescription:
                                widget.userShortArbicDescription,
                            userShortEnglisDescription:
                                widget.userShortEnglisDescription,
                            userArbicFullDescription:
                                widget.userArbicFullDescription,
                            userEnglisFullDescription:
                                widget.userEnglisFullDescription,
                            userimage: widget.userimage,
                          ));
                    });
              },
              horzontalMargin:
                  MediaQuery.of(context).size.width / 53.57142857142857, //7
              verticalMargin: 0,
            ),
          ),

          Divider(
            height: 0,
            indent: MediaQuery.of(context).size.width / 37.5, //10
            endIndent: MediaQuery.of(context).size.width / 37.5, //10
            color: themeProvider.isDarkMode ? dividerDarkColor : containerColor,
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
                        child: DisableProject(
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
            color: themeProvider.isDarkMode ? dividerDarkColor : containerColor,
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
                        child: DeleteProject(
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
    );
  }
}
