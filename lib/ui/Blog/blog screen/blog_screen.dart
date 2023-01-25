// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_field, prefer_final_fields, prefer_const_literals_to_create_immutables, avoid_print, prefer_interpolation_to_compose_strings, non_constant_identifier_names, use_build_context_synchronously, unused_element, unnecessary_brace_in_string_interps, sized_box_for_whitespace

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
import 'package:cayan/ui/Blog/add%20blog/add_blog.dart';
import 'package:cayan/ui/Blog/blog%20setting/blog_stting.dart';
import 'package:cayan/ui/drawer/navigation_drawer.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  http.Client clientApi = http.Client();

  bool isGrid = UserData.getIsGridOrNot();
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
          "${Urls.GET_BLOGS_URL}$_page",
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
            "${Urls.GET_BLOGS_URL}$_page",
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
              text: AppLocalizations.of(context)!.translate("blog"),
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
                        child: AddBlog(),
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
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height:
                    MediaQuery.of(context).size.height / 4.98159509202454, //163
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        MediaQuery.of(context).size.height / 81.2),
                    topRight: Radius.circular(
                        MediaQuery.of(context).size.height / 81.2),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: searchController.text == ""
                        ? NetworkImage(
                            _allUsers[index]["avatar"] ??
                                "https://dev.medical.cayan.co/images/source.png",
                          )
                        : NetworkImage(
                            _searchedResult[index]["avatar"] ??
                                "https://dev.medical.cayan.co/images/source.png",
                          ),
                  ),
                ),
              ),
              Positioned(
                right: UserData.getUSerLang() == "ar"
                    ? MediaQuery.of(context).size.width / 12.5 //30
                    : MediaQuery.of(context).size.width -
                        (MediaQuery.of(context).size.width /
                            3.409090909090909 //110
                        ), //75
                child: Container(
                  width: MediaQuery.of(context).size.width / 7.5, //50

                  color: mainAppColor,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 101.5, //8
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width / 37.5),
                        child: SmallText(
                          text: searchController.text == ""
                              ? _allUsers[index]["date"] ?? ""
                              : _searchedResult[index]["date"] ?? "",
                          maxLine: 2,
                          size: MediaQuery.of(context).size.height / 81.2,
                          color: themeProvider.isDarkMode
                              ? searchController.text == ""
                                  ? _allUsers[index]["is_block"] == true
                                      ? redColor
                                      : blackColor
                                  : _searchedResult[index]["is_block"] == true
                                      ? redColor
                                      : blackColor
                              : searchController.text == ""
                                  ? _allUsers[index]["is_block"] == true
                                      ? redColor
                                      : blackColor
                                  : _searchedResult[index]["is_block"] == true
                                      ? redColor
                                      : blackColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 40.6, //20
                left: UserData.getUSerLang() == "ar"
                    ? MediaQuery.of(context).size.width / 18.75 //20
                    : MediaQuery.of(context).size.width - 75,
                child: GestureDetector(
                  onTap: () {
                    settingBlog(
                      searchController.text == ""
                          ? _allUsers[index]["id"] ?? 0
                          : _searchedResult[index]["id"] ?? 0,

                      ///

                      searchController.text == ""
                          ? _allUsers[index]["translations"]["ar"]["title"] ??
                              ""
                          : _searchedResult[index]["translations"]["ar"]
                                  ["title"] ??
                              "",

                      ///

                      searchController.text == ""
                          ? _allUsers[index]["translations"]["en"]["title"] ??
                              ""
                          : _searchedResult[index]["translations"]["en"]
                                  ["title"] ??
                              "",

                      ///

                      searchController.text == ""
                          ? _allUsers[index]["translations"]["ar"]
                                  ["long_description"] ??
                              ""
                          : _searchedResult[index]["translations"]["ar"]
                                  ["long_description"] ??
                              "",

                      ///

                      searchController.text == ""
                          ? _allUsers[index]["translations"]["en"]
                                  ["long_description"] ??
                              ""
                          : _searchedResult[index]["translations"]["en"]
                                  ["long_description"] ??
                              "",

                      ///

                      searchController.text == ""
                          ? _allUsers[index]["translations"]["ar"]
                                  ["short_description"] ??
                              ""
                          : _searchedResult[index]["translations"]["ar"]
                                  ["description"] ??
                              "",

                      ///

                      searchController.text == ""
                          ? _allUsers[index]["translations"]["en"]
                                  ["short_description"] ??
                              ""
                          : _searchedResult[index]["translations"]["en"]
                                  ["description"] ??
                              "",

                      ///

                      searchController.text == ""
                          ? _allUsers[index]["reference_link"] ?? ""
                          : _searchedResult[index]["reference_link"] ?? "",

                      ///

                      searchController.text == ""
                          ? _allUsers[index]["avatar"] ?? ""
                          : _searchedResult[index]["avatar"] ?? "",

                      ///

                      searchController.text == ""
                          ? _allUsers[index]["is_block"] ?? false
                          : _searchedResult[index]["is_block"] ?? false,

                      ///

                      searchController.text == ""
                          ? _allUsers[index]["date"] ?? ""
                          : _searchedResult[index]["date"] ?? "",
                    );
                  },
                  child: Image.asset(
                    "assets/images/listicon.png",
                    color: searchController.text == ""
                        ? _allUsers[index]["is_block"] == true
                            ? redColor
                            : null
                        : _searchedResult[index]["is_block"] == true
                            ? redColor
                            : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40.6,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 25), //15

            height: MediaQuery.of(context).size.width / 18.75, //20
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode
                  ? dividerDarkColor
                  : Color(0xffFFFAE0),
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height / 81.2), //10
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 25),
              child: SmallText(
                text: searchController.text == ""
                    ? _allUsers[index]["title"] ?? ""
                    : _searchedResult[index]["title"] ?? "",
                color: mainAppColor,
                size: MediaQuery.of(context).size.height / 81.2, //10
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 81.2, //10
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 25), //15
            child: Container(
              width: MediaQuery.of(context).size.width,
              // color: mainAppColor,
              child: SmallText(
                align: TextAlign.start,
                text: searchController.text == ""
                    ? _allUsers[index]["short_description"] ?? ""
                    : _searchedResult[index]["short_description"] ?? "",
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
          SizedBox(
            height: MediaQuery.of(context).size.height / 81.2, //6
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 25), //15
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: SmallText(
                align: TextAlign.start,
                maxLine: 2,
                text: searchController.text == ""
                    ? _allUsers[index]["long_description"] ?? ""
                    : _searchedResult[index]["long_description"] ?? "",
                color: searchController.text == ""
                    ? _allUsers[index]["is_block"] == true
                        ? redColor
                        : textGrayColor
                    : _searchedResult[index]["is_block"] == true
                        ? redColor
                        : textGrayColor,
                typeOfFontWieght: 1,
                size:
                    MediaQuery.of(context).size.height / 67.66666666666667, //12
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 35.30434782608696, //23
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
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 6.014814814814815,
              width:
                  MediaQuery.of(context).size.width / 2.586206896551724, //145
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(UserData.getUSerLang() == "ar"
                      ? 0
                      : MediaQuery.of(context).size.height / 81.2),
                  topRight: Radius.circular(
                    UserData.getUSerLang() == "ar"
                        ? MediaQuery.of(context).size.height / 81.2
                        : 0,
                  ),
                  bottomLeft: Radius.circular(UserData.getUSerLang() == "ar"
                      ? 0
                      : MediaQuery.of(context).size.height / 81.2),
                  bottomRight: Radius.circular(
                    UserData.getUSerLang() == "ar"
                        ? MediaQuery.of(context).size.height / 81.2
                        : 0,
                  ),
                ),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: searchController.text == ""
                      ? NetworkImage(
                          _allUsers[index]["avatar"] ??
                              "https://dev.medical.cayan.co/images/source.png",
                        )
                      : NetworkImage(
                          _searchedResult[index]["avatar"] ??
                              "https://dev.medical.cayan.co/images/source.png",
                        ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 23.4375),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height /
                          67.66666666666667, //12
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width /
                              4.166666666666667, //90
                          decoration: BoxDecoration(
                            color: themeProvider.isDarkMode
                                ? dividerDarkColor
                                : Color(0xffFFFAE0),
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height / 81.2), //10
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width /
                                  28.84615384615385, //13
                            ),
                            child: SmallText(
                              text: searchController.text == ""
                                  ? _allUsers[index]["title"] ?? ""
                                  : _searchedResult[index]["title"] ?? "",
                              color: mainAppColor,
                              size: MediaQuery.of(context).size.height /
                                  81.2, //10
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            settingBlog(
                              searchController.text == ""
                                  ? _allUsers[index]["id"] ?? ""
                                  : _searchedResult[index]["id"] ?? "",

                              ///

                              searchController.text == ""
                                  ? _allUsers[index]["translations"]["ar"]
                                          ["title"] ??
                                      ""
                                  : _searchedResult[index]["translations"]["ar"]
                                          ["title"] ??
                                      "",

                              ///

                              searchController.text == ""
                                  ? _allUsers[index]["translations"]["en"]
                                          ["title"] ??
                                      ""
                                  : _searchedResult[index]["translations"]["en"]
                                          ["title"] ??
                                      "",

                              ///

                              searchController.text == ""
                                  ? _allUsers[index]["translations"]["ar"]
                                          ["long_description"] ??
                                      ""
                                  : _searchedResult[index]["translations"]["ar"]
                                          ["long_description"] ??
                                      "",

                              ///

                              searchController.text == ""
                                  ? _allUsers[index]["translations"]["en"]
                                          ["long_description"] ??
                                      ""
                                  : _searchedResult[index]["translations"]["en"]
                                          ["long_description"] ??
                                      "",

                              ///

                              searchController.text == ""
                                  ? _allUsers[index]["translations"]["ar"]
                                          ["short_description"] ??
                                      ""
                                  : _searchedResult[index]["translations"]["ar"]
                                          ["description"] ??
                                      "",

                              ///

                              searchController.text == ""
                                  ? _allUsers[index]["translations"]["en"]
                                          ["short_description"] ??
                                      ""
                                  : _searchedResult[index]["translations"]["en"]
                                          ["description"] ??
                                      "",

                              ///

                              searchController.text == ""
                                  ? _allUsers[index]["reference_link"] ?? ""
                                  : _searchedResult[index]["reference_link"] ??
                                      "",

                              ///

                              searchController.text == ""
                                  ? _allUsers[index]["avatar"] ?? ""
                                  : _searchedResult[index]["avatar"] ?? "",

                              ///

                              searchController.text == ""
                                  ? _allUsers[index]["is_block"] ?? ""
                                  : _searchedResult[index]["is_block"] ?? "",

                              ///

                              searchController.text == ""
                                  ? _allUsers[index]["date"] ?? ""
                                  : _searchedResult[index]["date"] ?? "",
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: UserData.getUSerLang() == "ar" ? 0 : 15,
                                right: UserData.getUSerLang() == "ar" ? 15 : 0),
                            child: themeProvider.isDarkMode
                                ? Image.asset(
                                    "assets/images/list.png",
                                    color: searchController.text == ""
                                        ? _allUsers[index]["is_block"] == true
                                            ? redColor
                                            : whiteColor
                                        : _searchedResult[index]["is_block"] ==
                                                true
                                            ? redColor
                                            : whiteColor,
                                  )
                                : Image.asset(
                                    "assets/images/listLight.png",
                                    color: searchController.text == ""
                                        ? _allUsers[index]["is_block"] == true
                                            ? redColor
                                            : blackColor
                                        : _searchedResult[index]["is_block"] ==
                                                true
                                            ? redColor
                                            : blackColor,
                                  ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 101.5, //5
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // color: mainAppColor,
                      child: SmallText(
                        align: TextAlign.start,
                        text: searchController.text == ""
                            ? _allUsers[index]["short_description"] ?? ""
                            : _searchedResult[index]["short_description"] ?? "",
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
                      height: MediaQuery.of(context).size.height / 81.2, //10
                    ),
                    SmallText(
                      align: TextAlign.start,
                      maxLine: 2,
                      text: searchController.text == ""
                          ? _allUsers[index]["long_description"]
                          : _searchedResult[index]["long_description"],
                      color: searchController.text == ""
                          ? _allUsers[index]["is_block"] == true
                              ? redColor
                              : textGrayColor
                          : _searchedResult[index]["is_block"] == true
                              ? redColor
                              : textGrayColor,
                      typeOfFontWieght: 1,
                      size: MediaQuery.of(context).size.height /
                          67.66666666666667, //12
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height /
                          54.13333333333333,
                    )
                  ],
                ),
              ),
            )
          ],
        ));
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
          "${Urls.GET_BLOGS_URL}${searchPage}&title=${value}",
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
            "${Urls.GET_BLOGS_URL}${searchPage}&title=${searchContent}",
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

  settingBlog(
    int userId,
    String userArbicTitle,
    String userEnglisTitle,
    String userArbicDescription,
    String userEnglisDescription,
    String userShortArbicDescription,
    String userShortEnglisDescription,
    String reference_link,
    String userimage,
    bool is_block,
    String date,
  ) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: BlogSetting(
                userId: userId,
                userArbicTitle: userArbicTitle,
                userEnglisTitle: userEnglisTitle,
                userArbicDescription: userArbicDescription,
                userEnglisDescription: userEnglisDescription,
                userShortArbicDescription: userShortArbicDescription,
                userShortEnglisDescription: userShortEnglisDescription,
                reference_link: reference_link,
                userimage: userimage,
                is_block: is_block,
                date: date,
              ));
        });
  }
}
