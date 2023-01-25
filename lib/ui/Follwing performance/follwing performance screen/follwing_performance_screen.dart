// ignore_for_file: unused_field, prefer_final_fields, avoid_print, use_build_context_synchronously, unnecessary_string_interpolations, unused_element, unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps, non_constant_identifier_names, sized_box_for_whitespace

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
import 'package:cayan/shared_preferences/follow_prefrmance/follow_prefromance_data.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Orders/order%20date%20filteration%20bottom%20sheet/order_date_filteration_bottom_sheet.dart';
import 'package:cayan/ui/drawer/navigation_drawer.dart';
import 'package:cayan/ui/follwing%20source/widget/follow_source_widet.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FollwingPerformanceScreen extends StatefulWidget {
  const FollwingPerformanceScreen({Key? key}) : super(key: key);

  @override
  State<FollwingPerformanceScreen> createState() =>
      _FollwingPerformanceScreenState();
}

class _FollwingPerformanceScreenState extends State<FollwingPerformanceScreen> {
  late FocusNode _searchFocusNode;

  http.Client clientApi = http.Client();

  String searchContent = '';

  final TextEditingController searchController = TextEditingController();

  late ScrollController _searchController;
  late ScrollController _controller;
  int searchPage = 1;

  bool _isSearchLoading = false;

  List<dynamic> _allUsers = [];
  List<dynamic> _searchedResult = [];

  int _page = 1;
  bool _isLoading = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

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
          "${Urls.GET_MODERATORS_URL}$_page&start_date=${FollowPrefUserData.getFollowPrefHistoryFromSearch()}&end_date=${FollowPrefUserData.getFollowprefHistoryToSearch()}",
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

  void _loadMore() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    if (_hasNextPage == true &&
        _isLoading == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 50) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1

      final response = await clientApi.get(
          Uri.parse(
            "${Urls.GET_MODERATORS_URL}$_page",
          ),
          headers: <String, String>{
            'Accept': 'application/json',
            "Accept-Language": UserData.getUSerLang(),
            'Content-Type': 'application/json',
            "Authorization": "Bearer ${UserData.getUserApiToken()}"
          });

      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        if (map.isNotEmpty) {
          setState(() {
            List<dynamic> data = map["data"];
            _allUsers.addAll(data);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } else if (response.statusCode == 401) {
        unauthorizedError.unauthorizedErrors401(context);
        setState(() {
          _isLoadMoreRunning = false;
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
          _isLoadMoreRunning = false;
        });
      } else if (response.statusCode == 403) {
        Navigator.of(context).popUntil((route) => route.isFirst);

        setState(() {
          erro403.error403(context, response.statusCode);
          _isLoadMoreRunning = false;
        });
      } else {
        setState(() {
          homeServerError.serverError(context, response.statusCode);
          _isLoadMoreRunning = false;
        });
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _getAllUsers();

    _controller = ScrollController()..addListener(_loadMore);

    _searchController = ScrollController()..addListener(_SearchMore);

    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    _searchFocusNode.dispose();
    _controller.removeListener(_loadMore);
    _searchController.removeListener(_SearchMore);

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
              text: AppLocalizations.of(context)!
                  .translate("follwing performance"),
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
          body: _isLoading
              ? ShimmerListView(
                  hight: MediaQuery.of(context).size.height / 7.25, //112
                )
              : GestureDetector(
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
                                width:
                                    MediaQuery.of(context).size.width / 25, //15
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
                                      FollowPrefUserData
                                          .setFollowprefHistoryFromShowing("");

                                      FollowPrefUserData
                                          .setFollowprefHistoryToShowing("");
                                      FollowPrefUserData
                                          .setFollowprefDayShowing("");

                                      ///for get data
                                      FollowPrefUserData
                                          .setFollowPrefHistoryFromSearch("");
                                      FollowPrefUserData
                                          .setFollowprefHistoryToSearch("");
                                      FollowPrefUserData.setFollowprefDaySearch(
                                          "");
                                    });
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child:
                                                OrderDateFilterationBottomSheet(
                                              pageName: "123",
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
                                      Image.asset("assets/images/calendar.png")
                                    ],
                                  )),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 25, //15
                              ),
                            ],
                          ),
                        ),
                      ),
                      _isSearchLoading
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 50),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: mainAppColor,
                                ),
                              ),
                            )
                          : Expanded(child: buildList(themeProvider)),
                      if (_isLoadMoreRunning == true)
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 40),
                          child: Center(
                            child:
                                CircularProgressIndicator(color: mainAppColor),
                          ),
                        ),

                      // When nothing else to load
                      if (_hasNextPage == false)
                        Container(
                          padding: const EdgeInsets.only(top: 30, bottom: 40),
                          color: Colors.amber,
                          child: const Center(
                            child: Text('You have fetched all of the content'),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildList(ThemeProvider themeProvider) {
    return ListView.builder(
        controller:
            searchController.text == "" ? _controller : _searchController,
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 25,
            right: MediaQuery.of(context).size.width / 25,
            top: MediaQuery.of(context).size.height / 54.13333333333333), //15
        itemCount: searchController.text == ""
            ? _allUsers.length
            : _searchedResult.length,
        itemBuilder: (context, index) {
          return listViewBody(index, themeProvider);
        });
  }

  Widget listViewBody(int index, ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height / 54.13333333333333, //15
      ), //15
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.height / 81.2),
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 40.6,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 18.75, //20
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width /
                        3.571428571428571, //100
                    height: MediaQuery.of(context).size.height /
                        7.733333333333333, //100
                    // color: mainAppColor,
                    child: PieChart(
                      PieChartData(
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          centerSpaceRadius:
                              MediaQuery.of(context).size.width / 9.375,
                          sections: [
                            PieChartSectionData(
                              color: orangeColor,
                              value: searchController.text == ""
                                  ? _allUsers[index]["orders_statuses"][1]
                                              ["orders_count"] ==
                                          0
                                      ? 1
                                      : _allUsers[index]["orders_statuses"][1]
                                              ["orders_count"]
                                          .toDouble()
                                  : _searchedResult[index]["orders_statuses"][1]
                                              ["orders_count"] ==
                                          0
                                      ? 1
                                      : _searchedResult[index]
                                                  ["orders_statuses"][1]
                                              ["orders_count"]
                                          .toDouble(),
                              // title: 'جديد%',
                              radius: MediaQuery.of(context).size.height /
                                  67.66666666666667,

                              titleStyle: TextStyle(
                                color: Colors.transparent,
                              ),
                            ),
                            PieChartSectionData(
                              color: greenColor,
                              value: searchController.text == ""
                                  ? _allUsers[index]["orders_statuses"][2]
                                              ["orders_count"] ==
                                          0
                                      ? 1
                                      : _allUsers[index]["orders_statuses"][2]
                                              ["orders_count"]
                                          .toDouble()
                                  : _searchedResult[index]["orders_statuses"][2]
                                              ["orders_count"] ==
                                          0
                                      ? 1
                                      : _searchedResult[index]
                                                  ["orders_statuses"][2]
                                              ["orders_count"]
                                          .toDouble(),
                              // title: 'جديد%',
                              radius: MediaQuery.of(context).size.height /
                                  67.66666666666667,

                              titleStyle: TextStyle(
                                color: Colors.transparent,
                              ),
                            ),
                            PieChartSectionData(
                              color: redColor,
                              value: searchController.text == ""
                                  ? _allUsers[index]["orders_statuses"][3]
                                              ["orders_count"] ==
                                          0
                                      ? 1
                                      : _allUsers[index]["orders_statuses"][3]
                                              ["orders_count"]
                                          .toDouble()
                                  : _searchedResult[index]["orders_statuses"][3]
                                              ["orders_count"] ==
                                          0
                                      ? 1
                                      : _searchedResult[index]
                                                  ["orders_statuses"][3]
                                              ["orders_count"]
                                          .toDouble(),
                              // title: 'جديد%',
                              radius: MediaQuery.of(context).size.height /
                                  67.66666666666667,

                              titleStyle: TextStyle(
                                color: Colors.transparent,
                              ),
                            ),
                            PieChartSectionData(
                              color: blueColor,
                              value: searchController.text == ""
                                  ? _allUsers[index]["orders_statuses"][0]
                                              ["orders_count"] ==
                                          0
                                      ? 1
                                      : _allUsers[index]["orders_statuses"][0]
                                              ["orders_count"]
                                          .toDouble()
                                  : _searchedResult[index]["orders_statuses"][0]
                                              ["orders_count"] ==
                                          0
                                      ? 1
                                      : _searchedResult[index]
                                                  ["orders_statuses"][0]
                                              ["orders_count"]
                                          .toDouble(),
                              // title: 'جديد%',
                              radius: MediaQuery.of(context).size.height /
                                  67.66666666666667,
                              titleStyle: TextStyle(
                                color: Colors.transparent,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  SmallText(
                    text: searchController.text == ""
                        ? (_allUsers[index]["percentage_to_all_orders"] * 100)
                                .toStringAsFixed(0) +
                            "%"
                        : (_searchedResult[index]["percentage_to_all_orders"] *
                                    100)
                                .toStringAsFixed(0) +
                            "%",
                    size:
                        MediaQuery.of(context).size.height / 47.76470588235294,
                    color: themeProvider.isDarkMode ? whiteColor : blackColor,
                    typeOfFontWieght: 1,
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 25, //15
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height /
                            67.66666666666667,
                        backgroundColor: themeProvider.isDarkMode
                            ? containerColor
                            : accentColor,
                        backgroundImage:
                            NetworkImage(_allUsers[index]["image"]),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 75,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width -
                            ((MediaQuery.of(context).size.width /
                                    1.973684210526316 //190
                                ) +
                                MediaQuery.of(context).size.width / 37.5 +
                                MediaQuery.of(context).size.width / 15),
                        child: SmallText(
                          align: TextAlign.start,
                          text: searchController.text == ""
                              ? _allUsers[index]["name"] ?? ""
                              : _searchedResult[index]["name"] ?? "",
                          size: MediaQuery.of(context).size.height /
                              54.13333333333333, //15
                          color: themeProvider.isDarkMode
                              ? whiteColor
                              : blackColor,
                          typeOfFontWieght: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 162.4, //5
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 162.4, //5
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 150),
                    width: MediaQuery.of(context).size.width -
                        (MediaQuery.of(context).size.width /
                            1.973684210526316 //190
                        ),
                    child: SmallText(
                      align: TextAlign.start,

                      text: searchController.text == ""
                          ? _allUsers[index]["total_orders"].toString()
                          : _searchedResult[index]["total_orders"].toString(),
                      size: MediaQuery.of(context).size.height / 40.6, //12
                      color: themeProvider.isDarkMode ? whiteColor : blackColor,
                      typeOfFontWieght: 1,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 101.5, //8
          ),
          Divider(
            color: themeProvider.isDarkMode ? dividerDarkColor : containerColor,
            indent: MediaQuery.of(context).size.width / 15, //25
            endIndent: MediaQuery.of(context).size.width / 15, //25
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 15, //20
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FollowSourceWidget(
                  color: blueColor,
                  name: searchController.text == ""
                      ? _allUsers[index]["orders_statuses"][0]["name"]
                      : _searchedResult[index]["orders_statuses"][0]["name"],
                  number: searchController.text == ""
                      ? _allUsers[index]["orders_statuses"][0]["orders_count"]
                      : _searchedResult[index]["orders_statuses"][0]
                          ["orders_count"],
                ),
                FollowSourceWidget(
                  color: orangeColor,
                  name: searchController.text == ""
                      ? _allUsers[index]["orders_statuses"][1]["name"]
                      : _searchedResult[index]["orders_statuses"][1]["name"],
                  number: searchController.text == ""
                      ? _allUsers[index]["orders_statuses"][1]["orders_count"]
                      : _searchedResult[index]["orders_statuses"][1]
                          ["orders_count"],
                ),
                FollowSourceWidget(
                  color: greenColor,
                  name: searchController.text == ""
                      ? _allUsers[index]["orders_statuses"][2]["name"]
                      : _searchedResult[index]["orders_statuses"][2]["name"],
                  number: searchController.text == ""
                      ? _allUsers[index]["orders_statuses"][2]["orders_count"]
                      : _searchedResult[index]["orders_statuses"][2]
                          ["orders_count"],
                ),
                FollowSourceWidget(
                  color: redColor,
                  name: searchController.text == ""
                      ? _allUsers[index]["orders_statuses"][3]["name"]
                      : _searchedResult[index]["orders_statuses"][3]["name"],
                  number: searchController.text == ""
                      ? _allUsers[index]["orders_statuses"][3]["orders_count"]
                      : _searchedResult[index]["orders_statuses"][3]
                          ["orders_count"],
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 81.2,
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
                  searchController.clear();
                  searchPage = 1;
                  setState(() {});
                } else if (value.isNotEmpty) {
                  setState(() {
                    searchContent = value;
                    searchPage = 1;

                    searchUserApicall(value);
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
          "${Urls.GET_MODERATORS_URL}${searchPage}&name=${value}",
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

  void _SearchMore() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    if (_hasNextPage == true &&
        _isLoading == false &&
        _isLoadMoreRunning == false &&
        _searchController.position.extentAfter < 50) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      searchPage += 1; // Increase _page by 1
      final response = await clientApi.get(
          Uri.parse(
            "${Urls.GET_MODERATORS_URL}${searchPage}&name=${searchContent}",
          ),
          headers: <String, String>{
            'Accept': 'application/json',
            "Accept-Language": UserData.getUSerLang(),
            'Content-Type': 'application/json',
            "Authorization": "Bearer ${UserData.getUserApiToken()}"
          });

      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        if (map.isNotEmpty) {
          setState(() {
            List<dynamic> data = map["data"];
            _searchedResult.addAll(data);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } else if (response.statusCode == 401) {
        unauthorizedError.unauthorizedErrors401(context);
        setState(() {
          _isLoadMoreRunning = false;
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
          _isLoadMoreRunning = false;
        });
      } else if (response.statusCode == 403) {
        Navigator.of(context).popUntil((route) => route.isFirst);

        setState(() {
          erro403.error403(context, response.statusCode);
          _isLoadMoreRunning = false;
        });
      } else {
        setState(() {
          homeServerError.serverError(context, response.statusCode);
          _isLoadMoreRunning = false;
        });
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }
}
