// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_field, unused_local_variable, use_build_context_synchronously, unused_element, prefer_if_null_operators, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, unnecessary_string_interpolations, unused_catch_clause, empty_catches

import 'dart:convert';
import 'dart:io';
import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/customtextformfield/custom_text_form_feild.dart';
import 'package:cayan/custom_widgets/open%20image/open_image.dart';
import 'package:cayan/custom_widgets/safe_area/page_container.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/edit%20employee%20error/edit_empolyee_error.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/server%20error/server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/control%20panel/control_panel.dart';
import 'package:cayan/shared_preferences/follow%20source%20data/follow_source_data.dart';
import 'package:cayan/shared_preferences/follow_prefrmance/follow_prefromance_data.dart';
import 'package:cayan/shared_preferences/order%20user%20data/order_user_data.dart';
import 'package:cayan/shared_preferences/user_data.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Edit/change%20language%20bottom%20sheet/change_language.dart';
import 'package:cayan/ui/Edit/change%20password%20screen/change_password_screen.dart';
import 'package:cayan/ui/Edit/edit%20employee%20choose%20country/user_country.dart';
import 'package:cayan/ui/drawer/navigation_drawer.dart';
import 'package:cayan/ui/edit%20navigation%20bar/edit_navigation_bar.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  bool _isloading = false;

  bool _isSystemPhotoLoading = false;

  http.Client clientApi = http.Client();

  File? imageSend;
  int imageChoosen = 0;

  File? systemPhot;
  int SystemPhotoChoosen = 0;

  late FocusNode _userFouceName;
  late FocusNode _userFocusEmail;
  late FocusNode _userFoucePhone;

  TextEditingController _userName = TextEditingController();
  TextEditingController _userEmail = TextEditingController();
  TextEditingController _userPhoneNumber = TextEditingController();

  String name = '';
  String email = '';
  String phone = '';

  final formKey = GlobalKey<FormState>();
  bool formError = false;

  bool nameEerro = false;
  bool emailEerro = false;
  bool phoneEerro = false;
  double containerHight = 0;

  Map<String, dynamic> _userData = {};
  Map<String, dynamic> _systemPhotoUrl = {};

  Future fetchUserData() async {
    try {
      final unauthorizedError =
          Provider.of<UnauthorizedError>(context, listen: false);

      final erro403 = Provider.of<Error403>(context, listen: false);

      final homeServerError =
          Provider.of<HomeServerError>(context, listen: false);

      setState(() {
        _isloading = true;
      });

      final response = await clientApi.get(
        Uri.parse(Urls.USER_URL),
        headers: <String, String>{
          'Accept': 'application/json',
          "Accept-Language": UserData.getUSerLang(),
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        },
      );
      if (response.statusCode == 200) {
        _userData = json.decode(response.body);

        setState(() {
          _userName.text = _userData["data"]["name"];

          _userEmail.text = _userData["data"]["email"];

          _userPhoneNumber.text = _userData["data"]["phone"];

          UserInformation.setUserCountryId(_userData["data"]["country"]["id"]);

          UserInformation.setUsercountryCode(
              _userData["data"]["country"]["code"]);

          UserInformation.setUsercountryImage(
              _userData["data"]["country"]["image"]);

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
                  text:
                      AppLocalizations.of(context)!.translate("there is error"),
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
          homeServerError.serverError(context, response.statusCode);
          _isloading = false;
        });
      }
      setState(() {
        _isloading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  fetchSystemPhoto() async {
    try {
      final unauthorizedError =
          Provider.of<UnauthorizedError>(context, listen: false);

      final erro403 = Provider.of<Error403>(context, listen: false);

      final homeServerError =
          Provider.of<HomeServerError>(context, listen: false);

      setState(() {
        _isSystemPhotoLoading = true;
      });
      final response = await clientApi.get(
        Uri.parse("${Urls.GET_SYSTEM_PHOTO_URL}1"),
        headers: <String, String>{
          'Accept': 'application/json',
          "Accept-Language": UserData.getUSerLang(),
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        },
      );

      if (response.statusCode == 200) {
        _systemPhotoUrl = json.decode(response.body);

        setState(() {
          _isSystemPhotoLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          unauthorizedError.unauthorizedErrors401(context);
          _isSystemPhotoLoading = false;
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
                  text:
                      AppLocalizations.of(context)!.translate("there is error"),
                  typeOfFontWieght: 1,
                ),
              );
            });
        setState(() {
          _isSystemPhotoLoading = false;
        });
      } else if (response.statusCode == 403) {
        setState(() {
          erro403.error403(context, response.statusCode);
          _isSystemPhotoLoading = false;
        });
      } else {
        setState(() {
          homeServerError.serverError(context, response.statusCode);
          _isSystemPhotoLoading = false;
        });
      }
      setState(() {
        _isSystemPhotoLoading = false;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();

    fetchUserData();

    fetchSystemPhoto();

    _userFouceName = FocusNode();
    _userFocusEmail = FocusNode();
    _userFoucePhone = FocusNode();

    OrderUserData.setOrderStatusIdForSearch(0); //(عشان الفلتر بتاع الطلبات )
    OrderUserData.setOrderStatusNameForSearch(""); //(عشان الفلتر بتاع الطلبات )
    OrderUserData.setOrderDaySearch(""); //(عشان الفلتر بتاع الطلبات )
    OrderUserData.setOrderHistoryFromSearch(""); //(عشان الفلتر بتاع الطلبات )
    OrderUserData.setOrderHistoryToSearch(""); //(عشان الفلتر بتاع الطلبات )

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

    _userFouceName.dispose();

    _userFocusEmail.dispose();

    _userFoucePhone.dispose();

    // clientApi.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NetworkIndicator(
      child: PageContainer(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _userFocusEmail.unfocus();
              _userFouceName.unfocus();
              _userFoucePhone.unfocus();
            });
          },
          child: Scaffold(
            backgroundColor:
                themeProvider.isDarkMode ? containerdarkColor : whiteColor,
            appBar: AppBar(
              backgroundColor:
                  themeProvider.isDarkMode ? containerdarkColor : whiteColor,
              elevation: 0,
              centerTitle: true,
              title: BigText(
                typeOfFontWieght: 1,
                text: AppLocalizations.of(context)!.translate("Settings"),
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
            body: Form(
              key: formKey,
              child: ListView(
                children: [
                  _isloading || _isSystemPhotoLoading
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height:
                              MediaQuery.of(context).size.height / 11.6, //70
                          color: themeProvider.isDarkMode
                              ? blackColor
                              : Color(0xffF9F9F9),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height:
                              MediaQuery.of(context).size.height / 11.6, //70
                          color: themeProvider.isDarkMode
                              ? blackColor
                              : Color(0xffF9F9F9),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width /
                                    25), //15
                            child: Row(
                              children: [
                                SmallText(
                                  text: AppLocalizations.of(context)!
                                      .translate("prfile setting"),
                                  size: MediaQuery.of(context).size.height /
                                      58, //14
                                  typeOfFontWieght: 1,
                                  color: themeProvider.isDarkMode
                                      ? whiteColor
                                      : blackColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height / 32.48, //25
                        ),
                        _isloading || _isSystemPhotoLoading
                            ? Column(
                                children: [
                                  Center(
                                    child: ShimmerWidget.circular(
                                        hight:
                                            MediaQuery.of(context).size.height /
                                                9.552941176470588,
                                        //85
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4.411764705882353 //85
                                        ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        81.2, //10
                                  ),
                                  ShimmerWidget.circular(
                                    width: MediaQuery.of(context).size.width /
                                        3.125, //120
                                    hight: MediaQuery.of(context).size.height /
                                        40.6, //20
                                    shapeBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.height /
                                                162.4 //5
                                            )),
                                  )
                                ],
                              )
                            : _userPhoto(themeProvider),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 58, //14
                        ),
                        _isloading || _isSystemPhotoLoading
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        27.06666666666667, //15
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
                              )
                            : _dimenssion(themeProvider, "name"),
                        _isloading || _isSystemPhotoLoading
                            ? ShimmerWidget.circular(
                                hight: MediaQuery.of(context).size.height /
                                    18.04444444444444, //45
                                width: MediaQuery.of(context).size.width,
                                shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height /
                                          81.2),
                                ),
                              )
                            : CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _userFouceName,
                                controller: _userName,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl: "assets/images/userac.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: _userData["data"]["name"],
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      formError = true;
                                      nameEerro = true;
                                      containerHight =
                                          MediaQuery.of(context).size.height /
                                              1.592156862745098; //510
                                    });
                                    return AppLocalizations.of(context)!
                                        .translate("name is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _userFouceName.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _userFouceName.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _userFouceName.unfocus(),
                              ),
                        _isloading || _isSystemPhotoLoading
                            ? Column(
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
                              )
                            : _dimenssion(themeProvider, "Email"),
                        _isloading || _isSystemPhotoLoading
                            ? ShimmerWidget.circular(
                                hight: MediaQuery.of(context).size.height /
                                    18.04444444444444, //45
                                width: MediaQuery.of(context).size.width,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))
                            : CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _userFocusEmail,
                                controller: _userEmail,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl: "assets/images/mailac.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: _userData["data"]["email"],
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      formError = true;
                                      emailEerro = true;
                                      if (nameEerro == true &&
                                          emailEerro == true) {
                                        containerHight =
                                            MediaQuery.of(context).size.height /
                                                1.489908256880734; //545
                                      } else {
                                        containerHight =
                                            MediaQuery.of(context).size.height /
                                                1.592156862745098; //510;
                                      }
                                    });
                                    return AppLocalizations.of(context)!
                                        .translate("email is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _userFocusEmail.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _userFocusEmail.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _userFocusEmail.unfocus(),
                              ),
                        _isloading || _isSystemPhotoLoading
                            ? Column(
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
                              )
                            : _dimenssion(themeProvider, "phone_No"),
                        _isloading || _isSystemPhotoLoading
                            ? ShimmerWidget.circular(
                                hight: MediaQuery.of(context).size.height /
                                    18.04444444444444, //45
                                width: MediaQuery.of(context).size.width,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.height /
                                            81.2)))
                            : CustomTextField(
                                cursorColor: mainAppColor,
                                readOnly: false,
                                enabled: true,
                                maxLine: 1,
                                focusNode: _userFoucePhone,
                                controller: _userPhoneNumber,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: "رقم الجوال",
                                ispreffix: true,
                                ispreffixImage: false,
                                preffixWidget: _chooseCountry(
                                  themeProvider,
                                ),
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: _userData["data"]["phone"],
                                inputData: TextInputType.phone,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      formError = true;
                                      phoneEerro = true;
                                      if (nameEerro == true &&
                                          emailEerro == true &&
                                          phoneEerro == true) {
                                        containerHight =
                                            MediaQuery.of(context).size.height /
                                                1.412173913043478; //575;
                                      } else if (phoneEerro == true &&
                                          emailEerro == true) {
                                        containerHight =
                                            MediaQuery.of(context).size.height /
                                                1.489908256880734; //545
                                      } else if (phoneEerro == true &&
                                          nameEerro == true) {
                                        containerHight =
                                            MediaQuery.of(context).size.height /
                                                1.489908256880734; //545
                                      } else {
                                        containerHight =
                                            MediaQuery.of(context).size.height /
                                                1.592156862745098; //510;
                                      }
                                    });
                                    return AppLocalizations.of(context)!
                                        .translate("phone number is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _userFoucePhone.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _userFoucePhone.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _userFoucePhone.unfocus(),
                              ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height / 40.6, //20
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 81.2,
                    color: themeProvider.isDarkMode
                        ? blackColor
                        : Color(0xffF9F9F9),
                  ), //10
                  _isloading || _isSystemPhotoLoading
                      ? ShimmerWidget.rectangular(
                          width: MediaQuery.of(context).size.width,
                          hight: MediaQuery.of(context).size.height /
                              13.53333333333333)
                      : InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangePasswordScreen(),
                              ),
                            );
                            setState(() {
                              _userFocusEmail.unfocus();
                              _userFouceName.unfocus();
                              _userFoucePhone.unfocus();
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height /
                                13.53333333333333, //60
                            color: themeProvider.isDarkMode
                                ? containerdarkColor
                                : whiteColor,
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 18.75,
                                ),
                                Image.asset("assets/images/passac.png"),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      37.5, //10
                                ),
                                SmallText(
                                  text: AppLocalizations.of(context)!
                                      .translate("change_password"),
                                  size: MediaQuery.of(context).size.height / 58,
                                  color: themeProvider.isDarkMode
                                      ? whiteColor
                                      : blackColor,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: textGrayColor,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                81.2,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                18.75,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                  _isloading || _isSystemPhotoLoading
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height:
                              MediaQuery.of(context).size.height / 11.6, //70
                          color: themeProvider.isDarkMode
                              ? blackColor
                              : Color(0xffF9F9F9),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height:
                              MediaQuery.of(context).size.height / 12.687, //64
                          color: themeProvider.isDarkMode
                              ? blackColor
                              : Color(0xffF9F9F9),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width /
                                    25), //15
                            child: Row(
                              children: [
                                SmallText(
                                  text: AppLocalizations.of(context)!
                                      .translate("system mangement"),
                                  size: MediaQuery.of(context).size.height /
                                      58, //14
                                  typeOfFontWieght: 1,
                                  color: themeProvider.isDarkMode
                                      ? whiteColor
                                      : blackColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height /
                        27.06666666666667, //30
                  ),
                  _isloading || _isSystemPhotoLoading
                      ? Column(
                          children: [
                            Center(
                              child: ShimmerWidget.circular(
                                  hight: MediaQuery.of(context).size.height /
                                      9.552941176470588,
                                  //85
                                  width: MediaQuery.of(context).size.width /
                                      4.411764705882353 //85
                                  ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  81.2, //10
                            ),
                            ShimmerWidget.circular(
                              width: MediaQuery.of(context).size.width /
                                  3.125, //120
                              hight: MediaQuery.of(context).size.height /
                                  40.6, //20
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height /
                                          162.4 //5
                                      )),
                            )
                          ],
                        )
                      : _systemPhoto(themeProvider),

                  _isloading || _isSystemPhotoLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 25),
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height /
                                    20.3, //20
                              ),
                              ShimmerWidget.circular(
                                  hight: MediaQuery.of(context).size.height /
                                      18.04444444444444, //45
                                  width: MediaQuery.of(context).size.width,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height /
                                              81.2))),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  20.3, //20
                            ),
                            Divider(
                              height: 0,
                              color: themeProvider.isDarkMode
                                  ? dividerDarkColor
                                  : containerColor,
                              endIndent: MediaQuery.of(context).size.width / 25,
                              indent: MediaQuery.of(context).size.width / 25,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  46.4, //17.5
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      18.75, //15
                                ),
                                Image.asset("assets/images/dark.png"),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      46.875, //8
                                ),
                                SmallText(
                                  size: MediaQuery.of(context).size.height /
                                      58, //14
                                  text: AppLocalizations.of(context)!
                                      .translate("night mode"),
                                  color: themeProvider.isDarkMode
                                      ? whiteColor
                                      : blackColor,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                9.375, //40
                                        height:
                                            MediaQuery.of(context).size.height /
                                                32.48, //25
                                        child: Switch.adaptive(
                                            activeColor: mainAppColor,
                                            splashRadius: 0,
                                            value: themeProvider.isDarkMode,
                                            onChanged: (value) {
                                              setState(() {
                                                _userFocusEmail.unfocus();
                                                _userFouceName.unfocus();
                                                _userFoucePhone.unfocus();
                                              });
                                              themeProvider.changeTheme(value);
                                              value == true
                                                  ? UserData.setUserMode("1")
                                                  : UserData.setUserMode("");
                                            }),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                25, //15
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  46.4, //17.5
                            ),
                          ],
                        ),
                  _isloading || _isSystemPhotoLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 25),
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height /
                                    162.4, //20
                              ),
                              ShimmerWidget.circular(
                                  hight: MediaQuery.of(context).size.height /
                                      18.04444444444444, //45
                                  width: MediaQuery.of(context).size.width,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.height /
                                              81.2))),
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            setState(() {
                              _userFocusEmail.unfocus();
                              _userFouceName.unfocus();
                              _userFoucePhone.unfocus();
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
                                    child: ChangeLanguage(),
                                  );
                                });
                          },
                          child: Column(
                            children: [
                              Divider(
                                height: 0,
                                color: themeProvider.isDarkMode
                                    ? dividerDarkColor
                                    : containerColor,
                                endIndent:
                                    MediaQuery.of(context).size.width / 25,
                                indent: MediaQuery.of(context).size.width / 25,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height /
                                    46.4, //17.5
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        18.75, //15
                                  ),
                                  Image.asset("assets/images/flag.png"),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        46.875, //8
                                  ),
                                  SmallText(
                                    size: MediaQuery.of(context).size.height /
                                        58, //14
                                    text: AppLocalizations.of(context)!
                                        .translate("language"),
                                    color: themeProvider.isDarkMode
                                        ? whiteColor
                                        : blackColor,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: textGrayColor,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              81.2, //10
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              18.75, //20
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height /
                          27.06666666666667 //30
                      ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height /
                        27.06666666666667, //64
                    color: themeProvider.isDarkMode
                        ? blackColor
                        : Color(0xffF9F9F9),
                  ),

                  _isloading || _isSystemPhotoLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 25),
                          child: ShimmerWidget.circular(
                            hight: MediaQuery.of(context).size.height /
                                18.04444444444444, //45
                            width: MediaQuery.of(context).size.width,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height / 81.2),
                            ),
                          ),
                        )
                      : Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height / 16.24,
                              color: themeProvider.isDarkMode
                                  ? blackColor
                                  : Color(0xffF9F9F9),
                            ),
                            CustomButton(
                              width: MediaQuery.of(context).size.width /
                                  1.093294460641399, //343
                              height: MediaQuery.of(context).size.height /
                                  16.24, //50

                              btnLbl: "التالي",
                              onPressedFunction: userLogIn,
                              btnColor: mainAppColor,
                              btnStyle: Theme.of(context).textTheme.button!,
                              horizontalMargin: 0,
                              verticalMargin: 0,
                              lightBorderColor: mainAppColor,
                              darkBorderColor: mainAppColor,
                              addtionalWidgit: true,
                              child: Center(
                                child: SmallText(
                                  text: AppLocalizations.of(context)!
                                      .translate("save edits"),
                                  color: blackColor,
                                  typeOfFontWieght: 1,
                                  size: MediaQuery.of(context).size.height /
                                      58, //14
                                ),
                              ),
                            ),
                          ],
                        ),
                  Container(
                    height: MediaQuery.of(context).size.height /
                        27.06666666666667 //30
                    ,
                    width: MediaQuery.of(context).size.width,
                    color: themeProvider.isDarkMode
                        ? blackColor
                        : Color(0xffF9F9F9),
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
              horizontal: MediaQuery.of(context).size.width / 75),
          child: SmallText(
            text: AppLocalizations.of(context)!.translate("$name"),
            color: themeProvider.isDarkMode ? whiteColor : blackColor,
            size: MediaQuery.of(context).size.height / 62.46153846153846, //13
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 56, //14.5
        ),
      ],
    );
  }

  void openGallery() => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => OpenImage(
            imageSend: imageSend != null ? imageSend : null,
            userImage: _userData["data"]["image"],
          )));

  _userPhoto(ThemeProvider themeProvider) {
    return Column(children: [
      Center(
        child: InkWell(
          onTap: openGallery,
          child: ClipOval(
            child: CircleAvatar(
              backgroundColor:
                  themeProvider.isDarkMode ? containerdarkColor : whiteColor,
              radius: MediaQuery.of(context).size.height / 20.3, // 40 todo
              child: Container(
                height:
                    MediaQuery.of(context).size.height / 9.552941176470588, //85
                width:
                    MediaQuery.of(context).size.width / 4.411764705882353, //85
                child: imageSend != null
                    ? Image.file(
                        imageSend!,
                        fit: BoxFit.cover,
                      )
                    : Image.network(_userData["data"]["image"],
                        fit: BoxFit.cover, loadingBuilder:
                            (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return ShimmerWidget.circular(
                            hight:
                                MediaQuery.of(context).size.height / 11.6, //70
                            width: MediaQuery.of(context).size.width /
                                5.357142857142857 //70
                            );
                      }),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 162.4, //5
      ),
      InkWell(
        onTap: () {
          pickImage();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/changepic.png"),
            SizedBox(
              width: MediaQuery.of(context).size.width / 62.5, //6
            ),
            Text(
              AppLocalizations.of(context)!.translate("change profile image"),
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: mainAppColor,
                  fontSize: MediaQuery.of(context).size.height /
                      67.66666666666667, //12
                  fontFamily: "RB"),
            ),
          ],
        ),
      )
    ]);
  }

  Future pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final ImageTemporary = File(image.path);
      setState(() {
        imageSend = ImageTemporary;
        imageChoosen = 1;
      });
    } on PlatformException catch (e) {}
  }

  void openSystemPhoto() => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => OpenImage(
            imageSend: systemPhot != null ? systemPhot : null,
            userImage: _systemPhotoUrl["data"]["image"],
          )));
  _systemPhoto(ThemeProvider themeProvider) {
    return Column(children: [
      Center(
        child: InkWell(
          onTap: openSystemPhoto,
          child: ClipOval(
            child: CircleAvatar(
              backgroundColor:
                  themeProvider.isDarkMode ? containerdarkColor : whiteColor,
              radius: MediaQuery.of(context).size.height / 20.3, // 40 todo
              child: Container(
                height:
                    MediaQuery.of(context).size.height / 9.552941176470588, //85
                width:
                    MediaQuery.of(context).size.width / 4.411764705882353, //85
                child: systemPhot != null
                    ? Image.file(
                        systemPhot!,
                        fit: BoxFit.cover,
                      )
                    : Image.network(_systemPhotoUrl["data"]["image"],
                        fit: BoxFit.cover, loadingBuilder:
                            (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return ShimmerWidget.circular(
                            hight:
                                MediaQuery.of(context).size.height / 11.6, //70
                            width: MediaQuery.of(context).size.width /
                                5.357142857142857 //70
                            );
                      }),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 135.3333333333333, //6
      ),
      InkWell(
        onTap: () {
          pickSystemImage();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/changepic.png"),
            SizedBox(
              width: MediaQuery.of(context).size.width / 62.5, //6
            ),
            Text(
              AppLocalizations.of(context)!.translate("change system image"),
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: mainAppColor,
                  fontSize: MediaQuery.of(context).size.height /
                      67.66666666666667, //12
                  fontFamily: "RB"),
            ),
          ],
        ),
      )
    ]);
  }

  Future pickSystemImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final ImageTemporary = File(image.path);
      setState(() {
        systemPhot = ImageTemporary;
        SystemPhotoChoosen = 1;
      });
    } on PlatformException catch (e) {}
  }

  _chooseCountry(
    ThemeProvider themeProvider,
  ) {
    return InkWell(
      onTap: () async {
        setState(() {
          _userFocusEmail.unfocus();
          _userFouceName.unfocus();
          _userFoucePhone.unfocus();
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: UserCountry(),
                );
              }).then((value) {
            setState(() {});
          });
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 23.4375, //16,
          ),
          CircleAvatar(
              backgroundColor:
                  themeProvider.isDarkMode ? containerdarkColor : whiteColor,
              radius:
                  MediaQuery.of(context).size.height / 54.13333333333333, //12
              backgroundImage:
                  NetworkImage(UserInformation.getUsercountryImage())),
          SizedBox(
            width: MediaQuery.of(context).size.width / 75, //5,
          ),
          SmallText(
            text: UserInformation.getUsercountryCode(),
            typeOfFontWieght: 1,
            size: MediaQuery.of(context).size.height / 58, //14
            color: themeProvider.isDarkMode ? whiteColor : blackColor,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 65.78947368421053, //5.7
          ),
          themeProvider.isDarkMode
              ? Image.asset("assets/images/downdark.png")
              : Image.asset("assets/images/down.png"),
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
            child: SmallText(
              text: "|",
              size: MediaQuery.of(context).size.height / 45.11111111111111, //18
              color: containerColor,
            ),
          )
        ],
      ),
    );
  }

  userLogIn() async {
    try {
      final unauthorizedError =
          Provider.of<UnauthorizedError>(context, listen: false);

      final editEmployeeError =
          Provider.of<EditEmployeeError>(context, listen: false);

      final serverError = Provider.of<ServerError>(context, listen: false);

      final erro403 = Provider.of<Error403>(context, listen: false);

      if (formKey.currentState!.validate()) {
        FocusScope.of(context).unfocus();
        setState(() {
          _isloading = true;
        });
        String? fileName =
            imageChoosen == 1 ? imageSend!.path.split('/').last : "";

        FormData formData = FormData.fromMap({
          "name": _userName.text,
          "gender": _userData["data"]["gender"],
          "email": _userEmail.text,
          "phone": _userPhoneNumber.text,
          // "password": "Ahmed123@",
          // "password_confirmation": "Ahmed123@",
          "image": imageChoosen == 1
              ? await MultipartFile.fromFile(imageSend!.path,
                  filename: fileName)
              : null,
          "country_id": UserInformation.getUserCountryId(),
          "role_id": _userData["data"]["role_id"],
        });

        final response = await Dio().post(
          ("${Urls.EDITEMPLOYEE_URL}${_userData["data"]["id"]}"),
          data: formData,
          options: Options(
            validateStatus: (status) {
              return status! < 500;
            },
            followRedirects: false,
            headers: <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'multipart/form-data',
              "Accept-Language": UserData.getUSerLang(),
              "Authorization": "Bearer ${UserData.getUserApiToken()}"
            },
          ),
        );

        if (response.statusCode == 200) {
          updateSystemphoto();
        } else if (response.statusCode == 401) {
          unauthorizedError.unauthorizedErrors401(context);
          setState(() {
            _isloading = false;
          });
        } else if (response.statusCode == 422) {
          setState(() {
            editEmployeeError.editEmployeeError422(context, response.data);
            _isloading = false;
          });
        } else if (response.statusCode == 403) {
          setState(() {
            erro403.error403(context, response.statusCode!);
            _isloading = false;
          });
        } else {
          setState(() {
            serverError.serverError(context, response.statusCode!);
            _isloading = false;
          });
        }
      }
    } catch (e) {}
  }

  updateSystemphoto() async {
    try {
      final unauthorizedError =
          Provider.of<UnauthorizedError>(context, listen: false);

      final editEmployeeError =
          Provider.of<EditEmployeeError>(context, listen: false);

      final serverError = Provider.of<ServerError>(context, listen: false);

      final erro403 = Provider.of<Error403>(context, listen: false);

      setState(() {
        _isSystemPhotoLoading = true;
      });
      String? fileName =
          SystemPhotoChoosen == 1 ? systemPhot!.path.split('/').last : "";

      FormData formData = FormData.fromMap({
        "image": SystemPhotoChoosen == 1
            ? await MultipartFile.fromFile(systemPhot!.path, filename: fileName)
            : null,
      });
      final response = await Dio().post(
        ("${Urls.GET_SYSTEM_PHOTO_URL}${UserData.getUserId()}/update"),
        data: formData,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
          followRedirects: false,
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            "Accept-Language": UserData.getUSerLang(),
            "Authorization": "Bearer ${UserData.getUserApiToken()}"
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => EditNavigationBar()),
              (route) => false);

          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: successOperation(
                      operationName: "edit employee successfully"),
                );
              });
        });
        setState(() {
          _isSystemPhotoLoading = false;
        });
      } else if (response.statusCode == 401) {
        unauthorizedError.unauthorizedErrors401(context);
        setState(() {
          _isSystemPhotoLoading = false;
        });
      } else if (response.statusCode == 422) {
        setState(() {
          editEmployeeError.editEmployeeError422(context, response.data);
          _isSystemPhotoLoading = false;
        });
      } else if (response.statusCode == 403) {
        setState(() {
          erro403.error403(context, response.statusCode!);
          _isSystemPhotoLoading = false;
        });
      } else {
        setState(() {
          serverError.serverError(context, response.statusCode!);
          _isSystemPhotoLoading = false;
        });
      }
    } catch (e) {}
  }
}
