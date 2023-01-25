// ignore_for_file: prefer_const_constructors, must_be_immutable, non_constant_identifier_names

import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cayan/custom_widgets/customitem/custom_item.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/choosecountry.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Employee%20Mangment/ban%20employee/ban_employee.dart';
import 'package:cayan/ui/Employee%20Mangment/change%20passward/change_passward.dart';
import 'package:cayan/ui/Employee%20Mangment/edit%20employees/edit%20employee/edit_employee.dart';
import 'package:cayan/ui/Employee%20Mangment/exist%20emplyoee/exist_employee.dart';
import 'package:cayan/utils/app_colors.dart';

class SettingEmployeeBody extends StatefulWidget {
  int userId;
  String userName;
  String userEmail;
  String userPhone;
  String userImage;
  int userCountryID;
  String userCountryName;
  String userCountryCode;
  String userCountryImage;
  int userPerimission;
  bool is_block;

  SettingEmployeeBody({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userImage,
    required this.userCountryID,
    required this.userCountryName,
    required this.userCountryCode,
    required this.userCountryImage,
    required this.userPerimission,
    required this.is_block,
  }) : super(key: key);

  @override
  State<SettingEmployeeBody> createState() => _SettingEmployeeBodyState();
}

class _SettingEmployeeBodyState extends State<SettingEmployeeBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final countryProvider = Provider.of<ChooseCountryData>(context);
    return NetworkIndicator(
      child: Container(
        height: MediaQuery.of(context).size.height / 2.839160839160839, //286
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(MediaQuery.of(context).size.height / 81.2),
                topRight:
                    Radius.circular(MediaQuery.of(context).size.height / 81.2)),
            color: themeProvider.isDarkMode ? containerdarkColor : whiteColor),
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
                  setState(() {
                    ///(بحفظ البيانات الخاصه بالدوله بالنسبه للمستخدم دا)
                    UserData.setEditEmloyeeCountryId(widget.userCountryID);

                    // print(UserData.getEditEmloyeeCountryId());

                    UserData.setEditEmloyeeCountryName(widget.userCountryName);

                    // print(UserData.getEditEmloyeeCountryName());

                    UserData.setEditEmloyeeCountryCode(widget.userCountryCode);

                    // print(UserData.getEditEmloyeeCountryCode());

                    UserData.setEditEmloyeeCountryImage(
                        widget.userCountryImage);

                    // print(UserData.getEditEmloyeeCountryImage());
                    // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                    countryProvider.setcounntryinfor('');

                    UserData.setPermissionsGuardName("");

                    UserData.setEditEmployeePermissionsId(
                        widget.userPerimission);
                    // print(UserData.setEditEmployeePermissionsId(
                    //     widget.userPerimission));

                    UserData.setPermissionsName("");
                  });
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: EditEmployee(
                            userId: widget.userId,
                            userName: widget.userName,
                            userEmail: widget.userEmail,
                            userPhone: widget.userPhone,
                            userImage: widget.userImage,
                            userCountryID: widget.userCountryID,
                            userCountryCode: widget.userCountryCode,
                            userCountryImage: widget.userCountryImage,
                            userPerimission: widget.userPerimission,
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
              height: MediaQuery.of(context).size.height / 81.2, //10
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 23.4375), //16
              child: CustomItem(
                hasCenterwidgit: false,
                imgUrl: "assets/images/changepass.png",
                hasLeadingWidget: false,
                hasTrailingWidget: false,
                hasLeadingImage: true,
                title:
                    AppLocalizations.of(context)!.translate("change passward"),
                hasTrailingImage: false,
                tapFunction: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: ChangePassward(
                            userId: widget.userId,
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
                imgUrl: "assets/images/Exit.png",
                hasLeadingWidget: false,
                hasTrailingWidget: false,
                hasLeadingImage: true,
                title: AppLocalizations.of(context)!.translate("exist"),
                hasTrailingImage: false,
                tapFunction: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: ExistEmployee(
                            userId: widget.userId,
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
              height: MediaQuery.of(context).size.height / 81.2,
            ), //10
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
                imgUrl: "assets/images/block.png",
                hasLeadingWidget: false,
                hasTrailingWidget: false,
                hasLeadingImage: true,
                title: widget.is_block
                    ? AppLocalizations.of(context)!.translate("Active")
                    : AppLocalizations.of(context)!.translate("ban"),
                hasTrailingImage: false,
                tapFunction: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: BanEmployee(
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
          ],
        ),
      ),
    );
  }
}
