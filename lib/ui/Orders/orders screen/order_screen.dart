// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, non_constant_identifier_names, sized_box_for_whitespace, unused_element, unused_local_variable, use_build_context_synchronously, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, empty_catches, avoid_print, body_might_complete_normally_nullable

import 'dart:convert';
import 'dart:io';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
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
import 'package:cayan/ui/Orders/follow%20up%20the%20order/follow_up_the_order_screen.dart';
import 'package:cayan/ui/Orders/order%20date%20filteration%20bottom%20sheet/order_date_filteration_bottom_sheet.dart';
import 'package:cayan/ui/Orders/order%20filteration%20bottom%20sheet/order_filteration_bottom_sheet.dart';
import 'package:cayan/ui/drawer/navigation_drawer.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../add order/add_order.dart';
import 'package:http/http.dart' as http;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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

  List _drawerItem = [];

  int _page = 1;
  bool _isLoading = false;
  bool drawerLoading = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;

  void _getDraweItem() async {
    try {
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
          _drawerItem.contains("show orders") ? _getAllUsers() : null;
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
    } catch (e) {}
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
          "${Urls.GET_ORDERS_URL}$_page&status=${OrderUserData.getOrderStatusNameForSearch()}&start_date=${OrderUserData.getOrderHistoryFromSearch()}&end_date=${OrderUserData.getOrderHistoryToSearch()}&today=${OrderUserData.getOrderDaySearch()}",
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

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view

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
            "${Urls.GET_ORDERS_URL}$_page&status=${OrderUserData.getOrderStatusNameForSearch()}&start_date=${OrderUserData.getOrderHistoryFromSearch()}&end_date=${OrderUserData.getOrderHistoryToSearch()}&today=${OrderUserData.getOrderDaySearch()}",
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
    // _getAllUsers();
    _getDraweItem();
    _controller = ScrollController()..addListener(_loadMore);

    _searchController = ScrollController()..addListener(_SearchMore);

    _searchFocusNode = FocusNode();

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
          backgroundColor:
              themeProvider.isDarkMode ? blackColor : Color(0XFFF9F9F9),
          appBar: AppBar(
            backgroundColor:
                themeProvider.isDarkMode ? containerdarkColor : whiteColor,
            elevation: 0,
            centerTitle: true,
            title: BigText(
              typeOfFontWieght: 1,
              text: AppLocalizations.of(context)!.translate("Orders"),
            ),
            actions: [
              Row(
                children: [
                  _drawerItem.contains("show orders")
                      ? themeProvider.isDarkMode
                          ? InkWell(
                              onTap: openFile,
                              child: Image.asset("assets/images/export.png"))
                          : InkWell(
                              onTap: openFile,
                              child:
                                  Image.asset("assets/images/exportlight.png"))
                      : Container(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 31.25, //12
                  ),
                  _drawerItem.contains("show orders")
                      ? InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: OrderFilterationBottomSheet(),
                                  );
                                }).then((value) {
                              setState(() {});
                            });
                          },
                          child: themeProvider.isDarkMode
                              ? Image.asset("assets/images/filterdark.png")
                              : Image.asset("assets/images/filter.png"),
                        )
                      : Container(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 25, //15
                  ),
                ],
              ),
            ],
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.startDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height /
                    54.13333333333333), //15
            child: _drawerItem.contains("show orders")
                ? FloatingActionButton(
                    backgroundColor: mainAppColor,
                    onPressed: () {
                      setState(() {
                        ///sending to api
                        OrderUserData.setCategoryId(0);
                        OrderUserData.setCustomerId(0);
                        OrderUserData.setBrancheId(0);
                        OrderUserData.setSourceId(0);
                        OrderUserData.setOrderStatusId(1);

                        ///for showing
                        OrderUserData.setCategoryName("");
                        OrderUserData.setCustomerName("");
                        OrderUserData.setBrancheName("");
                        OrderUserData.setSourceName("");
                      });
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: AddOrder(),
                            );
                          }).then((value) {
                        setState(() {});
                      });
                    },
                    child: Icon(
                      Icons.add,
                      color: Color(0xFF292D32),
                    ),
                  )
                : Container(),
          ),
          body: _isLoading || drawerLoading
              ? ShimmerListView(
                  hight: MediaQuery.of(context).size.height / 7.25, //112
                )
              : _drawerItem.contains("show orders")
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchFocusNode.unfocus();
                        });
                      },
                      child: Column(
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
                                          OrderUserData
                                              .setOrderHistoryFromShowing("");
                                          OrderUserData
                                              .setOrderHistoryToShowing("");
                                          OrderUserData.setOrderDayShowing("");

                                          ///for get data
                                          OrderUserData
                                              .setOrderHistoryFromSearch("");
                                          OrderUserData.setOrderHistoryToSearch(
                                              "");
                                          OrderUserData.setOrderDaySearch("");
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
                                                  pageName: "orders",
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
                                  )
                                ],
                              ),
                            ),
                          ),

                          _isSearchLoading
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 50),
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
                                child: CircularProgressIndicator(
                                    color: mainAppColor),
                              ),
                            ),

                          // When nothing else to load
                          if (_hasNextPage == false)
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 40),
                              color: Colors.amber,
                              child: const Center(
                                child:
                                    Text('You have fetched all of the content'),
                              ),
                            ),
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
    return ListView.builder(
      controller: searchController.text == "" ? _controller : _searchController,
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 25,
          right: MediaQuery.of(context).size.width / 25,
          top: MediaQuery.of(context).size.height / 54.13333333333333), //15
      itemCount: searchController.text == ""
          ? _allUsers.length
          : _searchedResult.length,
      itemBuilder: (context, index) {
        return listViewBody(index, themeProvider);
      },
    );
  }

  Widget listViewBody(int index, ThemeProvider themeProvider) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FollowUpTheOrderScreen(
              orderId: searchController.text == ""
                  ? _allUsers[index]["id"] ?? ""
                  : _searchedResult[index]["id"] ?? "",
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height / 54.13333333333333, //15
        ), //15
        width: MediaQuery.of(context).size.width,

        decoration: BoxDecoration(
            color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height / 81.2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 35.30434782608696,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 18.75, //20
                ),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height / 23.2, //35
                  backgroundImage: _allUsers[index]["user_avatar"] != null
                      ? NetworkImage(
                          searchController.text == ""
                              ? _allUsers[index]["user_avatar"]
                              : _searchedResult[index]["user_avatar"],
                        )
                      : AssetImage("assets/images/userphotoright.png")
                          as ImageProvider,
                  backgroundColor: themeProvider.isDarkMode
                      ? containerdarkColor
                      : whiteColor,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width /
                      28.84615384615385, //13
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width /
                                    3.125, //120
                                child: SmallText(
                                  align: TextAlign.start,
                                  text: searchController.text == ""
                                      ? _allUsers[index]["user_name"] ?? ""
                                      : _searchedResult[index]["user_name"] ??
                                          "",
                                  size: MediaQuery.of(context).size.height / 58,
                                  color: themeProvider.isDarkMode
                                      ? whiteColor
                                      : blackColor,
                                  typeOfFontWieght: 1,
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height /
                                    162.4, //5
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width /
                                    3.125, //80
                                child: SmallText(
                                  align: TextAlign.start,
                                  text: searchController.text == ""
                                      ? _allUsers[index]["category"] ?? ""
                                      : _searchedResult[index]["category"] ??
                                          "",
                                  size: MediaQuery.of(context).size.height / 58,
                                  color: themeProvider.isDarkMode
                                      ? mainAppColor
                                      : textGrayColor,
                                  typeOfFontWieght: 0,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height /
                                  54.13333333333333,
                            ),
                            child: CustomButton(
                              enableCircleBorder: true,
                              height: MediaQuery.of(context).size.height /
                                  32.48, //25
                              width: MediaQuery.of(context).size.width /
                                  5.357142857142857, //70

                              btnLbl: "حفظ",
                              onPressedFunction: () {},
                              btnColor: searchController.text == ""
                                  ? _allUsers[index]["status"]["id"] == 1
                                      ? Color(0xff0670FB)
                                      : _allUsers[index]["status"]["id"] == 2
                                          ? Color(0xffFBA706)
                                          : _allUsers[index]["status"]["id"] ==
                                                  3
                                              ? Color(0xff29A71A)
                                              : Color(0xffD6262D)
                                  : _searchedResult[index]["status"]["id"] == 1
                                      ? Color(0xff0670FB)
                                      : _searchedResult[index]["status"]
                                                  ["id"] ==
                                              2
                                          ? Color(0xffFBA706)
                                          : _searchedResult[index]["status"]
                                                      ["id"] ==
                                                  3
                                              ? Color(0xff29A71A)
                                              : Color(0xffD6262D),
                              btnStyle: TextStyle(color: blackColor),

                              horizontalMargin:
                                  MediaQuery.of(context).size.width /
                                      34.09090909090909, //11
                              verticalMargin: 0,
                              lightBorderColor: searchController.text == ""
                                  ? _allUsers[index]["status"]["id"] == 1
                                      ? Color(0xff0670FB)
                                      : _allUsers[index]["status"]["id"] == 2
                                          ? Color(0xffFBA706)
                                          : _allUsers[index]["status"]["id"] ==
                                                  3
                                              ? Color(0xff29A71A)
                                              : Color(0xffD6262D)
                                  : _searchedResult[index]["status"]["id"] == 1
                                      ? Color(0xff0670FB)
                                      : _searchedResult[index]["status"]
                                                  ["id"] ==
                                              2
                                          ? Color(0xffFBA706)
                                          : _searchedResult[index]["status"]
                                                      ["id"] ==
                                                  3
                                              ? Color(0xff29A71A)
                                              : Color(0xffD6262D),
                              darkBorderColor: searchController.text == ""
                                  ? _allUsers[index]["status"]["id"] == 1
                                      ? Color(0xff0670FB)
                                      : _allUsers[index]["status"]["id"] == 2
                                          ? Color(0xffFBA706)
                                          : _allUsers[index]["status"]["id"] ==
                                                  3
                                              ? Color(0xff29A71A)
                                              : Color(0xffD6262D)
                                  : _searchedResult[index]["status"]["id"] == 1
                                      ? Color(0xff0670FB)
                                      : _searchedResult[index]["status"]
                                                  ["id"] ==
                                              2
                                          ? Color(0xffFBA706)
                                          : _searchedResult[index]["status"]
                                                      ["id"] ==
                                                  3
                                              ? Color(0xff29A71A)
                                              : Color(0xffD6262D),
                              addtionalWidgit: false,
                              child: Center(
                                child: SmallText(
                                  text: searchController.text == ""
                                      ? _allUsers[index]["status"]["name"] ?? ""
                                      : _searchedResult[index]["status"]
                                              ["name"] ??
                                          "",
                                  color: whiteColor,
                                  typeOfFontWieght: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 101.5, //8
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.height /
                                67.66666666666667, //12
                            backgroundImage: _allUsers[index]
                                        ["employee_avatar"] !=
                                    null
                                ? NetworkImage(
                                    searchController.text == ""
                                        ? _allUsers[index]["employee_avatar"]
                                        : _searchedResult[index]
                                            ["employee_avatar"],
                                  )
                                : AssetImage("assets/images/userphotoright.png")
                                    as ImageProvider,
                            backgroundColor: themeProvider.isDarkMode
                                ? containerdarkColor
                                : whiteColor,
                          ),
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width / 46.875, //8
                          ),
                          Container(
                            width: UserData.getUSerLang() == "ar"
                                ? MediaQuery.of(context).size.width /
                                    3.947368421052632
                                : MediaQuery.of(context).size.width /
                                    3.409090909090909,
                            child: SmallText(
                              align: TextAlign.start,
                              text:
                                  "${AppLocalizations.of(context)!.translate("employee in charge")} :",
                              size: MediaQuery.of(context).size.height /
                                  67.66666666666667, //12
                              color: textGrayColor,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width /
                                3.947368421052632,
                            child: SmallText(
                              align: TextAlign.start,
                              text: searchController.text == ""
                                  ? _allUsers[index]["last_employee"] ?? ""
                                  : _searchedResult[index]["last_employee"] ??
                                      "",
                              size: MediaQuery.of(context).size.height /
                                  67.66666666666667, //12
                              color: themeProvider.isDarkMode
                                  ? whiteColor
                                  : blackColor,
                              typeOfFontWieght: 0,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height:
                  MediaQuery.of(context).size.height / 36.90909090909091, //22
            ),
            Divider(
              height: 0,
              color:
                  themeProvider.isDarkMode ? dividerDarkColor : containerColor,
              endIndent: MediaQuery.of(context).size.width / 18.75,
              indent: MediaQuery.of(context).size.width / 18.75,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 58, //14
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 18.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/images/clock.png"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width /
                            53.57142857142857,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SmallText(
                            size: MediaQuery.of(context).size.height /
                                67.66666666666667, //12
                            text:
                                AppLocalizations.of(context)!.translate("Time"),
                            color: textGrayColor,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width /
                                5.769230769230769,
                            child: SmallText(
                              align: TextAlign.start,
                              size: MediaQuery.of(context).size.height /
                                  67.66666666666667, //12
                              text: searchController.text == ""
                                  ? _allUsers[index]["created_at"] ?? ""
                                  : _searchedResult[index]["created_at"] ?? "",
                              color: themeProvider.isDarkMode
                                  ? whiteColor
                                  : blackColor,
                              typeOfFontWieght: 1,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset("assets/images/subtitle.png"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width /
                            53.57142857142857,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SmallText(
                            size: MediaQuery.of(context).size.height /
                                67.66666666666667, //12
                            text: AppLocalizations.of(context)!
                                .translate("Source"),
                            color: textGrayColor,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width /
                                5.769230769230769,
                            child: SmallText(
                              align: TextAlign.start,
                              size: MediaQuery.of(context).size.height /
                                  67.66666666666667, //12
                              text: searchController.text == ""
                                  ? _allUsers[index]["source"] ?? ""
                                  : _searchedResult[index]["source"] ?? "",
                              color: themeProvider.isDarkMode
                                  ? whiteColor
                                  : blackColor,
                              typeOfFontWieght: 1,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset("assets/images/location.png"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width /
                            53.57142857142857,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SmallText(
                            size: MediaQuery.of(context).size.height /
                                67.66666666666667, //12
                            text: AppLocalizations.of(context)!
                                .translate("Branche"),
                            color: textGrayColor,
                          ),
                          Container(
                            // color: mainAppColor,
                            width: MediaQuery.of(context).size.width /
                                8.333333333333333,
                            child: SmallText(
                              align: TextAlign.start,
                              size: MediaQuery.of(context).size.height /
                                  67.66666666666667, //12
                              text: searchController.text == ""
                                  ? _allUsers[index]["branch"] ?? ""
                                  : _searchedResult[index]["branch"] ?? "",
                              color: themeProvider.isDarkMode
                                  ? whiteColor
                                  : blackColor,
                              typeOfFontWieght: 1,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 32.48, //25
            )
          ],
        ),
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
          "${Urls.GET_ORDERS_URL}${searchPage}&status=${OrderUserData.getOrderStatusNameForSearch()}&start_date=${OrderUserData.getOrderHistoryFromSearch()}&end_date=${OrderUserData.getOrderHistoryToSearch()}&user=${value}",
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
            "${Urls.GET_ORDERS_URL}${searchPage}&status=${OrderUserData.getOrderStatusNameForSearch()}&start_date=${OrderUserData.getOrderHistoryFromSearch()}&end_date=${OrderUserData.getOrderHistoryToSearch()}&user=${searchContent}",
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

  openFile() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    final response = await clientApi.get(
        Uri.parse(
          Urls.GET_ORDERS_EXCEEL_SHEET_URL,
        ),
        headers: <String, String>{
          'Accept': 'application/json',
          "Accept-Language": UserData.getUSerLang(),
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      print(map["file_link"]);
      if (map["file_link"] != null) {
        openFileMehod(
          url: map["file_link"],
          fileName: "orders.xlsx",
        );
      }
    } else if (response.statusCode == 401) {
      unauthorizedError.unauthorizedErrors401(context);
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
    } else if (response.statusCode == 403) {
      Navigator.of(context).popUntil((route) => route.isFirst);

      setState(() {
        erro403.error403(context, response.statusCode);
      });
    } else {
      setState(() {
        homeServerError.serverError(context, response.statusCode);
      });
    }
  }

  Future openFileMehod({required url, required String fileName}) async {
    final file = await downloadFile(url, fileName);

    if (file == null) return;

    print("path : ${file.path}");

    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String fileName) async {
    print("come here");
    final appStorge = await getApplicationDocumentsDirectory();

    final file = File("${appStorge.path}/$fileName");
    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );
      print(response.statusCode);
      print(response.data);

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
  }
}
