// ignore_for_file: unused_local_variable, use_build_context_synchronously, prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, sized_box_for_whitespace

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer%20list%20view/shimmer_list_view.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/order%20user%20data/order_user_data.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SourcesBottomSheet extends StatefulWidget {
  const SourcesBottomSheet({Key? key}) : super(key: key);

  @override
  State<SourcesBottomSheet> createState() => _SourcesBottomSheetState();
}

class _SourcesBottomSheetState extends State<SourcesBottomSheet> {
  late ScrollController _controller;

  http.Client clientApi = http.Client();

  List<dynamic> _allUsers = [];
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
  }

  @override
  void dispose() {
    super.dispose();

    _controller.removeListener(_loadMore);

    clientApi.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NetworkIndicator(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.824719101123596, //430
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(MediaQuery.of(context).size.height / 81.2),
                topRight:
                    Radius.circular(MediaQuery.of(context).size.height / 81.2)),
            color: themeProvider.isDarkMode ? containerdarkColor : whiteColor),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height:
                  MediaQuery.of(context).size.height / 54.13333333333333, //15
            ),
            Center(
              child: Container(
                // margin: EdgeInsets.symmetric(horizontal: 0),
                width: MediaQuery.of(context).size.width / 9.375, //40
                height: MediaQuery.of(context).size.height / 162.4, //5
                decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? dividerDarkColor
                        : containerColor,
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height / 162.4)), //5
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 40.6, //12
            ),
            _isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 25),
                    child: ShimmerWidget.circular(
                      hight: MediaQuery.of(context).size.height / 32.48,
                      width: MediaQuery.of(context).size.width / 3,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width /
                            20.83333333333333), //18
                    child: SmallText(
                      text: AppLocalizations.of(context)!.translate("Source"),
                      color: themeProvider.isDarkMode ? whiteColor : blackColor,
                      size: MediaQuery.of(context).size.height / 50.75, //16
                      typeOfFontWieght: 1,
                    ),
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 162.4, //5
            ),
            _isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 25),
                    child: ShimmerWidget.circular(
                      hight: MediaQuery.of(context).size.height / 32.48, //25
                      width: MediaQuery.of(context).size.width /
                          1.794258373205742, //209
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width / 25), //25
                    child: SmallText(
                        text: AppLocalizations.of(context)!
                            .translate("Choose from the following sources")),
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 40.6, //20
            ),
            Divider(
              height: 0,
              color:
                  themeProvider.isDarkMode ? dividerDarkColor : containerColor,
            ),
            Expanded(
              child: _isLoading
                  ? ShimmerListView(
                      hight: 60, //112
                    )
                  : ListView.builder(
                      controller: _controller,
                      itemCount: _allUsers.length,
                      itemBuilder: (context, index) {
                        return CategoryList(index, themeProvider);
                      }),
            ),
            if (_isLoadMoreRunning == true)
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Center(
                  child: CircularProgressIndicator(color: mainAppColor),
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
    );
  }

  Widget CategoryList(int index, ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 18.75), //20

      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 40.6, //20
          ),
          InkWell(
            onTap: () {
              setState(() {
                OrderUserData.setSourceId(_allUsers[index]["id"] ?? "");
                OrderUserData.setSourceName(_allUsers[index]["name"] ?? "");
              });
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.875,
                  child: SmallText(
                    align: TextAlign.start,
                    text: _allUsers[index]["name"] ?? "",
                    size: MediaQuery.of(context).size.height / 50.75, //14
                    typeOfFontWieght:
                        OrderUserData.getSourceId() == _allUsers[index]["id"]
                            ? 1
                            : 0,
                    color: themeProvider.isDarkMode ? whiteColor : blackColor,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                          visible: OrderUserData.getSourceId() ==
                                  _allUsers[index]["id"]
                              ? true
                              : false,
                          child: Image.asset("assets/images/check.png")),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40.6, //20
          ),
          Divider(
            color: themeProvider.isDarkMode ? dividerDarkColor : containerColor,
            height: 0,
          )
        ],
      ),
    );
  }
}
