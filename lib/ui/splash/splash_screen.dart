// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, unused_field

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cayan/custom_widgets/safe_area/page_container.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/shared_preferences/control%20panel/control_panel.dart';
import 'package:cayan/shared_preferences/follow%20source%20data/follow_source_data.dart';
import 'package:cayan/shared_preferences/follow_prefrmance/follow_prefromance_data.dart';
import 'package:cayan/shared_preferences/order%20user%20data/order_user_data.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/edit%20navigation%20bar/edit_navigation_bar.dart';

import 'package:cayan/ui/language/language_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _isLogIN = '';

  Future fetchData() async {
    _isLogIN = UserData.getUserApiToken();
  }

  @override
  void initState() {
    super.initState();
    fetchData();

    ///(المفروض احط السطرين دول في كل الاسكرنات)
    OrderUserData.setOrderStatusIdForSearch(0); //(عشان الفلتر بتاع الطلبات )
    OrderUserData.setOrderStatusNameForSearch(""); //(عشان الفلتر بتاع الطلبات )
    OrderUserData.setOrderDaySearch(""); //(عشان الفلتر بتاع الطلبات )
    OrderUserData.setOrderHistoryFromSearch(""); //(عشان الفلتر بتاع الطلبات )
    OrderUserData.setOrderHistoryToSearch(""); //(عشان الفلتر بتاع الطلبات )

    FollowSourceUserData.setFollowSourcesHistoryFromSearch(
        ""); //(عشان الفلتر بتاع متابعة المصادر)
    FollowSourceUserData.setFollowSourceHistoryToSearch(
        ""); //(عشان الفلتر بتاع متابعة المصادر)
    FollowSourceUserData.setFollowSourceDaySearch(
        ""); //(عشان الفلتر بتاع متابعة المصادر)

    ControlPanleUserData.setControlPanelHistoryFromSearch(
        ""); //(عشان الفلتر بتاع لوحة التحكم )
    ControlPanleUserData.setControlPanelHistoryToSearch(
        ""); //(عشان الفلتر بتاع لوحة التحكم )
    ControlPanleUserData.setControlPanelDaySearch(
        ""); //(عشان الفلتر بتاع لوحة التحكم )

    FollowPrefUserData.setFollowPrefHistoryFromSearch(
        ""); //(عشان الفلتر بتاع متابعة الاداء)
    FollowPrefUserData.setFollowprefHistoryToSearch(
        ""); //(عشان الفلتر بتاع متابعة الاداء)
    FollowPrefUserData.setFollowprefDaySearch(
        ""); //(عشان الفلتر بتاع متابعة الاداء)
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Scaffold(
        body: AnimatedSplashScreen(
          splash: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/bg.png'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Image.asset("assets/images/splashlogo.png")),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 38.6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!
                          .translate("This product is provided by")),
                      Image.asset(
                        "assets/images/splashlogo.png",
                        width: MediaQuery.of(context).size.width / 14.4,
                        height: MediaQuery.of(context).size.height / 30.88,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          duration: 2500,
          nextScreen: _isLogIN == "" ? LanguageScreen() : EditNavigationBar(),
          splashIconSize: MediaQuery.of(context).size.height,
          pageTransitionType: PageTransitionType.rightToLeftWithFade,
          animationDuration: Duration(seconds: 2),
        ),
      ),
    );
  }
}
