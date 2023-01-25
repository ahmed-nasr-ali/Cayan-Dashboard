// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_element, use_build_context_synchronously, prefer_const_constructors_in_immutables, unused_field, unused_local_variable, unnecessary_string_interpolations, prefer_final_fields, empty_catches

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/navigation_bar_screen.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Blog/blog%20screen/blog_screen.dart';
import 'package:cayan/ui/Branches/branch%20screen/branch_screen.dart';
import 'package:cayan/ui/Categories/categories%20screen/category_screem.dart';
import 'package:cayan/ui/Customer%20Management/customer%20management%20screen/customer_management_screen.dart';
import 'package:cayan/ui/Customer%20Reviews/customer%20reviews%20screen/customer_reviews_screen.dart';
import 'package:cayan/ui/Employee%20Mangment/employee%20mangement%20screen/employee_mangement_screen.dart';
import 'package:cayan/ui/Follwing%20performance/follwing%20performance%20screen/follwing_performance_screen.dart';
import 'package:cayan/ui/News/news%20screen/news_secreen.dart';
import 'package:cayan/ui/Offers/offers%20screen/offers_screen.dart';
import 'package:cayan/ui/Projects/project%20screen/project_screen.dart';
import 'package:cayan/ui/Roles%20and%20Permissions/roles%20and%20permissions%20screen/roles_permissions_screen.dart';
import 'package:cayan/ui/Services/services%20screen/services_screen.dart';
import 'package:cayan/ui/Team%20work/team%20work%20screen/team_work_screen.dart';
import 'package:cayan/ui/edit%20navigation%20bar/edit_navigation_bar.dart';
import 'package:cayan/ui/logInScreen/log_in_screen.dart';
import 'package:cayan/ui/sources/sources%20screen/sources_screen.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  bool _isLoading = false;
  List _drawerItem = [];

  http.Client clientApi = http.Client();

  void _getDraweItem() async {
    try {
      final unauthorizedError =
          Provider.of<UnauthorizedError>(context, listen: false);

      final homeServerError =
          Provider.of<HomeServerError>(context, listen: false);

      final erro403 = Provider.of<Error403>(context, listen: false);

      setState(() {
        _isLoading = true;
      });

      final response = await clientApi.get(
          Uri.parse(
            "${Urls.GeT_ITEMS_OF_DRAWERL}",
          ),
          headers: <String, String>{
            'Accept': 'application/json',
            "Accept-Language": UserData.getUSerLang(),
            'Content-Type': 'application/json',
            "Authorization": "Bearer ${UserData.getUserApiToken()}"
          });
      if (response.statusCode == 200) {
        setState(() {
          _drawerItem = json.decode(response.body);
        });
      } else if (response.statusCode == 401) {
        unauthorizedError.unauthorizedErrors401(context);
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 422) {
        Navigator.of(context).popUntil((route) => route.isFirst);

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: mainAppColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                title: BigText(
                  color: blackColor,
                  text: AppLocalizations.of(context)!
                      .translate("There is an internet connection error"),
                  typeOfFontWieght: 1,
                ),
              );
            });
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 403) {
        Navigator.of(context).popUntil((route) => route.isFirst);

        setState(() {
          erro403.error403(context, response.statusCode);
          _isLoading = false;
        });
      } else {
        setState(() {
          homeServerError.serverError(context, response.statusCode);
          _isLoading = false;
        });
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _getDraweItem();
  }

  @override
  void dispose() {
    super.dispose();

    clientApi.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final navigatonBarScreen = Provider.of<NavigationBarScreen>(context);
    return NetworkIndicator(
      child: Drawer(
        width: MediaQuery.of(context).size.width / 1.25, //300
        backgroundColor:
            themeProvider.isDarkMode ? containerdarkColor : whiteColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(context, themeProvider),
              _isLoading
                  ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 81.2,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 18.75,
                              vertical:
                                  MediaQuery.of(context).size.height / 81.2),
                          child: ShimmerWidget.circular(
                            hight: MediaQuery.of(context).size.height /
                                18.04444444444444, //45
                            width: MediaQuery.of(context).size.width,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height / 81.2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 18.75,
                              vertical:
                                  MediaQuery.of(context).size.height / 81.2),
                          child: ShimmerWidget.circular(
                            hight: MediaQuery.of(context).size.height /
                                18.04444444444444, //45
                            width: MediaQuery.of(context).size.width,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height / 81.2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 18.75,
                              vertical:
                                  MediaQuery.of(context).size.height / 81.2),
                          child: ShimmerWidget.circular(
                            hight: MediaQuery.of(context).size.height /
                                18.04444444444444, //45
                            width: MediaQuery.of(context).size.width,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height / 81.2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 18.75,
                              vertical:
                                  MediaQuery.of(context).size.height / 81.2),
                          child: ShimmerWidget.circular(
                            hight: MediaQuery.of(context).size.height /
                                18.04444444444444, //45
                            width: MediaQuery.of(context).size.width,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height / 81.2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 18.75,
                              vertical:
                                  MediaQuery.of(context).size.height / 81.2),
                          child: ShimmerWidget.circular(
                            hight: MediaQuery.of(context).size.height /
                                18.04444444444444, //45
                            width: MediaQuery.of(context).size.width,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height / 81.2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 18.75,
                              vertical:
                                  MediaQuery.of(context).size.height / 81.2),
                          child: ShimmerWidget.circular(
                            hight: MediaQuery.of(context).size.height /
                                18.04444444444444, //45
                            width: MediaQuery.of(context).size.width,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height / 81.2),
                            ),
                          ),
                        ),
                      ],
                    )
                  : buildMenuItems(context, themeProvider, navigatonBarScreen)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, ThemeProvider themeProvider) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5.6, //145
      color: mainAppColor,

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: [
            ClipOval(
              child: CircleAvatar(
                backgroundColor:
                    themeProvider.isDarkMode ? containerdarkColor : whiteColor,
                radius: MediaQuery.of(context).size.height / 32.48, // 25
                child: FullScreenWidget(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16.24, //50
                    width: MediaQuery.of(context).size.width / 7.5, //50
                    child: Image.asset("assets/images/userphotoright.png"),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 28.84615384615385, //13
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmallText(
                    text: "مرحبا بك احمد",
                    size: 16,
                    typeOfFontWieght: 1,
                    color: blackColor,
                  ),
                  SmallText(
                    text: "المدير",
                    size: 14,
                    color: blackColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  buildMenuItems(BuildContext context, ThemeProvider themeProvider,
      NavigationBarScreen navigatonBarScreen) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 40.6, //20
        ),
        _drawerItem.contains("show statuses reports")
            ? drawerItem(
                themeProvider, "control_panel", "assets/images/dash.png",
                MediaQuery.of(context).size.width / 20.83333333333333, //18
                () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  navigatonBarScreen.updateNavigationIndex(3);
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show orders")
            ? drawerItem(
                themeProvider, "Orders", "assets/images/orders.png",
                MediaQuery.of(context).size.width / 20.83333333333333, //18
                () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  navigatonBarScreen.updateNavigationIndex(2);
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show sources reports")
            ? drawerItem(
                themeProvider,
                "follwing source",
                "assets/images/resources.png",
                MediaQuery.of(context).size.width / 20.83333333333333, //18
                () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  navigatonBarScreen.updateNavigationIndex(1);
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show moderators reports")
            ? drawerItem(
                themeProvider,
                "follwing performance",
                "assets/images/activity.png",
                MediaQuery.of(context).size.width / 20.83333333333333, //18
                () {
                  // FollwingPerformanceScreen
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FollwingPerformanceScreen(),
                    ),
                  );
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show moderators reports") ||
                _drawerItem.contains("show sources reports") ||
                _drawerItem.contains("show orders") ||
                _drawerItem.contains("show statuses reports")
            ? Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40.6,
                  ),
                  Divider(
                    height: 0,
                    color: themeProvider.isDarkMode
                        ? dividerDarkColor
                        : containerColor,
                    endIndent: MediaQuery.of(context).size.width /
                        20.83333333333333, //18
                    indent: MediaQuery.of(context).size.width /
                        20.83333333333333, //18
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40.6,
                  ),
                ],
              )
            : Container(),

        ///

        _drawerItem.contains("show services")
            ? drawerItem(
                themeProvider,
                "services",
                "assets/images/services.png",
                MediaQuery.of(context).size.width / 15.625, //24
                () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => EditNavigationBar()),
                    (route) => false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServicesScreen(),
                  ),
                );
              }, 1, false)
            : Container(),
        _drawerItem.contains("show categories")
            ? drawerItem(
                themeProvider,
                "categories",
                "assets/images/categories.png",
                MediaQuery.of(context).size.width / 15.625, //24
                () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => EditNavigationBar()),
                    (route) => false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(),
                  ),
                );
              }, 1, false)
            : Container(),
        _drawerItem.contains("show offers")
            ? drawerItem(themeProvider, "offers", "assets/images/offers.png",
                MediaQuery.of(context).size.width / 15.625, //24
                () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => EditNavigationBar()),
                    (route) => false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OffersScreen(),
                  ),
                );
              }, 1, false)
            : Container(),
        _drawerItem.contains("show doctors")
            ? drawerItem(
                themeProvider,
                "team work",
                "assets/images/teamworkdark.png",
                MediaQuery.of(context).size.width / 15.625,
                () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TeamWorkScreen(),
                    ),
                  );
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show customers")
            ? drawerItem(
                themeProvider,
                "mangment clients",
                "assets/images/mangmentclients.png",
                MediaQuery.of(context).size.width / 15.625, //24
                () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerManagementScreen(),
                    ),
                  );
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show sources")
            ? drawerItem(
                themeProvider, "sources", "assets/images/sources.png",
                MediaQuery.of(context).size.width / 15.625, //24
                () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SourcesScreen(),
                    ),
                  );
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show branches")
            ? drawerItem(
                themeProvider, "branches", "assets/images/branches.png",
                MediaQuery.of(context).size.width / 15.625, //24
                () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BrancheScreen(),
                    ),
                  );
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show testimonials")
            ? drawerItem(
                themeProvider,
                "Customer Reviews",
                "assets/images/testmonials.png",
                MediaQuery.of(context).size.width / 15.625, //24
                () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => customerReviewsScreen(),
                    ),
                  );
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show projects")
            ? drawerItem(
                themeProvider,
                "projects",
                "assets/images/projects.png",
                MediaQuery.of(context).size.width / 15.625, //24
                () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProjectScreen(),
                    ),
                  );
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show tidings")
            ? drawerItem(
                themeProvider, "news", "assets/images/news.png",
                MediaQuery.of(context).size.width / 15.625, //24
                () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsScreen(),
                    ),
                  );
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show blogs")
            ? drawerItem(
                themeProvider, "blog", "assets/images/blog.png",
                MediaQuery.of(context).size.width / 15.625, //24
                () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlogScreen(),
                    ),
                  );
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show blogs") ||
                _drawerItem.contains("show tidings") ||
                _drawerItem.contains("show projects") ||
                _drawerItem.contains("show testimonials") ||
                _drawerItem.contains("show branches") ||
                _drawerItem.contains("show sources") ||
                _drawerItem.contains("show customers") ||
                _drawerItem.contains("show doctors") ||
                _drawerItem.contains("show offers") ||
                _drawerItem.contains("show categories") ||
                _drawerItem.contains("show services")
            ? Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40.6,
                  ),
                  Divider(
                    height: 0,
                    color: themeProvider.isDarkMode
                        ? dividerDarkColor
                        : containerColor,
                    endIndent: MediaQuery.of(context).size.width /
                        20.83333333333333, //18
                    indent: MediaQuery.of(context).size.width /
                        20.83333333333333, //18
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40.6,
                  ),
                ],
              )
            : Container(),

        _drawerItem.contains("show roles")
            ? drawerItem(
                themeProvider,
                "roles and perimessions",
                "assets/images/rolesandperimessions.png",
                MediaQuery.of(context).size.width / 15.625,
                () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RolesAndPermissionScreen()));
                },
                1,
                false,
              )
            : Container(),
        _drawerItem.contains("show profiles")
            ? drawerItem(
                themeProvider,
                "employee management",
                "assets/images/mangementworkers.png",
                MediaQuery.of(context).size.width / 15.625, //24
                () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => EditNavigationBar()),
                      (route) => false);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EmployeeMangementScreen()));
                },
                1,
                false,
              )
            : Container(),
        drawerItem(themeProvider, "Settings", "assets/images/settings.png",
            MediaQuery.of(context).size.width / 15.625, //24
            () {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => EditNavigationBar()),
              (route) => false);
          navigatonBarScreen.updateNavigationIndex(0);
        }, 1, false
            // UserData.getDraweCurrentPage() == "EditPage" ? true : false,
            ),
        drawerItem(themeProvider, "logout", "assets/images/logout.png",
            MediaQuery.of(context).size.width / 15.625, //24
            () {
          logout();
        }, 0, false),
        SizedBox(
          height: MediaQuery.of(context).size.height / 54.13333333333333, //15
        )
      ],
    );
  }

  Widget drawerItem(
    ThemeProvider themeProvider,
    String key,
    String imageUrl,
    double horizontalMargin,
    VoidCallback onTap,
    int redColor,
    bool isPageSelected,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        child: Padding(
          padding: EdgeInsets.only(
            left: horizontalMargin,
            right: horizontalMargin,
          ),
          child: Row(
            children: [
              Image.asset(imageUrl),
              SizedBox(width: MediaQuery.of(context).size.width / 37.5), //10
              SmallText(
                text: AppLocalizations.of(context)!.translate(key),
                size: MediaQuery.of(context).size.height / 50.75, //16
                color: redColor == 0
                    ? Color(0xffFB3241)
                    : themeProvider.isDarkMode
                        ? whiteColor
                        : blackColor,
                typeOfFontWieght: 0,
              ),
              Visibility(
                visible: isPageSelected,
                child: Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Image.asset("assets/images/check.png")],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  logout() async {
    try {
      final unauthorizedError =
          Provider.of<UnauthorizedError>(context, listen: false);

      final erro403 = Provider.of<Error403>(context, listen: false);

      final serverError = Provider.of<HomeServerError>(context, listen: false);

      setState(() {
        _isLoading = true;
      });

      final response = await post(
        Uri.parse("${Urls.LOG_OUT_URL_}"),
        headers: <String, String>{
          'Accept': 'application/json',
          "Accept-Language": UserData.getUSerLang(),
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        },
      );
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => logInScreen()),
            (route) => false);
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: successOperation(operationName: "log out successfuly"),
              );
            });
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        unauthorizedError.unauthorizedErrors401(context);
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 422) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: mainAppColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                title: BigText(
                  color: blackColor,
                  text: 'User id is undefine',
                  typeOfFontWieght: 1,
                ),
              );
            });
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 403) {
        setState(() {
          erro403.error403(context, response.statusCode);
          _isLoading = false;
        });
      } else {
        setState(() {
          serverError.serverError(context, response.statusCode);
          _isLoading = false;
        });
      }
    } catch (e) {}
  }
}
