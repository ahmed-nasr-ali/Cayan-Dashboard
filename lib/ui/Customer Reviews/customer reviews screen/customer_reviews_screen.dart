// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, non_constant_identifier_names, sized_box_for_whitespace, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/safe_area/page_container.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer%20grid%20view/shimmer_grid_view.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer%20list%20view/shimmer_list_view.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Customer%20Reviews/add%20customer%20review/add_customer_review.dart';
import 'package:cayan/ui/Customer%20Reviews/setting%20customer%20reviewe/setting_customer_review.dart';
import 'package:cayan/ui/drawer/navigation_drawer.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class customerReviewsScreen extends StatefulWidget {
  const customerReviewsScreen({Key? key}) : super(key: key);

  @override
  State<customerReviewsScreen> createState() => _customerReviewsScreenState();
}

class _customerReviewsScreenState extends State<customerReviewsScreen> {
  bool isGrid = UserData.getIsGridOrNot();

  http.Client clientApi = http.Client();

  late FocusNode _searchFocusNode;

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
          "${Urls.GET_CUSTOMER_REVIEW_URL}$_page",
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
            "${Urls.GET_CUSTOMER_REVIEW_URL}$_page",
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
              text: AppLocalizations.of(context)!.translate("Customer Reviews"),
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.startDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height /
                    54.13333333333333), //15
            child: FloatingActionButton(
              backgroundColor: mainAppColor,
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: AddCustomerReview(),
                      );
                    });
              },
              child: Icon(
                Icons.add,
                color: Color(0xFF292D32),
              ),
            ),
          ),
          body: _isLoading
              ? isGrid
                  ? ShimmerGridView()
                  : ShimmerListView(
                      hight: MediaQuery.of(context).size.height / 7.25, //112
                    )
              : GestureDetector(
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
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isGrid = !isGrid;

                                      UserData.setIsGridOrNot(isGrid);
                                    });
                                  },
                                  child: isGrid
                                      ? Image.asset("assets/images/Vetical.png")
                                      : Image.asset(
                                          "assets/images/blocks.png")),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 25, //15
                              )
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
    return UserData.getIsGridOrNot()
        ? GridView.builder(
            controller:
                searchController.text == "" ? _controller : _searchController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio:
                  (MediaQuery.of(context).size.width / 2.286585365853659) /
                      (MediaQuery.of(context).size.height /
                          4.164102564102564), //169/195
              crossAxisCount: 2,
              crossAxisSpacing: MediaQuery.of(context).size.width / 30, //15
              mainAxisSpacing: MediaQuery.of(context).size.height / 64.96, //15
            ),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 30,
                vertical: MediaQuery.of(context).size.height / 64.96), //15
            itemCount: searchController.text == ""
                ? _allUsers.length
                : _searchedResult.length,
            itemBuilder: (contex, index) {
              return gridViewBody(index, themeProvider);
            })
        : ListView.builder(
            controller:
                searchController.text == "" ? _controller : _searchController,
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 25,
                right: MediaQuery.of(context).size.width / 25,
                top: MediaQuery.of(context).size.height /
                    54.13333333333333), //15
            itemCount: searchController.text == ""
                ? _allUsers.length
                : _searchedResult.length,
            itemBuilder: (context, index) {
              return listViewBody(index, themeProvider);
            });
  }

  Widget gridViewBody(int index, ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.height / 81.2),
        border: Border.all(
          color: searchController.text == ""
              ? _allUsers[index]["is_block"] ?? false == true
                  ? redColor
                  : Colors.transparent
              : _searchedResult[index]["is_block"] ?? false == true
                  ? redColor
                  : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width / 7.5 //48
                  ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 40.6), //20
                child: Center(
                  child: ClipOval(
                    child: CircleAvatar(
                      backgroundImage: searchController.text == ""
                          ? NetworkImage(
                              _allUsers[index]["image"] ??
                                  "https://dev.medical.cayan.co/images/source.png",
                            )
                          : NetworkImage(
                              _searchedResult[index]["image"] ??
                                  "https://dev.medical.cayan.co/images/source.png",
                            ),
                      backgroundColor: themeProvider.isDarkMode
                          ? containerdarkColor
                          : whiteColor,
                      radius: MediaQuery.of(context).size.height /
                          22.55555555555556, // 36
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 18.75, //18
              ),
              Container(
                width:
                    MediaQuery.of(context).size.width / 17.04545454545455, //20
                height: MediaQuery.of(context).size.height / 16.24, //50
                child: InkWell(
                  radius: MediaQuery.of(context).size.height / 0.1624, //5000
                  onTap: () {
                    settingCustomerReview(
                      searchController.text == ""
                          ? _allUsers[index]["id"] ?? 0
                          : _searchedResult[index]["id"] ?? 0,
                      searchController.text == ""
                          ? _allUsers[index]["image"] ?? ""
                          : _searchedResult[index]["image"] ?? "",
                      searchController.text == ""
                          ? _allUsers[index]["user_name"] ?? ""
                          : _searchedResult[index]["user_name"] ?? "",
                      searchController.text == ""
                          ? _allUsers[index]["job"] ?? ""
                          : _searchedResult[index]["job"] ?? "",
                      searchController.text == ""
                          ? _allUsers[index]["comment"] ?? ""
                          : _searchedResult[index]["comment"] ?? "",
                      searchController.text == ""
                          ? _allUsers[index]["is_block"] ?? false
                          : _searchedResult[index]["is_block"] ?? false,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height /
                            27.06666666666667), //30
                    child: themeProvider.isDarkMode
                        ? Image.asset(
                            "assets/images/list.png",
                            color: searchController.text == ""
                                ? _allUsers[index]["is_block"] ?? false == true
                                    ? redColor
                                    : whiteColor
                                : _searchedResult[index]["is_block"] ??
                                        false == true
                                    ? redColor
                                    : whiteColor,
                          )
                        : Image.asset(
                            "assets/images/listLight.png",
                            color: searchController.text == ""
                                ? _allUsers[index]["is_block"] == true
                                    ? redColor
                                    : blackColor
                                : _searchedResult[index]["is_block"] == true
                                    ? redColor
                                    : blackColor,
                          ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 162.4, //5
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 37.5), //10
            child: Container(
              width:
                  MediaQuery.of(context).size.width / 2.777777777777778, //135
              child: SmallText(
                align: TextAlign.center,
                text: searchController.text == ""
                    ? _allUsers[index]["user_name"] ?? ""
                    : _searchedResult[index]["user_name"] ?? "",
                color: themeProvider.isDarkMode
                    ? searchController.text == ""
                        ? _allUsers[index]["is_block"] == true
                            ? redColor
                            : whiteColor
                        : _searchedResult[index]["is_block"] == true
                            ? redColor
                            : whiteColor
                    : searchController.text == ""
                        ? _allUsers[index]["is_block"] == true
                            ? redColor
                            : blackColor
                        : _searchedResult[index]["is_block"] == true
                            ? redColor
                            : blackColor,
                typeOfFontWieght: 1,
                size: MediaQuery.of(context).size.height / 58, //14
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 81.2), //10
          Container(
              width:
                  MediaQuery.of(context).size.width / 2.884615384615385, //130
              height:
                  MediaQuery.of(context).size.height / 18.88372093023256, //43
              child: SmallText(
                align: TextAlign.center,
                maxLine: 2,
                color: searchController.text == ""
                    ? _allUsers[index]["is_block"] == true
                        ? redColor
                        : textGrayColor
                    : _searchedResult[index]["is_block"] == true
                        ? redColor
                        : textGrayColor,
                text: searchController.text == ""
                    ? _allUsers[index]["comment"] ?? ""
                    : _searchedResult[index]["comment"] ?? "",
                size: MediaQuery.of(context).size.height /
                    67.66666666666667, //10,
              ))
        ],
      ),
    );
  }

  Widget listViewBody(int index, ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height / 54.13333333333333, //15
      ), //15
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 6.601626016260163, //123
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.height / 81.2),
        border: Border.all(
          color: searchController.text == ""
              ? _allUsers[index]["is_block"] == true
                  ? redColor
                  : Colors.transparent
              : _searchedResult[index]["is_block"] == true
                  ? redColor
                  : Colors.transparent,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 18.75, //20
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 40.6), //20
            child: ClipOval(
              child: CircleAvatar(
                backgroundImage: searchController.text == ""
                    ? NetworkImage(
                        _allUsers[index]["image"] ??
                            "https://dev.medical.cayan.co/images/source.png",
                      )
                    : NetworkImage(
                        _searchedResult[index]["image"] ??
                            "https://dev.medical.cayan.co/images/source.png",
                      ),
                backgroundColor:
                    themeProvider.isDarkMode ? containerdarkColor : whiteColor,
                radius: MediaQuery.of(context).size.height /
                    22.55555555555556, // 36
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 25, //15
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 40.6), //20
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.5, // 150
                  child: SmallText(
                    align: TextAlign.start,
                    text: searchController.text == ""
                        ? _allUsers[index]["user_name"] ?? ""
                        : _searchedResult[index]["user_name"] ?? "",
                    color: themeProvider.isDarkMode
                        ? searchController.text == ""
                            ? _allUsers[index]["is_block"] == true
                                ? redColor
                                : whiteColor
                            : _searchedResult[index]["is_block"] == true
                                ? redColor
                                : whiteColor
                        : searchController.text == ""
                            ? _allUsers[index]["is_block"] == true
                                ? redColor
                                : blackColor
                            : _searchedResult[index]["is_block"] == true
                                ? redColor
                                : blackColor,
                    typeOfFontWieght: 1,
                    size: MediaQuery.of(context).size.height / 58, //14
                  ),
                ),

                SizedBox(
                    height: MediaQuery.of(context).size.height / 162.4), //10
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.875, //190
                      child: SmallText(
                        align: TextAlign.start,
                        maxLine: 2,
                        textHight: 2,
                        text: searchController.text == ""
                            ? _allUsers[index]["comment"] ?? ""
                            : _searchedResult[index]["comment"] ?? "",
                        color: searchController.text == ""
                            ? _allUsers[index]["is_block"] == true
                                ? redColor
                                : textGrayColor
                            : _searchedResult[index]["is_block"] == true
                                ? redColor
                                : textGrayColor,
                        size: MediaQuery.of(context).size.height /
                            67.66666666666667, //10
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                settingCustomerReview(
                  searchController.text == ""
                      ? _allUsers[index]["id"] ?? 0
                      : _searchedResult[index]["id"] ?? 0,
                  searchController.text == ""
                      ? _allUsers[index]["image"] ?? ""
                      : _searchedResult[index]["image"] ?? "",
                  searchController.text == ""
                      ? _allUsers[index]["user_name"] ?? ""
                      : _searchedResult[index]["user_name"] ?? "",
                  searchController.text == ""
                      ? _allUsers[index]["job"] ?? ""
                      : _searchedResult[index]["job"] ?? "",
                  searchController.text == ""
                      ? _allUsers[index]["comment"] ?? ""
                      : _searchedResult[index]["comment"] ?? "",
                  searchController.text == ""
                      ? _allUsers[index]["is_block"] ?? false
                      : _searchedResult[index]["is_block"] ?? false,
                );
              },
              child: Padding(
                padding: EdgeInsets.only(
                    bottom:
                        MediaQuery.of(context).size.height / 12.49230769230769),
                child: themeProvider.isDarkMode
                    ? Image.asset(
                        "assets/images/list.png",
                        color: searchController.text == ""
                            ? _allUsers[index]["is_block"] == true
                                ? redColor
                                : whiteColor
                            : _searchedResult[index]["is_block"] == true
                                ? redColor
                                : whiteColor,
                      )
                    : Image.asset(
                        "assets/images/listLight.png",
                        color: searchController.text == ""
                            ? _allUsers[index]["is_block"] == true
                                ? redColor
                                : blackColor
                            : _searchedResult[index]["is_block"] == true
                                ? redColor
                                : blackColor,
                      ),
              ),
            ),
          ),
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
          "${Urls.GET_CUSTOMER_REVIEW_URL}${searchPage}&user_name=${value}",
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
            "${Urls.GET_CUSTOMER_REVIEW_URL}${searchPage}&user_name=${searchContent}",
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

  settingCustomerReview(
    int userId,
    String userimage,
    String userName,
    String userJob,
    String userComment,
    bool isBlock,
  ) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SettingCustomerReview(
                userId: userId,
                userimage: userimage,
                userName: userName,
                userJob: userJob,
                userComment: userComment,
                isBlock: isBlock,
              ));
        });
  }
}
