// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, prefer_final_fields, unused_field, unused_local_variable, use_build_context_synchronously, sized_box_for_whitespace

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/server%20error/server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EditEmployeePermissions extends StatefulWidget {
  const EditEmployeePermissions({Key? key}) : super(key: key);

  @override
  State<EditEmployeePermissions> createState() =>
      _EditEmployeePermissionsState();
}

class _EditEmployeePermissionsState extends State<EditEmployeePermissions> {
  bool _isloading = false;

  http.Client clientApi = http.Client();

  List<dynamic> _allPermissions = [];

  Future fetchPermissionList() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    final serverError = Provider.of<ServerError>(context, listen: false);
    setState(() {
      _isloading = true;
    });
    final response = await clientApi.get(
      Uri.parse(Urls.ADD_Role_URL),
      headers: <String, String>{
        'Accept': 'application/json',
        "Accept-Language": UserData.getUSerLang(),
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${UserData.getUserApiToken()}"
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      _allPermissions = map["data"];
      setState(() {
        _isloading = false;
      });
    } else if (response.statusCode == 401) {
      unauthorizedError.unauthorizedErrors401(context);
      setState(() {
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
      setState(() {
        erro403.error403(context, response.statusCode);
        _isloading = false;
      });
    } else {
      setState(() {
        serverError.serverError(context, response.statusCode);
        _isloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPermissionList();
  }

  @override
  void dispose() {
    super.dispose();
    clientApi.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height / 1.888372093023256, //430
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
            height: MediaQuery.of(context).size.height / 54.13333333333333, //15
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
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    MediaQuery.of(context).size.width / 20.83333333333333), //18
            child: SmallText(
              text: AppLocalizations.of(context)!.translate("permissions"),
              color: themeProvider.isDarkMode ? whiteColor : blackColor,
              size: MediaQuery.of(context).size.height / 50.75, //16
              typeOfFontWieght: 1,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 162.4, //5
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 25), //25
            child: SmallText(
                text: AppLocalizations.of(context)!
                    .translate("Choose the employee's permissions")),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40.6, //20
          ),
          Divider(
            height: 0,
            color: themeProvider.isDarkMode ? dividerDarkColor : containerColor,
          ),
          Expanded(
            child: _isloading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: _allPermissions.length,
                    itemBuilder: (context, index) {
                      return permissionsList(index, themeProvider);
                    }),
          ),
        ],
      ),
    );
  }

  Widget permissionsList(int index, ThemeProvider themeProvider) {
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
                UserData.setEditEmployeePermissionsId(
                    _allPermissions[index]["id"]);

                // UserData.setEditEmployeePermissionsGuardName(
                //     _allPermissions[index]["guard_name"]);

                UserData.setEditEmployeePermissionsName(
                    _allPermissions[index]["name"]);
              });
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.875,
                  child: SmallText(
                    align: TextAlign.start,
                    text: _allPermissions[index]["name"] ?? "",
                    size: MediaQuery.of(context).size.height / 50.75, //14
                    typeOfFontWieght: UserData.getEditEmployeePermissionsId() ==
                            _allPermissions[index]["id"]
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
                          visible: UserData.getEditEmployeePermissionsId() ==
                                  _allPermissions[index]["id"]
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
