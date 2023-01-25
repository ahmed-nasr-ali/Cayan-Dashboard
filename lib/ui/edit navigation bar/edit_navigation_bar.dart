// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_local_variable, prefer_const_literals_to_create_immutables, avoid_print, sized_box_for_whitespace

import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/navigation_bar_screen.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditNavigationBar extends StatefulWidget {
  const EditNavigationBar({Key? key}) : super(key: key);

  @override
  State<EditNavigationBar> createState() => _EditNavigationBarState();
}

class _EditNavigationBarState extends State<EditNavigationBar> {
  int pageNumber = 0;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final navigatonBarScreen = Provider.of<NavigationBarScreen>(context);
    return Scaffold(
        backgroundColor: themeProvider.isDarkMode ? blackColor : whiteColor,
        body: navigatonBarScreen.screenCount,
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height / 12.49230769230769, //65
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor:
                themeProvider.isDarkMode ? whiteColor : blackColor,
            backgroundColor:
                themeProvider.isDarkMode ? containerdarkColor : whiteColor,
            unselectedItemColor: textGrayColor,
            selectedFontSize: MediaQuery.of(context).size.height / 81.2,
            unselectedFontSize: MediaQuery.of(context).size.height / 81.2,
            currentIndex: navigatonBarScreen.notificationIndex,
            onTap: (index) {
              setState(() {
                pageNumber = index;
              });
              print(pageNumber);
              navigatonBarScreen.updateNavigationIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/settings.png",
                  color: navigatonBarScreen.notificationIndex == 0
                      ? mainAppColor
                      : textGrayColor,
                ),
                label: AppLocalizations.of(context)!.translate("Settings"),
                //  backgroundColor: Colors.greenAccent,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/resources.png",
                  color: navigatonBarScreen.notificationIndex == 1
                      ? mainAppColor
                      : textGrayColor,
                ),
                label:
                    AppLocalizations.of(context)!.translate("follwing source"),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/task-square.png",
                  color: navigatonBarScreen.notificationIndex == 2
                      ? mainAppColor
                      : textGrayColor,
                ),
                label: AppLocalizations.of(context)!.translate("Orders"),
                //  backgroundColor: Colors.greenAccent,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/dashal.png",
                  color: navigatonBarScreen.notificationIndex == 3
                      ? mainAppColor
                      : textGrayColor,
                ),
                label: AppLocalizations.of(context)!.translate("control_panel"),
                //  backgroundColor: Colors.greenAccent,
              ),
            ],
          ),
        ));
  }
}
