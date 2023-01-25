// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/customitem/custom_item.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/ui/Roles%20and%20Permissions/edit%20roles%20and%20permissions/edit_roles_and_permissions.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingRolesAndPermissions extends StatefulWidget {
  int id;
  SettingRolesAndPermissions({Key? key, required this.id}) : super(key: key);

  @override
  State<SettingRolesAndPermissions> createState() =>
      _SettingRolesAndPermissionsState();
}

class _SettingRolesAndPermissionsState
    extends State<SettingRolesAndPermissions> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NetworkIndicator(
      child: Container(
        height: MediaQuery.of(context).size.height / 8.12, //286
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
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: EditRolesAndPermissions(
                            id: widget.id,
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
          ],
        ),
      ),
    );
  }
}
