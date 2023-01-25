// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, use_build_context_synchronously, unused_element, unused_local_variable, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, non_constant_identifier_names, prefer_interpolation_to_compose_strings, sized_box_for_whitespace

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
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/drawer/navigation_drawer.dart';
import 'package:cayan/ui/sources/add%20source/add_source.dart';
import 'package:cayan/ui/sources/setting%20source/setting_source.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SourcesScreen extends StatefulWidget {
  const SourcesScreen({Key? key}) : super(key: key);

  @override
  State<SourcesScreen> createState() => _SourcesScrennState();
}

class _SourcesScrennState extends State<SourcesScreen> {
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
          "${Urls.GET_SOURCES_URL}$_page",
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
            "${Urls.GET_SOURCES_URL}$_page",
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
              text: AppLocalizations.of(context)!.translate("sources"),
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
                        child: AddSource(),
                      );
                    }).then((value) {
                  setState(() {});
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
                  ? ShimmerListView(
                      hight: MediaQuery.of(context).size.height / 2.5375, //371
                    )
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
        ? ListView.builder(
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
              return smallListViewBody(index, themeProvider);
            });
  }

  Widget listViewBody(int index, ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height / 54.13333333333333, //15
      ),
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height / 2.498461538461538, //317
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 40.6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 25,
                height: 5,
                color:
                    themeProvider.isDarkMode ? containerdarkColor : whiteColor,
              ),
              CircleAvatar(
                backgroundColor:
                    themeProvider.isDarkMode ? dividerDarkColor : cardColor,
                radius: MediaQuery.of(context).size.height / 18.04444444444444,
                backgroundImage: NetworkImage(
                  searchController.text == ""
                      ? _allUsers[index]["image"] ??
                          "https://dev.medical.cayan.co/images/source.png"
                      : _searchedResult[index]["image"] ??
                          "https://dev.medical.cayan.co/images/source.png",
                ),
              ),
              InkWell(
                onTap: () {
                  settingSource(
                    searchController.text == ""
                        ? _allUsers[index]["id"] ?? 0
                        : _searchedResult[index]["id"] ?? 0,

                    ///

                    searchController.text == ""
                        ? _allUsers[index]["translations"]["ar"]["name"] ?? ""
                        : _searchedResult[index]["translations"]["ar"]
                                ["name"] ??
                            "",

                    ///

                    searchController.text == ""
                        ? _allUsers[index]["translations"]["en"]["name"] ?? ""
                        : _searchedResult[index]["translations"]["en"]
                                ["name"] ??
                            "",

                    searchController.text == ""
                        ? _allUsers[index]["translations"]["ar"]
                                ["short_description"] ??
                            ""
                        : _searchedResult[index]["translations"]["ar"]
                                ["short_description"] ??
                            "",

                    ///

                    searchController.text == ""
                        ? _allUsers[index]["translations"]["en"]
                                ["short_description"] ??
                            ""
                        : _searchedResult[index]["translations"]["en"]
                                ["short_description"] ??
                            "",

                    ///

                    searchController.text == ""
                        ? _allUsers[index]["url"] ?? ""
                        : _searchedResult[index]["url"] ?? "",

                    searchController.text == ""
                        ? _allUsers[index]["image"] ?? ""
                        : _searchedResult[index]["image"] ?? "",

                    searchController.text == ""
                        ? _allUsers[index]["is_block"] ?? ""
                        : _searchedResult[index]["is_block"] ?? "",
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    left: UserData.getUSerLang() == "ar"
                        ? MediaQuery.of(context).size.width / 23.4375
                        : 0,
                    right: UserData.getUSerLang() == "en"
                        ? MediaQuery.of(context).size.width / 23.4375
                        : 0,
                    bottom:
                        MediaQuery.of(context).size.height / 14.76363636363636,
                  ),
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
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 54.13333333333333, //15
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              // color: mainAppColor,
              child: SmallText(
                text: searchController.text == ""
                    ? _allUsers[index]["name"] ?? ""
                    : _searchedResult[index]["name"] ?? "",
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
                size:
                    MediaQuery.of(context).size.height / 54.13333333333333, //15
                typeOfFontWieght: 1,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 162.4, //5
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.25,
              // color: mainAppColor,
              child: SmallText(
                text: searchController.text == ""
                    ? _allUsers[index]["short_description"] ?? ""
                    : _searchedResult[index]["short_description"] ?? "",
                color: searchController.text == ""
                    ? _allUsers[index]["is_block"] == true
                        ? redColor
                        : textGrayColor
                    : _searchedResult[index]["is_block"] == true
                        ? redColor
                        : textGrayColor,
                size: MediaQuery.of(context).size.height / 58, //15
                typeOfFontWieght: 1,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 58, //14
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    MediaQuery.of(context).size.width / 26.78571428571429),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/link.png"),
                SizedBox(
                  width: MediaQuery.of(context).size.width /
                      MediaQuery.of(context).size.width,
                ),
                Container(
                  width: MediaQuery.of(context).size.width /
                      1.363636363636364, //275
                  // color: mainAppColor,
                  child: SmallText(
                    isUnderLine: true,
                    align: TextAlign.center,
                    text: searchController.text == ""
                        ? _allUsers[index]["url"] ?? ""
                        : _searchedResult[index]["url"] ?? "",
                    color: mainAppColor,
                    size: MediaQuery.of(context).size.height / 58, //14
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 32.48, //25
          )
        ],
      ),
    );
  }

  Widget smallListViewBody(int index, ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height / 54.13333333333333, //15
      ),
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height / 2.498461538461538, //317
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

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 40.6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: UserData.getUSerLang() == "ar"
                            ? MediaQuery.of(context).size.width /
                                26.78571428571429
                            : MediaQuery.of(context).size.width /
                                26.78571428571429,
                        left: UserData.getUSerLang() == "ar"
                            ? 0
                            : MediaQuery.of(context).size.width /
                                26.78571428571429),
                    child: CircleAvatar(
                      backgroundColor: themeProvider.isDarkMode
                          ? dividerDarkColor
                          : cardColor,
                      radius: MediaQuery.of(context).size.height /
                          18.04444444444444,
                      backgroundImage: NetworkImage(
                        searchController.text == ""
                            ? _allUsers[index]["image"] ??
                                "https://dev.medical.cayan.co/images/source.png"
                            : _searchedResult[index]["image"] ??
                                "https://dev.medical.cayan.co/images/source.png",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: UserData.getUSerLang() == "ar"
                          ? MediaQuery.of(context).size.width /
                              22.05882352941176 //17
                          : 0,
                      left: UserData.getUSerLang() == "ar"
                          ? 0
                          : MediaQuery.of(context).size.width /
                              22.05882352941176, //17
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width /
                              2.142857142857143, //175
                          // color: mainAppColor,
                          child: SmallText(
                            align: TextAlign.start,
                            text: searchController.text == ""
                                ? _allUsers[index]["name"] ?? ""
                                : _searchedResult[index]["name"] ?? "",
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
                            size: MediaQuery.of(context).size.height /
                                54.13333333333333, //15
                            typeOfFontWieght: 1,
                          ),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height / 162.4, //5
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width /
                              2.142857142857143, //175
                          // color: mainAppColor,
                          child: SmallText(
                            align: TextAlign.start,
                            text: searchController.text == ""
                                ? _allUsers[index]["short_description"] ?? ""
                                : _searchedResult[index]["short_description"] ??
                                    "",
                            color: searchController.text == ""
                                ? _allUsers[index]["is_block"] == true
                                    ? redColor
                                    : textGrayColor
                                : _searchedResult[index]["is_block"] == true
                                    ? redColor
                                    : textGrayColor,
                            size: MediaQuery.of(context).size.height / 58, //15
                            typeOfFontWieght: 1,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 58, //14
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Image.asset("assets/images/link.png"),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 75,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width /
                                  2.205882352941176, //150
                              // height: 100,
                              // color: mainAppColor,
                              child: SmallText(
                                maxLine: 2,
                                isUnderLine: true,
                                align: TextAlign.start,
                                text: searchController.text == ""
                                    ? _allUsers[index]["url"] ?? ""
                                    : _searchedResult[index]["url"] ?? "",
                                color: mainAppColor,
                                size: MediaQuery.of(context).size.height /
                                    67.6666666666666666667, //14
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  settingSource(
                    searchController.text == ""
                        ? _allUsers[index]["id"] ?? 0
                        : _searchedResult[index]["id"] ?? 0,

                    ///

                    searchController.text == ""
                        ? _allUsers[index]["translations"]["ar"]["name"] ?? ""
                        : _searchedResult[index]["translations"]["ar"]
                                ["name"] ??
                            "",

                    ///

                    searchController.text == ""
                        ? _allUsers[index]["translations"]["en"]["name"] ?? ""
                        : _searchedResult[index]["translations"]["en"]
                                ["name"] ??
                            "",

                    searchController.text == ""
                        ? _allUsers[index]["translations"]["ar"]
                                ["short_description"] ??
                            ""
                        : _searchedResult[index]["translations"]["ar"]
                                ["short_description"] ??
                            "",

                    ///

                    searchController.text == ""
                        ? _allUsers[index]["translations"]["en"]
                                ["short_description"] ??
                            ""
                        : _searchedResult[index]["translations"]["en"]
                                ["short_description"] ??
                            "",

                    ///

                    searchController.text == ""
                        ? _allUsers[index]["url"] ?? ""
                        : _searchedResult[index]["url"] ?? "",

                    searchController.text == ""
                        ? _allUsers[index]["image"] ?? ""
                        : _searchedResult[index]["image"] ?? "",

                    searchController.text == ""
                        ? _allUsers[index]["is_block"] ?? ""
                        : _searchedResult[index]["is_block"] ?? "",
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    left: UserData.getUSerLang() == "ar"
                        ? MediaQuery.of(context).size.width / 25
                        : 0,
                    right: UserData.getUSerLang() == "ar"
                        ? 0
                        : MediaQuery.of(context).size.width / 25,
                    bottom: MediaQuery.of(context).size.height /
                        9.552941176470588, //75
                  ),
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
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 32.48,
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
          "${Urls.GET_SOURCES_URL}${searchPage}&name=${value}",
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
            "${Urls.GET_SOURCES_URL}${searchPage}&name=${searchContent}",
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

  settingSource(
    int userId,
    String userArbicName,
    String userEnglisName,
    String userArbicDescription,
    String userEnglisDescription,
    String code,
    String userImage,
    bool is_block,
  ) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SettingSource(
                userId: userId,
                userArbicName: userArbicName,
                userEnglisName: userEnglisName,
                userArbicDescription: userArbicDescription,
                userEnglisDescription: userEnglisDescription,
                code: code,
                userImage: userImage,
                is_block: is_block,
              ));
        });
  }
}
