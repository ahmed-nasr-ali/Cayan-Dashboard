// ignore_for_file: prefer_const_constructors, prefer_final_fields, non_constant_identifier_names, prefer_const_declarations, unused_field, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, use_build_context_synchronously, unnecessary_string_interpolations, unused_element, unnecessary_brace_in_string_interps, sized_box_for_whitespace, prefer_adjacent_string_concatenation

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/safe_area/page_container.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer%20list%20view/shimmer_list_view.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/control%20panel/control_panel.dart';
import 'package:cayan/shared_preferences/follow%20source%20data/follow_source_data.dart';
import 'package:cayan/shared_preferences/follow_prefrmance/follow_prefromance_data.dart';
import 'package:cayan/shared_preferences/order%20user%20data/order_user_data.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Orders/order%20date%20filteration%20bottom%20sheet/order_date_filteration_bottom_sheet.dart';
import 'package:cayan/ui/drawer/navigation_drawer.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ControlPanelScreen extends StatefulWidget {
  const ControlPanelScreen({Key? key}) : super(key: key);

  @override
  State<ControlPanelScreen> createState() => _ControlPanelScreenState();
}

class _ControlPanelScreenState extends State<ControlPanelScreen> {
  http.Client clientApi = http.Client();

  late FocusNode _searchFocusNode;
  String searchContent = '';

  final TextEditingController searchController = TextEditingController();

  bool _isSearchLoading = false;
  List<dynamic> _rateallUsers = [];
  List<dynamic> _allUsers = [];
  List<dynamic> _dateallUsers = [];

  List<dynamic> _searchedResult = [];
  List<dynamic> _datesearchedResult = [];
  List _drawerItem = [];

  bool _isLoading = false;
  bool drawerLoading = false;

  bool _isDate = false;
  bool _isRate = false;

  int totalNumber = 0;

  ///(عشان اعرف هل المستخدم له صلاحيه يشوف الصفحه دي ولا لا)
  void _getDraweItem() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    setState(() {
      drawerLoading = true;
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

        ///(method _getalluser لو ليا صلحيه اشوف الصفحه هجيب)
        _drawerItem.contains("show statuses reports") ? _getAllUsers() : null;
        _drawerItem.contains("show statuses reports")
            ? _getRateAllUsers()
            : null;
      });
    } else if (response.statusCode == 401) {
      unauthorizedError.unauthorizedErrors401(context);
      setState(() {
        drawerLoading = false;
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
        drawerLoading = false;
      });
    } else if (response.statusCode == 403) {
      Navigator.of(context).popUntil((route) => route.isFirst);

      setState(() {
        erro403.error403(context, response.statusCode);
        drawerLoading = false;
      });
    } else {
      setState(() {
        homeServerError.serverError(context, response.statusCode);
        drawerLoading = false;
      });
    }
    setState(() {
      drawerLoading = false;
    });
  }

  void _getAllUsers() async {
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
          "${Urls.GET_STATUS_URL}",
        ),
        headers: <String, String>{
          'Accept': 'application/json',
          "Accept-Language": UserData.getUSerLang(),
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        });
    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);

        _allUsers = map["data"];

        totalNumber = _allUsers[0]["orders_count"] +
            _allUsers[1]["orders_count"] +
            _allUsers[2]["orders_count"] +
            _allUsers[3]["orders_count"];

        _allUsers.insert(0, {
          "id": 0,
          "name": AppLocalizations.of(context)!.translate("all"),
          "orders_count": totalNumber
        });
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
  }

  void _getRateAllUsers() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    setState(() {
      _isRate = true;
    });
    final response = await clientApi.get(
        Uri.parse(
          "${Urls.GET_STATUS_URL}",
        ),
        headers: <String, String>{
          'Accept': 'application/json',
          "Accept-Language": UserData.getUSerLang(),
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        });
    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);

        _rateallUsers = map["data"];
      });
    } else if (response.statusCode == 401) {
      unauthorizedError.unauthorizedErrors401(context);
      setState(() {
        _isRate = false;
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
        _isRate = false;
      });
    } else if (response.statusCode == 403) {
      Navigator.of(context).popUntil((route) => route.isFirst);

      setState(() {
        erro403.error403(context, response.statusCode);
        _isRate = false;
      });
    } else {
      setState(() {
        homeServerError.serverError(context, response.statusCode);
        _isRate = false;
      });
    }
    setState(() {
      _isRate = false;
    });
  }

  void _getDateAllUsers() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    setState(() {
      _isDate = true;
    });
    final response = await clientApi.get(
        Uri.parse(
          "${Urls.GET_STATUS_URL}?start_date=${ControlPanleUserData.getControlPanelHistoryFromSearch()}&end_date=${ControlPanleUserData.getControlPanelHistoryToSearch()}",
        ),
        headers: <String, String>{
          'Accept': 'application/json',
          "Accept-Language": UserData.getUSerLang(),
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        });
    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);

        _dateallUsers = map["data"];
      });
    } else if (response.statusCode == 401) {
      unauthorizedError.unauthorizedErrors401(context);
      setState(() {
        _isDate = false;
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
        _isDate = false;
      });
    } else if (response.statusCode == 403) {
      Navigator.of(context).popUntil((route) => route.isFirst);

      setState(() {
        erro403.error403(context, response.statusCode);
        _isDate = false;
      });
    } else {
      setState(() {
        homeServerError.serverError(context, response.statusCode);
        _isDate = false;
      });
    }
    setState(() {
      _isDate = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _getDraweItem();

    ControlPanleUserData.getControlPanelHistoryFromSearch() == "" &&
            ControlPanleUserData.getControlPanelHistoryToSearch() == ""
        ? ""
        : _getDateAllUsers();

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

    FollowPrefUserData.setFollowPrefHistoryFromSearch(
        ""); //(عشان الفلتر بتاع متابعة الاداء)
    FollowPrefUserData.setFollowprefHistoryToSearch(
        ""); //(عشان الفلتر بتاع متابعة الاداء)
    FollowPrefUserData.setFollowprefDaySearch(
        ""); //(عشان الفلتر بتاع متابعة الاداء)
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocusNode.dispose();

    clientApi.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return NetworkIndicator(
      child: PageContainer(
        child: Scaffold(
          backgroundColor: themeProvider.isDarkMode ? blackColor : cardColor,
          appBar: AppBar(
            backgroundColor:
                themeProvider.isDarkMode ? containerdarkColor : whiteColor,
            elevation: 0,
            centerTitle: true,
            title: BigText(
              typeOfFontWieght: 1,
              text: AppLocalizations.of(context)!.translate("control_panel"),
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
          body: _isDate || _isLoading || _isRate || drawerLoading
              ? ShimmerListView(
                  hight: MediaQuery.of(context).size.height / 7.25, //112
                )
              : _drawerItem.contains("show statuses reports")
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchFocusNode.unfocus();
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height /
                                10.82666666666667, //75
                            width: MediaQuery.of(context).size.width,
                            color: themeProvider.isDarkMode
                                ? containerdarkColor
                                : whiteColor,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height /
                                      162.4), //5
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        25, //15
                                  ),
                                  Expanded(
                                    child: SearchingBar(themeProvider, context),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        37.5, //10
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          ///for showing
                                          ControlPanleUserData
                                              .setControlPanelDayShowing("");
                                          ControlPanleUserData
                                              .setControlPanelHistoryFromShowing(
                                                  "");

                                          ControlPanleUserData
                                              .setControlPanelHistoryToShowing(
                                                  "");

                                          ///for get data
                                          ControlPanleUserData
                                              .setControlPanelHistoryFromSearch(
                                                  "");
                                          ControlPanleUserData
                                              .setControlPanelHistoryToSearch(
                                                  "");
                                          FollowSourceUserData
                                              .setFollowSourceDaySearch("");
                                        });
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child:
                                                    OrderDateFilterationBottomSheet(
                                                  pageName: "control_panel",
                                                ),
                                              );
                                            }).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                              "assets/images/yellowcontaner.png"),
                                          Image.asset(
                                              "assets/images/calendar.png")
                                        ],
                                      )),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        25, //15
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              // physics: NeverScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width /
                                            27.06666666666667, //30
                                  ),
                                  child: SmallText(
                                    typeOfFontWieght: 1,
                                    size:
                                        MediaQuery.of(context).size.height / 58,
                                    color: themeProvider.isDarkMode
                                        ? whiteColor
                                        : blackColor,
                                    align: TextAlign.start,
                                    text: AppLocalizations.of(context)!
                                        .translate("General Statistics"),
                                  ),
                                ),
                                _isSearchLoading
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 50),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: mainAppColor,
                                          ),
                                        ),
                                      )
                                    : buildList(themeProvider),
                                // SizedBox(
                                //   height:
                                //       MediaQuery.of(context).size.height / 50.75, //16
                                // ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width /
                                            27.06666666666667, //30
                                  ),
                                  child: SmallText(
                                    typeOfFontWieght: 1,
                                    size:
                                        MediaQuery.of(context).size.height / 58,
                                    color: themeProvider.isDarkMode
                                        ? whiteColor
                                        : blackColor,
                                    align: TextAlign.start,
                                    text: AppLocalizations.of(context)!
                                        .translate("Rates"),
                                  ),
                                ),
                                _isSearchLoading
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 50),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: mainAppColor,
                                          ),
                                        ),
                                      )
                                    : buildRatesList(themeProvider),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: SmallText(
                        text: AppLocalizations.of(context)!.translate(
                          "you do not have a perimission to do this operation",
                        ),
                        color: mainAppColor,
                        size: MediaQuery.of(context).size.height / 50.75,
                        typeOfFontWieght: 1,
                      ),
                    ),
        ),
      ),
    );
  }

  Widget buildList(ThemeProvider themeProvider) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio:
              (MediaQuery.of(context).size.width / 2.286585365853659) /
                  (MediaQuery.of(context).size.height /
                      4.511111111111111), //169/195
          crossAxisCount: 2,
          crossAxisSpacing: MediaQuery.of(context).size.width / 30, //15
          mainAxisSpacing: MediaQuery.of(context).size.height / 64.96, //15
        ),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 30,
            vertical: MediaQuery.of(context).size.height / 64.96), //15
        itemCount: searchController.text.isEmpty
            ? (ControlPanleUserData.getControlPanelHistoryFromSearch() == ""
                ? _allUsers.length
                : _dateallUsers.length)
            : (ControlPanleUserData.getControlPanelHistoryFromSearch() == ""
                ? _searchedResult.length
                : _datesearchedResult.length),
        itemBuilder: (contex, index) {
          return gridViewBody(index, themeProvider);
        });
  }

  Widget buildRatesList(ThemeProvider themeProvider) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio:
              (MediaQuery.of(context).size.width / 2.286585365853659) /
                  (MediaQuery.of(context).size.height / 4.06), //169/200
          crossAxisCount: 2,
          crossAxisSpacing: MediaQuery.of(context).size.width / 30, //15
          mainAxisSpacing: MediaQuery.of(context).size.height / 64.96, //15
        ),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 30,
            vertical: MediaQuery.of(context).size.height / 64.96), //15
        itemCount: searchController.text.isEmpty
            ? (ControlPanleUserData.getControlPanelHistoryFromSearch() == ""
                ? _rateallUsers.length
                : _dateallUsers.length)
            : (ControlPanleUserData.getControlPanelHistoryFromSearch() == ""
                ? _searchedResult.length
                : _datesearchedResult.length),
        itemBuilder: (contex, index) {
          return rategridViewBody(index, themeProvider);
        });
  }

  Widget gridViewBody(int index, ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.height / 81.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 40.6, //16
          ),
          Container(
            width: MediaQuery.of(context).size.height / 9.783132530120482, //83
            height: MediaQuery.of(context).size.height / 9.783132530120482, //83
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: searchController.text.isEmpty
                      ? (ControlPanleUserData
                                  .getControlPanelHistoryFromSearch() ==
                              ""
                          ? (_allUsers[index]["orders_count"] / totalNumber)
                          : (_dateallUsers[index]["orders_count"] /
                              totalNumber))
                      : (ControlPanleUserData
                                  .getControlPanelHistoryFromSearch() ==
                              ""
                          ? (_searchedResult[index]["orders_count"] /
                              totalNumber)
                          : (_datesearchedResult[index]["orders_count"] /
                              totalNumber)),
                  valueColor: AlwaysStoppedAnimation(
                    searchController.text.isEmpty
                        ? (ControlPanleUserData
                                    .getControlPanelHistoryFromSearch() ==
                                ""
                            ? (_allUsers[index]["id"] == 0
                                ? mainAppColor
                                : _allUsers[index]["id"] == 1
                                    ? blueColor
                                    : _allUsers[index]["id"] == 2
                                        ? orangeColor
                                        : _allUsers[index]["id"] == 3
                                            ? greenColor
                                            : redColor)
                            : (_dateallUsers[index]["id"] == 0
                                ? mainAppColor
                                : _dateallUsers[index]["id"] == 1
                                    ? blueColor
                                    : _dateallUsers[index]["id"] == 2
                                        ? orangeColor
                                        : _dateallUsers[index]["id"] == 3
                                            ? greenColor
                                            : redColor))
                        : ControlPanleUserData
                                    .getControlPanelHistoryFromSearch() ==
                                ""
                            ? (_searchedResult[index]["id"] == 0
                                ? mainAppColor
                                : _searchedResult[index]["id"] == 1
                                    ? blueColor
                                    : _searchedResult[index]["id"] == 2
                                        ? orangeColor
                                        : _searchedResult[index]["id"] == 3
                                            ? greenColor
                                            : redColor)
                            : (_datesearchedResult[index]["id"] == 0
                                ? mainAppColor
                                : _datesearchedResult[index]["id"] == 1
                                    ? blueColor
                                    : _datesearchedResult[index]["id"] == 2
                                        ? orangeColor
                                        : _datesearchedResult[index]["id"] == 3
                                            ? greenColor
                                            : redColor),
                  ),
                  strokeWidth: MediaQuery.of(context).size.width / 37.5,
                  backgroundColor: containerColor,
                ),
                Center(
                  child: SmallText(
                    size: MediaQuery.of(context).size.height /
                        54.13333333333333, //54
                    color: themeProvider.isDarkMode ? whiteColor : blackColor,
                    typeOfFontWieght: 1,
                    text: searchController.text.isEmpty
                        ? ((ControlPanleUserData
                                        .getControlPanelHistoryFromSearch() ==
                                    ""
                                ? ((_allUsers[index]["orders_count"] /
                                            totalNumber) *
                                        100)
                                    .toStringAsFixed(0)
                                : ((_dateallUsers[index]["orders_count"] /
                                            totalNumber) *
                                        100)
                                    .toStringAsFixed(0))) +
                            "%"
                        : ControlPanleUserData
                                    .getControlPanelHistoryFromSearch() ==
                                ""
                            ? ((_searchedResult[index]["orders_count"] /
                                        totalNumber) *
                                    100)
                                .toStringAsFixed(0)
                            : ((_datesearchedResult[index]["orders_count"] /
                                        totalNumber) *
                                    100)
                                .toStringAsFixed(0),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 81.2, //5
          ),
          SmallText(
            size: MediaQuery.of(context).size.height / 58, //14,
            color: themeProvider.isDarkMode ? whiteColor : blackColor,
            text: searchController.text.isEmpty
                ? (ControlPanleUserData.getControlPanelHistoryFromSearch() == ""
                    ? _allUsers[index]["name"]
                    : _dateallUsers[index]["name"])
                : ControlPanleUserData.getControlPanelHistoryFromSearch() == ""
                    ? _searchedResult[index]["name"]
                    : _datesearchedResult[index]["name"],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 81.2, //5
          ),
          SmallText(
              typeOfFontWieght: 1,
              size: MediaQuery.of(context).size.height / 58, //14,
              color: themeProvider.isDarkMode ? whiteColor : blackColor,
              text: searchController.text.isEmpty
                  ? (ControlPanleUserData.getControlPanelHistoryFromSearch() ==
                          ""
                      ? _allUsers[index]["orders_count"].toString()
                      : _dateallUsers[index]["orders_count"].toString())
                  : ControlPanleUserData.getControlPanelHistoryFromSearch() ==
                          ""
                      ? _searchedResult[index]["orders_count"].toString()
                      : _datesearchedResult[index]["orders_count"].toString()),
        ],
      ),
    );
  }

  Widget rategridViewBody(int index, ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.height / 81.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 40.6, //16
          ),
          Container(
            width: MediaQuery.of(context).size.height / 9.783132530120482, //83
            height: MediaQuery.of(context).size.height / 9.783132530120482, //83
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: searchController.text.isEmpty
                      ? (ControlPanleUserData
                                  .getControlPanelHistoryFromSearch() ==
                              ""
                          ? (_rateallUsers[index]["orders_count"] / totalNumber)
                          : (_dateallUsers[index]["orders_count"] /
                              totalNumber))
                      : (ControlPanleUserData
                                  .getControlPanelHistoryFromSearch() ==
                              ""
                          ? (_searchedResult[index]["orders_count"] /
                              totalNumber)
                          : (_datesearchedResult[index]["orders_count"] /
                              totalNumber)),
                  valueColor: AlwaysStoppedAnimation(
                    searchController.text.isEmpty
                        ? (ControlPanleUserData
                                    .getControlPanelHistoryFromSearch() ==
                                ""
                            ? (_rateallUsers[index]["id"] == 1
                                ? blueColor
                                : _rateallUsers[index]["id"] == 2
                                    ? orangeColor
                                    : _rateallUsers[index]["id"] == 3
                                        ? greenColor
                                        : _rateallUsers[index]["id"] == 4
                                            ? redColor
                                            : mainAppColor)
                            : (_dateallUsers[index]["id"] == 1
                                ? blueColor
                                : _dateallUsers[index]["id"] == 2
                                    ? orangeColor
                                    : _dateallUsers[index]["id"] == 3
                                        ? greenColor
                                        : _dateallUsers[index]["id"] == 4
                                            ? redColor
                                            : mainAppColor))
                        : ControlPanleUserData
                                    .getControlPanelHistoryFromSearch() ==
                                ""
                            ? (_searchedResult[index]["id"] == 1
                                ? blueColor
                                : _searchedResult[index]["id"] == 2
                                    ? orangeColor
                                    : _searchedResult[index]["id"] == 3
                                        ? greenColor
                                        : _searchedResult[index]["id"] == 4
                                            ? redColor
                                            : mainAppColor)
                            : (_datesearchedResult[index]["id"] == 1
                                ? blueColor
                                : _datesearchedResult[index]["id"] == 2
                                    ? orangeColor
                                    : _datesearchedResult[index]["id"] == 3
                                        ? greenColor
                                        : _datesearchedResult[index]["id"] == 4
                                            ? redColor
                                            : mainAppColor),
                  ),
                  strokeWidth: MediaQuery.of(context).size.width / 37.5,
                  backgroundColor: containerColor,
                ),
                Center(
                  child: SmallText(
                    size: MediaQuery.of(context).size.height /
                        54.13333333333333, //54
                    color: themeProvider.isDarkMode ? whiteColor : blackColor,
                    typeOfFontWieght: 1,
                    text: searchController.text.isEmpty
                        ? ((ControlPanleUserData
                                        .getControlPanelHistoryFromSearch() ==
                                    ""
                                ? ((_rateallUsers[index]["orders_count"] /
                                            totalNumber) *
                                        100)
                                    .toStringAsFixed(0)
                                : ((_dateallUsers[index]["orders_count"] /
                                            totalNumber) *
                                        100)
                                    .toStringAsFixed(0))) +
                            "%"
                        : ControlPanleUserData
                                    .getControlPanelHistoryFromSearch() ==
                                ""
                            ? ((_searchedResult[index]["orders_count"] /
                                        totalNumber) *
                                    100)
                                .toStringAsFixed(0)
                            : ((_datesearchedResult[index]["orders_count"] /
                                        totalNumber) *
                                    100)
                                .toStringAsFixed(0),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 81.2, //5
          ),
          SmallText(
            size: MediaQuery.of(context).size.height / 58, //14,
            color: themeProvider.isDarkMode ? whiteColor : blackColor,
            text: searchController.text.isEmpty
                ? (ControlPanleUserData.getControlPanelHistoryFromSearch() == ""
                    ? _rateallUsers[index]["name"]
                    : _dateallUsers[index]["name"])
                : ControlPanleUserData.getControlPanelHistoryFromSearch() == ""
                    ? _searchedResult[index]["name"]
                    : _datesearchedResult[index]["name"],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 54.13333333333333, //15
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 25, //15
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 6.25,
                  height: MediaQuery.of(context).size.height / 32.48,
                  decoration: BoxDecoration(
                    color: searchController.text.isEmpty
                        ? ControlPanleUserData
                                    .getControlPanelHistoryFromSearch() ==
                                ""
                            ? (_rateallUsers[index]["id"] == 1
                                ? blueColor.withOpacity(0.1)
                                : _rateallUsers[index]["id"] == 2
                                    ? orangeColor.withOpacity(0.1)
                                    : _rateallUsers[index]["id"] == 3
                                        ? greenColor.withOpacity(0.1)
                                        : redColor.withOpacity(0.1))
                            : (_dateallUsers[index]["id"] == 1
                                ? blueColor.withOpacity(0.1)
                                : _dateallUsers[index]["id"] == 2
                                    ? orangeColor.withOpacity(0.1)
                                    : _dateallUsers[index]["id"] == 3
                                        ? greenColor.withOpacity(0.1)
                                        : redColor.withOpacity(0.1))
                        : ControlPanleUserData
                                    .getControlPanelHistoryFromSearch() ==
                                ""
                            ? (_searchedResult[index]["id"] == 1
                                ? blueColor.withOpacity(0.1)
                                : _searchedResult[index]["id"] == 2
                                    ? orangeColor.withOpacity(0.1)
                                    : _searchedResult[index]["id"] == 3
                                        ? greenColor.withOpacity(0.1)
                                        : redColor.withOpacity(0.1))
                            : (_datesearchedResult[index]["id"] == 1
                                ? blueColor.withOpacity(0.1)
                                : _datesearchedResult[index]["id"] == 2
                                    ? orangeColor.withOpacity(0.1)
                                    : _datesearchedResult[index]["id"] == 3
                                        ? greenColor.withOpacity(0.1)
                                        : redColor.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height / 81.2),
                  ),
                  child: Center(
                    child: SmallText(
                      align: TextAlign.center,
                      text: searchController.text.isEmpty
                          ? ControlPanleUserData
                                      .getControlPanelHistoryFromSearch() ==
                                  ""
                              ? (_rateallUsers[index]["orders_count"]
                                  .toString())
                              : (_dateallUsers[index]["orders_count"]
                                  .toString())
                          : ControlPanleUserData
                                      .getControlPanelHistoryFromSearch() ==
                                  ""
                              ? (_searchedResult[index]["orders_count"]
                                  .toString())
                              : (_datesearchedResult[index]["orders_count"]
                                  .toString()),
                      color: searchController.text.isEmpty
                          ? ControlPanleUserData
                                      .getControlPanelHistoryFromSearch() ==
                                  ""
                              ? (_rateallUsers[index]["id"] == 1
                                  ? blueColor
                                  : _rateallUsers[index]["id"] == 2
                                      ? orangeColor
                                      : _rateallUsers[index]["id"] == 3
                                          ? greenColor
                                          : redColor)
                              : (_dateallUsers[index]["id"] == 1
                                  ? blueColor
                                  : _dateallUsers[index]["id"] == 2
                                      ? orangeColor
                                      : _dateallUsers[index]["id"] == 3
                                          ? greenColor
                                          : redColor)
                          : ControlPanleUserData
                                      .getControlPanelHistoryFromSearch() ==
                                  ""
                              ? (_searchedResult[index]["id"] == 1
                                  ? blueColor
                                  : _searchedResult[index]["id"] == 2
                                      ? orangeColor
                                      : _searchedResult[index]["id"] == 3
                                          ? greenColor
                                          : redColor)
                              : (_datesearchedResult[index]["id"] == 1
                                  ? blueColor
                                  : _datesearchedResult[index]["id"] == 2
                                      ? orangeColor
                                      : _datesearchedResult[index]["id"] == 3
                                          ? greenColor
                                          : redColor),
                      size: MediaQuery.of(context).size.height /
                          67.66666666666667,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 75,
                  height: MediaQuery.of(context).size.height /
                      MediaQuery.of(context).size.height,
                  color: textGrayColor,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 6.25,
                  height: MediaQuery.of(context).size.height / 32.48,
                  decoration: BoxDecoration(
                    color:
                        themeProvider.isDarkMode ? dividerDarkColor : cardColor,
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height / 81.2),
                  ),
                  child: Center(
                    child: SmallText(
                      align: TextAlign.center,
                      text: totalNumber.toString(),
                      color: textGrayColor,
                      size: MediaQuery.of(context).size.height /
                          67.66666666666667,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget SearchingBar(themeProvider, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? blackColor : SearchingBarlightColor,
        borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.height / 81.2), //15
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 37.5, //10
          ),
          Image.asset("assets/images/search.png"),
          Expanded(
            child: TextField(
              focusNode: _searchFocusNode,
              textAlign: TextAlign.start,
              controller: searchController,
              cursorColor: themeProvider.isDarkMode ? whiteColor : blackColor,
              style: TextStyle(
                  color: themeProvider.isDarkMode ? whiteColor : blackColor),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 37.5,
                ),
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText:
                    AppLocalizations.of(context)!.translate("search") + ' ..',
                hintStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 64.33, //12
                  fontWeight: FontWeight.normal,
                  color:
                      themeProvider.isDarkMode ? textGrayColor : textGrayColor,
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    searchController.clear();
                    _datesearchedResult.clear();
                    _searchedResult.clear();
                  });
                } else if (value.isNotEmpty) {
                  setState(() {
                    searchContent = value;
                    // searchPage = 1;

                    ControlPanleUserData.getControlPanelHistoryFromSearch() ==
                            ""
                        ? searchUserApicall(value)
                        : datesearchUserApicall(value);
                  });
                }
              },
              onTap: () {
                setState(() {
                  _searchFocusNode.hasFocus == true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  searchUserApicall(String value) async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    setState(() {
      _isSearchLoading = true;
    });

    final response = await clientApi.get(
        Uri.parse(
          "${Urls.GET_STATUS_URL}?name=${value}",
        ),
        headers: <String, String>{
          'Accept': 'application/json',
          "Accept-Language": UserData.getUSerLang(),
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        });

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);

        _searchedResult = map["data"];
      });
    } else if (response.statusCode == 401) {
      unauthorizedError.unauthorizedErrors401(context);
      setState(() {
        _isSearchLoading = false;
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
        _isSearchLoading = false;
      });
    } else if (response.statusCode == 403) {
      Navigator.of(context).popUntil((route) => route.isFirst);

      setState(() {
        erro403.error403(context, response.statusCode);
        _isSearchLoading = false;
      });
    } else {
      setState(() {
        homeServerError.serverError(context, response.statusCode);
        _isSearchLoading = false;
      });
    }
    setState(() {
      _isSearchLoading = false;
    });
  }

  datesearchUserApicall(String value) async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    setState(() {
      _isSearchLoading = true;
    });

    final response = await http.get(
        Uri.parse(
          "${Urls.GET_STATUS_URL}?start_date=${ControlPanleUserData.getControlPanelHistoryFromSearch()}&end_date=${ControlPanleUserData.getControlPanelHistoryToSearch()}&name=${value}",
        ),
        headers: <String, String>{
          'Accept': 'application/json',
          "Accept-Language": UserData.getUSerLang(),
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        });

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);

        _datesearchedResult = map["data"];
      });
    } else if (response.statusCode == 401) {
      unauthorizedError.unauthorizedErrors401(context);
      setState(() {
        _isSearchLoading = false;
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
        _isSearchLoading = false;
      });
    } else if (response.statusCode == 403) {
      Navigator.of(context).popUntil((route) => route.isFirst);

      setState(() {
        erro403.error403(context, response.statusCode);
        _isSearchLoading = false;
      });
    } else {
      setState(() {
        homeServerError.serverError(context, response.statusCode);
        _isSearchLoading = false;
      });
    }
    setState(() {
      _isSearchLoading = false;
    });
  }
}
