// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_local_variable, prefer_final_fields, unused_field, non_constant_identifier_names, prefer_const_constructors_in_immutables, prefer_interpolation_to_compose_strings, use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/server%20error/server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/choosecountry.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class EditEmployeeChooseCountry extends StatefulWidget {
  EditEmployeeChooseCountry({
    Key? key,
  }) : super(key: key);

  @override
  State<EditEmployeeChooseCountry> createState() =>
      _EditEmployeeChooseCountryState();
}

class _EditEmployeeChooseCountryState extends State<EditEmployeeChooseCountry> {
  late FocusNode _searchFoucs;
  final TextEditingController searchController = TextEditingController();

  List<dynamic> _allCountry = [];
  List<dynamic> _searchedResult = [];

  bool _isloading = false;

  bool _isSlect = false;

  Future fetchCountryList() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    final serverError = Provider.of<ServerError>(context, listen: false);
    setState(() {
      _isloading = true;
    });
    final response = await get(
      Uri.parse(Urls.COUNTRIES_URL),
      headers: <String, String>{
        'Accept': 'application/json',
        "Accept-Language": UserData.getUSerLang(),
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${UserData.getUserApiToken()}"
      },
    );
    if (response.statusCode == 200) {
      // print("999999999999999999999999999999999999999999999999999999999999");
      Map<String, dynamic> map = json.decode(response.body);
      _allCountry = map["data"];
      setState(() {
        _isloading = false;
      });
    } else if (response.statusCode == 401) {
      setState(() {
        unauthorizedError.unauthorizedErrors401(context);
        _isloading = false;
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
                text: AppLocalizations.of(context)!.translate("there is error"),
                typeOfFontWieght: 1,
              ),
            );
          });
      setState(() {
        _isloading = false;
      });
    } else if (response.statusCode == 403) {
      print(response.statusCode);
      setState(() {
        erro403.error403(context, response.statusCode);
        _isloading = false;
      });
    } else {
      print(response.statusCode);
      print(response.body);
      setState(() {
        serverError.serverError(context, response.statusCode);
        _isloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fetchCountryList();
    _searchFoucs = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final countryProvider = Provider.of<ChooseCountryData>(context);
    return Container(
      width: MediaQuery.of(context).size.width, //width
      height: MediaQuery.of(context).size.height / 2.03, //40
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MediaQuery.of(context).size.height / 81.2),
            topRight:
                Radius.circular(MediaQuery.of(context).size.height / 81.2)),
        color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
      ),

      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height / 40.6), //20
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
              height: MediaQuery.of(context).size.height / 40.6,
            ),
            SmallText(
              text: AppLocalizations.of(context)!.translate("country"),
              color: themeProvider.isDarkMode ? whiteColor : blackColor,
              size: MediaQuery.of(context).size.height / 50.75, //16
              typeOfFontWieght: 1,
            ),
            SizedBox(
              height:
                  MediaQuery.of(context).size.height / 54.13333333333333, //15,
            ),
            SearchingBar(themeProvider, context),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height / 50.75, //16
            // ),
            Expanded(
                child: _isloading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: searchController.text == ""
                            ? _allCountry.length
                            : _searchedResult.length,
                        itemBuilder: (context, index) {
                          return countryList(
                              index, themeProvider, countryProvider);
                        }))
          ],
        ),
      ),
    );
  }

  Widget countryList(int index, ThemeProvider themeProvider,
      ChooseCountryData countryProvider) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 45.11111111111111, //20
        ),
        InkWell(
          onTap: () {
            setState(() {
              UserData.setEditEmloyeeCountryId(0);

              searchController.text == ""
                  ? UserData.setEditEmloyeeCountryId(_allCountry[index]["id"])
                  : UserData.setEditEmloyeeCountryId(
                      _searchedResult[index]["id"]);

              searchController.text == ""
                  ? UserData.setEditEmloyeeCountryImage(
                      _allCountry[index]["image"])
                  : UserData.setEditEmloyeeCountryImage(
                      _searchedResult[index]["image"]);

              searchController.text == ""
                  ? UserData.setEditEmloyeeCountryName(
                      _allCountry[index]["name"])
                  : UserData.setEditEmloyeeCountryName(
                      _searchedResult[index]["name"]);

              searchController.text == ""
                  ? UserData.setEditEmloyeeCountryCode(
                      _allCountry[index]["code"])
                  : UserData.setEditEmloyeeCountryCode(
                      _searchedResult[index]["code"]);

              countryProvider.setEitCounntryinfor(UserData.getCountryImage());
              countryProvider.editData;
            });
            Navigator.pop(context);
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    themeProvider.isDarkMode ? containerdarkColor : whiteColor,
                radius:
                    MediaQuery.of(context).size.height / 54.13333333333333, //12
                backgroundImage: searchController.text == ""
                    ? NetworkImage(
                        _allCountry[index]["image"],
                      )
                    : NetworkImage(
                        _searchedResult[index]["image"],
                      ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 25, //15
              ),
              SmallText(
                text: searchController.text == ""
                    ? _allCountry[index]["name"]
                    : _searchedResult[index]["name"],
                size:
                    MediaQuery.of(context).size.height / 54.13333333333333, //14
                typeOfFontWieght: searchController.text == ""
                    ? UserData.getEditEmloyeeCountryId() ==
                            _allCountry[index]["id"]
                        ? 1
                        : 0
                    : UserData.getEditEmloyeeCountryId() ==
                            _searchedResult[index]["id"]
                        ? 1
                        : 0,

                color: themeProvider.isDarkMode ? whiteColor : blackColor,
              ),
              SizedBox(
                width: 7, //todo
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 324.8), //2.5
                child: SmallText(
                  text: searchController.text == ""
                      ? "(${_allCountry[index]["code"]})"
                      : "(${_searchedResult[index]["code"]})",
                  size: MediaQuery.of(context).size.height /
                      67.66666666666667, //14

                  color: textGrayColor,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                        visible: searchController.text == ""
                            ? UserData.getEditEmloyeeCountryId() ==
                                    _allCountry[index]["id"]
                                ? true
                                : false
                            : UserData.getEditEmloyeeCountryId() ==
                                    _searchedResult[index]["id"]
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
          height: MediaQuery.of(context).size.height / 45.11111111111111, //20
        ),
        Divider(
          height: 0,
          color: themeProvider.isDarkMode ? dividerDarkColor : containerColor,
        ),
      ],
    );
  }

  Widget SearchingBar(themeProvider, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode
            ? dividerDarkColor
            : SearchingBarlightColor,
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
                hintText: AppLocalizations.of(context)!
                        .translate("search for country") +
                    ' ..',
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
                  setState(() {
                    print('555555555555555555');
                    print(searchController.text);
                  });
                } else if (value.isNotEmpty) {
                  searchCountryApicall(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  searchCountryApicall(String value) async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    final serverError = Provider.of<ServerError>(context, listen: false);
    setState(() {
      _isloading = true;
    });
    final response = await get(
      Uri.parse("${Urls.COUNTRY_SEARCH_URL}${value}"),
      headers: <String, String>{
        'Accept': 'application/json',
        "Accept-Language": UserData.getUSerLang(),
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${UserData.getUserApiToken()}"
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      _searchedResult = map["data"];
      print(_searchedResult.length);
      print(_searchedResult);
      setState(() {
        _isloading = false;
      });
    } else if (response.statusCode == 401) {
      setState(() {
        unauthorizedError.unauthorizedErrors401(context);
        _isloading = false;
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
                text: AppLocalizations.of(context)!.translate("there is error"),
                typeOfFontWieght: 1,
              ),
            );
          });
      setState(() {
        _isloading = false;
      });
    } else if (response.statusCode == 403) {
      print(response.statusCode);
      setState(() {
        erro403.error403(context, response.statusCode);
        _isloading = false;
      });
    } else {
      print(response.statusCode);
      print(response.body);
      setState(() {
        serverError.serverError(context, response.statusCode);
        _isloading = false;
      });
    }
  }
}
