// ignore_for_file: prefer_const_constructors, unused_field, unused_element, unused_local_variable, prefer_final_fields, unnecessary_string_interpolations, use_build_context_synchronously, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, sized_box_for_whitespace

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
import 'package:cayan/providers/add_roles_and_perimisson_provider.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Roles%20and%20Permissions/add%20role%20and%20permission/add_role_and_permission.dart';
import 'package:cayan/ui/Roles%20and%20Permissions/setting%20roles%20and%20permissions/setting_roles_and_permissions.dart';
import 'package:cayan/ui/drawer/navigation_drawer.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RolesAndPermissionScreen extends StatefulWidget {
  const RolesAndPermissionScreen({Key? key}) : super(key: key);

  @override
  State<RolesAndPermissionScreen> createState() =>
      _RolesAndPermissionScreenState();
}

class _RolesAndPermissionScreenState extends State<RolesAndPermissionScreen> {
  bool isGrid = UserData.getIsGridOrNot();

  http.Client clientApi = http.Client();

  String searchContent = '';

  late FocusNode _searchFocusNode;

  final TextEditingController searchController = TextEditingController();

  late ScrollController _searchController;
  late ScrollController _controller;

  bool _isLoading = false;

  bool _isSearchLoading = false;
  List<dynamic> _allUsers = [];
  List<dynamic> _searchedResult = [];

  _getAllRoles() async {
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
          "${Urls.GET_ROLES}",
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

  @override
  void initState() {
    super.initState();

    _getAllRoles();

    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    clientApi.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final _addRolesAndPerimissonsProvider =
        Provider.of<AddRolesAndPerimissionsProvider>(context);

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
                  .translate("roles and perimessions"),
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
                setState(() {
                  _addRolesAndPerimissonsProvider.categoryID.clear();
                });
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: AddRoleAndPermission(),
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
                      itemLength: 10,
                      hight: MediaQuery.of(context).size.height /
                          13.53333333333333, //13
                    )
                  : ShimmerListView(
                      itemLength: 10,
                      hight: MediaQuery.of(context).size.height /
                          13.53333333333333, //13
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
                          : Expanded(
                              child: buildList(themeProvider,
                                  _addRolesAndPerimissonsProvider)),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildList(ThemeProvider themeProvider,
      AddRolesAndPerimissionsProvider _addRolesAndPerimissonsProvider) {
    return UserData.getIsGridOrNot()
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio:
                  (MediaQuery.of(context).size.width / 2.286585365853659) /
                      (MediaQuery.of(context).size.height / 16.24), //169/195
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
              return gridViewBody(
                  index, themeProvider, _addRolesAndPerimissonsProvider);
            })
        : ListView.builder(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 25,
                right: MediaQuery.of(context).size.width / 25,
                top: MediaQuery.of(context).size.height /
                    54.13333333333333), //15
            itemCount: searchController.text == ""
                ? _allUsers.length
                : _searchedResult.length,
            itemBuilder: (context, index) {
              return listViewBody(
                  index, themeProvider, _addRolesAndPerimissonsProvider);
            });
  }

  Widget gridViewBody(int index, ThemeProvider themeProvider,
      AddRolesAndPerimissionsProvider _addRolesAndPerimissonsProvider) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.height / 81.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3,
            // color: mainAppColor,
            alignment: UserData.getUSerLang() == "ar"
                ? Alignment.centerRight
                : Alignment.centerLeft,
            // width: 150,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 25 //15
                  ),
              child: SmallText(
                text: searchController.text == ""
                    ? _allUsers[index]["name"] ?? ""
                    : _searchedResult[index]["name"] ?? "",
                color: themeProvider.isDarkMode ? whiteColor : blackColor,
                size: MediaQuery.of(context).size.height / 58, //14
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 46.875 //8
                ), //8
            width: MediaQuery.of(context).size.width / 17.04545454545455, //20
            height: MediaQuery.of(context).size.height / 16.24, //50

            child: InkWell(
              onTap: () {
                settingServices(_allUsers[index]["id"] ?? 0);
                setState(() {
                  _addRolesAndPerimissonsProvider.categoryID.clear();
                });
              },
              child: themeProvider.isDarkMode
                  ? Image.asset("assets/images/list.png")
                  : Image.asset("assets/images/listLight.png"),
            ),
          )
        ],
      ),
    );
  }

  Widget listViewBody(int index, ThemeProvider themeProvider,
      AddRolesAndPerimissionsProvider _addRolesAndPerimissonsProvider) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height / 54.13333333333333, //15
      ), //15
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 13.53333333333333, //13
      decoration: BoxDecoration(
          color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.height / 81.2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 1.785714285714286, //210
            alignment: UserData.getUSerLang() == "ar"
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SmallText(
                text: searchController.text == ""
                    ? _allUsers[index]["name"] ?? ""
                    : _searchedResult[index]["name"] ?? "",
                color: themeProvider.isDarkMode ? whiteColor : blackColor,
                size: MediaQuery.of(context).size.height / 58, //14
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 46.875 //8
                ), //8
            width: MediaQuery.of(context).size.width / 17.04545454545455, //20
            height: MediaQuery.of(context).size.height / 16.24, //50

            child: InkWell(
              onTap: () {
                settingServices(_allUsers[index]["id"] ?? "");
                setState(() {
                  _addRolesAndPerimissonsProvider.categoryID.clear();
                });
              },
              child: themeProvider.isDarkMode
                  ? Image.asset("assets/images/list.png")
                  : Image.asset("assets/images/listLight.png"),
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
                  searchController.clear();
                  // searchPage = 1;
                  setState(() {
                    searchController.clear();
                  });
                } else if (value.isNotEmpty) {
                  setState(() {
                    searchContent = value;
                    // searchPage = 1;
                    // searchUserApicall(value);
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

  settingServices(int id) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SettingRolesAndPermissions(
              id: id,
            ),
          );
        });
  }
}
