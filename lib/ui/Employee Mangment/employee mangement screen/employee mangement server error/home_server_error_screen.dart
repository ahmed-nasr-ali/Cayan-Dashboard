// ignore_for_file: prefer_const_constructors, unused_local_variable, deprecated_member_use

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/safe_area/page_container.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/choosecountry.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/ui/drawer/navigation_drawer.dart';
import 'package:cayan/ui/edit%20navigation%20bar/edit_navigation_bar.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeMangmentServerError extends StatefulWidget {
  const EmployeeMangmentServerError({Key? key}) : super(key: key);

  @override
  State<EmployeeMangmentServerError> createState() =>
      _EmployeeMangmentServerErrorState();
}

class _EmployeeMangmentServerErrorState
    extends State<EmployeeMangmentServerError> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final countryProvider = Provider.of<ChooseCountryData>(context);
    return PageContainer(
      child: Scaffold(
        backgroundColor: themeProvider.isDarkMode ? blackColor : cardColor,
        appBar: AppBar(
          // actions: [
          //   Switch.adaptive(
          //       value: themeProvider.isDarkMode,
          //       onChanged: (value) {
          //         themeProvider.changeTheme(value);
          //       }),
          // ],
          backgroundColor:
              themeProvider.isDarkMode ? containerdarkColor : whiteColor,
          elevation: 0,
          centerTitle: true,
          title: BigText(
            typeOfFontWieght: 1,
            text: AppLocalizations.of(context)!.translate("Settings"),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: themeProvider.isDarkMode
                    ? Image.asset("assets/images/menudar.png")
                    : Image.asset("assets/images/menu.png"),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: NavigationDrawer(),
        body: Center(
          child: RaisedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => EditNavigationBar()),
                  (route) => false);
            },
            child: BigText(text: "Releod"),
          ),
        ),
      ),
    );
  }
}
