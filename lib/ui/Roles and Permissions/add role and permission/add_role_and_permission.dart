// ignore_for_file: unused_local_variable, prefer_final_fields, , , prefer_const_constructors, unnecessary_string_interpolations, unused_element, avoid_print, use_build_context_synchronously, sized_box_for_whitespace, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/custom_container/custom_container.dart';
import 'package:cayan/custom_widgets/customtextformfield/custom_text_form_feild.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer%20list%20view/shimmer_list_view.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/roles%20and%20perimssions%20api%20error/roles_and_perimission_api_errors.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/add_roles_and_perimisson_provider.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Roles%20and%20Permissions/add%20role%20and%20permission/profiles%20bottom%20sheet/profiles_bottom_sheet.dart';
import 'package:cayan/ui/Roles%20and%20Permissions/roles%20and%20permissions%20screen/roles_permissions_screen.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AddRoleAndPermission extends StatefulWidget {
  const AddRoleAndPermission({Key? key}) : super(key: key);

  @override
  State<AddRoleAndPermission> createState() => _AddRoleAndPermissionState();
}

class _AddRoleAndPermissionState extends State<AddRoleAndPermission> {
  late FocusNode _rolesandPermissionFouceName;

  http.Client clientApi = http.Client();

  TextEditingController _rolesandPermissioneName = TextEditingController();

  bool _isLoading = false;

  List listOfKeys = [];

  Map<String, dynamic> _allUsers = {};

  final formKey = GlobalKey<FormState>();

  _getAllRolesAndPermissions() async {
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
          "${Urls.GET_ALL_PERMISSIONS}",
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

        listOfKeys = map["data"].keys.toList();
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
    _rolesandPermissionFouceName = FocusNode();

    _getAllRolesAndPermissions();
  }

  @override
  void dispose() {
    super.dispose();

    _rolesandPermissionFouceName.unfocus();

    clientApi.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NetworkIndicator(
      child: DraggableScrollableSheet(
        initialChildSize: .955,
        //  isValidate ? 0.94 : 0.8608374384236453, //699 584
        maxChildSize: 0.955,
        // isValidate ? 0.94 : 0.8608374384236453,
        minChildSize: 0.5,
        builder: (context, scrollController) => GestureDetector(
          onTap: () {
            _rolesandPermissionFouceName.unfocus();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      MediaQuery.of(context).size.height / 81.2),
                  topRight: Radius.circular(
                      MediaQuery.of(context).size.height / 81.2)),
              color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
            ),
            child: Form(
              key: formKey,
              child: ListView(
                controller: scrollController,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            54.13333333333333, //15
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 9.375, //40
                          height:
                              MediaQuery.of(context).size.height / 162.4, //5
                          decoration: BoxDecoration(
                            color: themeProvider.isDarkMode
                                ? dividerDarkColor
                                : containerColor,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height / 162.4),
                          ), //5
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40.6, //20
                      ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 25),
                              child: ShimmerWidget.circular(
                                hight:
                                    MediaQuery.of(context).size.height / 32.48,
                                width: MediaQuery.of(context).size.width / 3,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          23.4375), //16
                              child: BigText(
                                text: AppLocalizations.of(context)!
                                    .translate("create new role"),
                                typeOfFontWieght: 1,
                                size: MediaQuery.of(context).size.height /
                                    50.75, //16
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            135.3333333333333, //6
                      ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 25),
                              child: ShimmerWidget.circular(
                                hight: MediaQuery.of(context).size.height /
                                    32.48, //25
                                width: MediaQuery.of(context).size.width /
                                    1.794258373205742, //209
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          23.4375), //16
                              child: SmallText(
                                text: AppLocalizations.of(context)!.translate(
                                  "Fill in the following data to create a new role",
                                ),
                                size: MediaQuery.of(context).size.height /
                                    58, //14
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40.6, //20
                      ),
                      Divider(
                        color: themeProvider.isDarkMode
                            ? Color(0xff363637)
                            : containerColor,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 81.2, //10
                      ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        54.13333333333333, //15
                                  ),
                                  ShimmerWidget.circular(
                                    hight: MediaQuery.of(context).size.height /
                                        32.48, //25
                                    width: MediaQuery.of(context).size.width /
                                        7.5, //50
                                    shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height /
                                              81.2 //10
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        81.2,
                                  )
                                ],
                              ),
                            )
                          : _dimenssion(themeProvider, "role name"),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: ShimmerWidget.circular(
                                  hight: MediaQuery.of(context).size.height /
                                      18.04444444444444, //45
                                  width: MediaQuery.of(context).size.width,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height /
                                              81.2))),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.height /
                                          50.75), //16
                              child: CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _rolesandPermissionFouceName,
                                controller: _rolesandPermissioneName,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl: "assets/images/perm.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: AppLocalizations.of(context)!
                                    .translate("role name"),
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .translate("name is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _rolesandPermissionFouceName.hasFocus ==
                                        true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _rolesandPermissionFouceName.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _rolesandPermissionFouceName.unfocus(),
                              ),
                            ),
                      _isLoading
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width /
                                          18.75),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        54.13333333333333, //15
                                  ),
                                  ShimmerWidget.circular(
                                    hight: MediaQuery.of(context).size.height /
                                        32.48, //25
                                    width: MediaQuery.of(context).size.width /
                                        7.5, //50
                                    shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height /
                                              81.2 //10
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        81.2,
                                  )
                                ],
                              ),
                            )
                          : _dimenssion(themeProvider, "permission category"),
                      _isLoading
                          ? Container(
                              height: MediaQuery.of(context).size.height /
                                  1.691666666666667, //480
                              child: ShimmerListView(
                                  hight: MediaQuery.of(context).size.height /
                                      13.53333333333333 //60
                                  ),
                            )
                          : Container(
                              // color: mainAppColor,
                              // height: (_allUsers.length + 1) *
                              //     (MediaQuery.of(context).size.height / 11.9) //50
                              // ,
                              child: buildList(themeProvider),
                            ),
                      _isLoading
                          ? SizedBox(
                              height: 0,
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height / 40.6,
                            ),
                      _saveAndCancledButton(
                        themeProvider,
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _dimenssion(ThemeProvider themeProvider, String name) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 54.13333333333333, //15
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 23.4375), //16
          child: SmallText(
            text: AppLocalizations.of(context)!.translate("$name"),
            color: themeProvider.isDarkMode ? whiteColor : blackColor,
            size: MediaQuery.of(context).size.height / 62.46153846153846, //13
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 54.13333333333333, //15
        ),
      ],
    );
  }

  Widget buildList(ThemeProvider themeProvider) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _allUsers.length,
        itemBuilder: (contex, index) {
          return ListviewBody(themeProvider, index);
        });
  }

  Widget ListviewBody(ThemeProvider themeProvider, int index) {
    return _isLoading
        ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 18.75),
            child: ShimmerWidget.circular(
                hight:
                    MediaQuery.of(context).size.height / 18.04444444444444, //45
                width: MediaQuery.of(context).size.width,
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height / 81.2))),
          )
        : InkWell(
            onTap: () {
              setState(() {
                _rolesandPermissionFouceName.unfocus();
              });
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ProfilesBottomSheet(
                      profilesdata: _allUsers[listOfKeys[index]],
                      catogryName: listOfKeys[index],
                    ),
                  );
                },
              );
            },
            child: CustomContainer(
              color: themeProvider.isDarkMode ? Color(0xff292828) : whiteColor,
              hasHorizontalMargin: true,
              horizontalMargin: MediaQuery.of(context).size.height / 50.75, //16
              verticalMargin: 10,
              hasVerticalMargin: false,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 16.24, //50
              borderRadius: MediaQuery.of(context).size.height / 81.2, //10
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 23.4375, //16
                  ),
                  Image.asset(
                    "assets/images/perm.png",
                    color: hintColor,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 75, //5
                  ),
                  SmallText(
                    text: listOfKeys[index].toString(),
                    color: hintColor,
                    size: MediaQuery.of(context).size.height / 58,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        themeProvider.isDarkMode
                            ? Image.asset("assets/images/downdark.png",
                                color: hintColor)
                            : Image.asset(
                                "assets/images/down.png",
                                color: hintColor,
                              ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 31.25, //12
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  _saveAndCancledButton(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _isLoading
              ? ShimmerWidget.circular(
                  hight: MediaQuery.of(context).size.height /
                      18.04444444444444, //45
                  width: MediaQuery.of(context).size.width /
                      2.272727272727273, //165
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                )
              : CustomButton(
                  height: MediaQuery.of(context).size.height /
                      18.04444444444444, //45
                  width: MediaQuery.of(context).size.width /
                      2.272727272727273, //165
                  btnLbl: "حفظ",
                  onPressedFunction: addRoleAndPerimission,
                  btnColor: mainAppColor,
                  btnStyle: TextStyle(color: blackColor),
                  horizontalMargin: 0,
                  verticalMargin: 0,
                  lightBorderColor: mainAppColor,
                  darkBorderColor: mainAppColor,
                  addtionalWidgit: false,
                  child: Center(
                    child: SmallText(
                      text: AppLocalizations.of(context)!.translate("add"),
                      color: themeProvider.isDarkMode ? blackColor : blackColor,
                      typeOfFontWieght: 1,
                    ),
                  ),
                ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 37.5, //10,
          ),
          _isLoading
              ? ShimmerWidget.circular(
                  hight: MediaQuery.of(context).size.height /
                      18.04444444444444, //45
                  width: MediaQuery.of(context).size.width /
                      2.272727272727273, //165
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                )
              : CustomButton(
                  height: MediaQuery.of(context).size.height /
                      18.04444444444444, //45
                  width: MediaQuery.of(context).size.width /
                      2.272727272727273, //165
                  btnLbl: "الغاء",
                  onPressedFunction: () {
                    Navigator.pop(context);
                  },
                  btnColor:
                      themeProvider.isDarkMode ? Color(0xff292828) : whiteColor,
                  btnStyle: TextStyle(color: blackColor),
                  horizontalMargin: 0,
                  verticalMargin: 0,
                  lightBorderColor: blackColor,
                  darkBorderColor: Color(0xff292828),
                  addtionalWidgit: false,
                  child: Center(
                    child: SmallText(
                      text: AppLocalizations.of(context)!.translate("cancel"),
                      color: themeProvider.isDarkMode ? whiteColor : blackColor,
                      typeOfFontWieght: 1,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  addRoleAndPerimission() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final storError =
        Provider.of<RolesAndPerimissionApiError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    final _addRolesAndPerimissonsProvider =
        Provider.of<AddRolesAndPerimissionsProvider>(context, listen: false);

    if (formKey.currentState!.validate()) {
      final body = {
        "name": _rolesandPermissioneName.text,
        "requested_permissions": _addRolesAndPerimissonsProvider.categoryID
      };

      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });

      final response = await post(
        Uri.parse(Urls.ADD_Role_URL),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "Accept-Language": UserData.getUSerLang(),
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        setState(() {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => RolesAndPermissionScreen()));
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: successOperation(
                      operationName: "add new Perimission successfully"),
                );
              });
        });
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        unauthorizedError.unauthorizedErrors401(context);
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 422) {
        var _body = jsonDecode(response.body);
        setState(() {
          storError.rolesAndPerimissionStoer442(context, _body);
          _isLoading = false;
        });
      } else if (response.statusCode == 403) {
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
    }
  }
}
