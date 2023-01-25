// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_final_fields, prefer_adjacent_string_concatenation, unused_field, prefer_const_constructors_in_immutables, body_might_complete_normally_nullable, sized_box_for_whitespace, must_be_immutable, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unnecessary_string_interpolations, prefer_if_null_operators, unused_catch_clause, empty_catches

import 'dart:io';
import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/custom_container/custom_container.dart';
import 'package:cayan/custom_widgets/customtextfiledforpassward/custom_text_form_feild_passward.dart';
import 'package:cayan/custom_widgets/customtextformfield/custom_text_form_feild.dart';
import 'package:cayan/custom_widgets/open%20image/open_image.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/server%20error/server_error.dart';
import 'package:cayan/network/api_errors/store/store_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/choosecountry.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Employee%20Mangment/add%20employee/choose%20country/choose_country.dart';
import 'package:cayan/ui/Employee%20Mangment/add%20employee/permissions/permissions.dart';
import 'package:cayan/ui/Employee%20Mangment/employee%20mangement%20screen/employee_mangement_screen.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddEmployeeScreen extends StatefulWidget {
  AddEmployeeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  File? imageSend;

  late FocusNode _userFouceName;
  late FocusNode _userFocusEmail;
  late FocusNode _userFoucePhone;
  late FocusNode _passwardFocusNode;
  late FocusNode _confirmPasswardFocusNode;

  bool isSelected = false;

  bool _isLoading = false;

  bool _obscureText = true;
  bool _obscureTextConfirm = true;

  TextEditingController _userName = TextEditingController();
  TextEditingController _userEmail = TextEditingController();
  TextEditingController _userPhoneNumber = TextEditingController();
  final TextEditingController _userPassward = TextEditingController();
  final TextEditingController _ConfirmUserPassward = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String _data = '';

  int imageChoosen = 0;

  List<dynamic> _allCountry = [];
  String countrCode = '';

  Future fetchCountryList() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    final serverError = Provider.of<ServerError>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    final resopnse = await Dio().get(
      Urls.COUNTRIES_URL,
      options: Options(
        validateStatus: (status) {
          return status! < 500;
        },
        followRedirects: false,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          "Accept-Language": UserData.getUSerLang(),
          "Authorization": "Bearer ${UserData.getUserApiToken()}"
        },
      ),
    );
    if (resopnse.statusCode == 200) {
      Map<String, dynamic> map = resopnse.data;
      _allCountry = map["data"];

      setState(() {
        _isLoading = false;
        UserData.setCountryId(_allCountry[0]["id"]);

        UserData.setCountryName(_allCountry[0]["name"]);
        countrCode = _allCountry[0]["code"];

        UserData.setCountryCode(countrCode);

        UserData.setCountryImage(_allCountry[0]["image"]);
      });
    } else if (resopnse.statusCode == 401) {
      setState(() {
        unauthorizedError.unauthorizedErrors401(context);
        _isLoading = false;
      });
    } else if (resopnse.statusCode == 422) {
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
        _isLoading = false;
      });
    } else if (resopnse.statusCode == 403) {
      setState(() {
        erro403.error403(context, resopnse.statusCode!);
        _isLoading = false;
      });
    } else {
      setState(() {
        serverError.serverError(context, resopnse.statusCode!);
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCountryList();
    setState(() {
      UserData.getCountryImage();
    });

    _userFouceName = FocusNode();
    _userFocusEmail = FocusNode();
    _userFoucePhone = FocusNode();
    _passwardFocusNode = FocusNode();
    _confirmPasswardFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    _userFouceName.dispose();
    _userFocusEmail.dispose();
    _userFoucePhone.dispose();
    _passwardFocusNode.dispose();
    _confirmPasswardFocusNode.dispose();

    Dio().close();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final countryProvider = Provider.of<ChooseCountryData>(context);

    setState(() {
      _data = countryProvider.data;
      UserData.getCountryImage();
    });
    return NetworkIndicator(
      child: DraggableScrollableSheet(
        //todo dimenssions
        initialChildSize: 0.955,
        maxChildSize: 0.955,
        minChildSize: 0.5,
        builder: (context, scrollController) => GestureDetector(
          onTap: () {
            setState(() {
              _userFocusEmail.unfocus();
              _userFouceName.unfocus();
              _userFoucePhone.unfocus();
              _passwardFocusNode.unfocus();
              _confirmPasswardFocusNode.unfocus();
              isSelected = false;
            });
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 1.16, //700
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
              child: ListView(controller: scrollController, children: [
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
                        height: MediaQuery.of(context).size.height / 162.4, //5
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
                              hight: MediaQuery.of(context).size.height / 32.48,
                              width: MediaQuery.of(context).size.width / 3,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width /
                                    23.4375), //16
                            child: BigText(
                              text: AppLocalizations.of(context)!
                                  .translate("cereate new employee"),
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
                                horizontal: MediaQuery.of(context).size.width /
                                    23.4375), //16
                            child: SmallText(
                              text: AppLocalizations.of(context)!.translate(
                                "Fill in the following data to create a new employee",
                              ),
                              size:
                                  MediaQuery.of(context).size.height / 58, //14
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
                      height: MediaQuery.of(context).size.height / 40.6, //20
                    ),
                    _isLoading
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
                        : _addEmployeePhoto(themeProvider),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50.75, //16
                    ),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider, "name"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                horizontal: MediaQuery.of(context).size.height /
                                    50.75), //16
                            child: CustomTextField(
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
                              hintText: "Ahmed Nasr",
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
                                  _userFouceName.hasFocus == true;
                                });
                              },
                              onEditingComplete: () => _userFouceName.unfocus(),
                              onFieldSubmitted: (_) => _userFouceName.unfocus(),
                            ),
                          ),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider, "Email"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                horizontal: MediaQuery.of(context).size.width /
                                    23.4375), //16
                            child: CustomTextField(
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
                              hintText: AppLocalizations.of(context)!
                                  .translate("Email"),
                              inputData: TextInputType.name,
                              validationFunc: (value) {
                                if (value!.isEmpty) {
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
                            )),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider, "phone_No"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                horizontal: MediaQuery.of(context).size.width /
                                    23.4375), //16
                            child: CustomTextField(
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
                              preffixWidget:
                                  _chooseCountry(themeProvider, _data),
                              isSuffix: false,
                              isSuffixImage: false,
                              hintText: AppLocalizations.of(context)!
                                  .translate("phone_No"),
                              inputData: TextInputType.phone,
                              validationFunc: (value) {
                                if (value!.isEmpty) {
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
                          ),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider, "permissions"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
                            child: ShimmerWidget.circular(
                                hight: MediaQuery.of(context).size.height /
                                    18.04444444444444, //45
                                width: MediaQuery.of(context).size.width,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.height /
                                            81.2))),
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
                                    child: Permissions(),
                                  );
                                },
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            child: CustomContainer(
                              color: themeProvider.isDarkMode
                                  ? Color(0xff292828)
                                  : whiteColor,
                              hasHorizontalMargin: true,
                              horizontalMargin:
                                  MediaQuery.of(context).size.height /
                                      50.75, //16
                              verticalMargin: 0,
                              hasVerticalMargin: false,
                              isSelected: isSelected,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height /
                                  16.24, //50
                              borderRadius: MediaQuery.of(context).size.height /
                                  81.2, //10
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        23.4375, //16
                                  ),
                                  Image.asset(
                                    "assets/images/perm.png",
                                    color:
                                        isSelected ? mainAppColor : hintColor,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        75, //5
                                  ),
                                  SmallText(
                                    text: UserData.getPermissionsGuardName() ==
                                            ""
                                        ? AppLocalizations.of(context)!
                                            .translate("permissions")
                                        : UserData.getPermissionsGuardName(),
                                    color:
                                        isSelected ? mainAppColor : hintColor,
                                    size:
                                        MediaQuery.of(context).size.height / 58,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        themeProvider.isDarkMode
                                            ? Image.asset(
                                                "assets/images/downdark.png",
                                                color: hintColor)
                                            : Image.asset(
                                                "assets/images/down.png",
                                                color: hintColor,
                                              ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              31.25, //12
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider, "new_password"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                horizontal: MediaQuery.of(context).size.width /
                                    23.4375), //16,
                            child: CustomTextFieldPassward(
                              cursorColor: mainAppColor,
                              readOnly: false,
                              enabled: true,
                              maxLine: 1,
                              focusNode: _passwardFocusNode,
                              controller: _userPassward,
                              textStyleDarkColor: whiteColor,
                              textStyleLightColor: blackColor,
                              isFontBold: true,
                              fillDarkColor: Color(0xff292828),
                              fillLightColor: whiteColor,
                              labelText: "",
                              ispreffix: true,
                              ispreffixImage: true,
                              preffixImageUrl: "assets/images/pass.png",
                              isSuffix: true,
                              isSuffixImage: false,
                              suffixImageUrl: "assets/images/show.png",
                              suffixWidget: InkWell(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Image.asset(
                                  "assets/images/show.png",
                                  color: _passwardFocusNode.hasFocus
                                      ? themeProvider.isDarkMode
                                          ? mainAppColor
                                          : mainAppColor
                                      : hintColor,
                                ),
                              ),
                              hintText: AppLocalizations.of(context)!
                                  .translate("new_password"),
                              obscureText: _obscureText,
                              inputData: TextInputType.emailAddress,
                              validationFunc: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .translate(
                                          "you must Enter your Passward");
                                }
                                if (_userPassward.text !=
                                    _ConfirmUserPassward.text) {
                                  return AppLocalizations.of(context)!.translate(
                                      "Password and Conform Password Not Same");
                                }
                                return null;
                              },
                              onTap: () {
                                setState(() {
                                  _passwardFocusNode.hasFocus == true;
                                });
                              },
                              onEditingComplete: () =>
                                  _passwardFocusNode.unfocus(),
                              onFieldSubmitted: (_) =>
                                  _passwardFocusNode.unfocus(),
                            ),
                          ),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                  height:
                                      MediaQuery.of(context).size.height / 81.2,
                                )
                              ],
                            ),
                          )
                        : _dimenssion(themeProvider, "confirm_new_password"),
                    _isLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 18.75),
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
                                horizontal: MediaQuery.of(context).size.width /
                                    23.4375), //16,
                            child: CustomTextFieldPassward(
                              cursorColor: mainAppColor,
                              readOnly: false,
                              enabled: true,
                              maxLine: 1,
                              focusNode: _confirmPasswardFocusNode,
                              controller: _ConfirmUserPassward,
                              textStyleDarkColor: whiteColor,
                              textStyleLightColor: blackColor,
                              isFontBold: true,
                              fillDarkColor: Color(0xff292828),
                              fillLightColor: whiteColor,
                              labelText: "",
                              ispreffix: true,
                              ispreffixImage: true,
                              preffixImageUrl: "assets/images/pass.png",
                              isSuffix: true,
                              isSuffixImage: false,
                              suffixImageUrl: "assets/images/show.png",
                              suffixWidget: InkWell(
                                onTap: () {
                                  setState(() {
                                    _obscureTextConfirm = !_obscureTextConfirm;
                                  });
                                },
                                child: Image.asset(
                                  "assets/images/show.png",
                                  color: _confirmPasswardFocusNode.hasFocus
                                      ? themeProvider.isDarkMode
                                          ? mainAppColor
                                          : mainAppColor
                                      : hintColor,
                                ),
                              ),
                              hintText: AppLocalizations.of(context)!
                                  .translate("confirm_new_password"),
                              obscureText: _obscureTextConfirm,
                              inputData: TextInputType.emailAddress,
                              validationFunc: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .translate(
                                          "you must Enter your Passward");
                                }
                                if (_userPassward.text !=
                                    _ConfirmUserPassward.text) {
                                  return AppLocalizations.of(context)!.translate(
                                      "Password and Conform Password Not Same");
                                }
                                return null;
                              },
                              onTap: () {
                                setState(() {
                                  _confirmPasswardFocusNode.hasFocus == true;
                                });
                              },
                              onEditingComplete: () =>
                                  _confirmPasswardFocusNode.unfocus(),
                              onFieldSubmitted: (_) =>
                                  _confirmPasswardFocusNode.unfocus(),
                            ),
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20.3,
                    ),
                    _saveAndCancledButton(themeProvider),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40.6, //20
                    )
                  ],
                ),
              ]),
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

  void openGallery() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OpenImage(
              imageSend: imageSend != null ? imageSend : null,
              userImage: "https://dev.medical.cayan.co/images/user.png"),
        ),
      );

  _addEmployeePhoto(ThemeProvider themeProvider) {
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
                    : Image.network(
                        "https://dev.medical.cayan.co/images/user.png",
                        fit: BoxFit.cover,
                      ),
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
              AppLocalizations.of(context)!.translate("Add a profile picture"),
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

  _chooseCountry(
    ThemeProvider themeProvider,
    String data,
  ) {
    return InkWell(
      onTap: () {
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
                  child: ChooseCountry(),
                );
              });
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 23.4375, //16,
          ),
          data == ""
              ? CircleAvatar(
                  backgroundColor: themeProvider.isDarkMode
                      ? containerdarkColor
                      : whiteColor,
                  radius: MediaQuery.of(context).size.height /
                      54.13333333333333, //12
                  backgroundImage: NetworkImage(
                    _allCountry[0]["image"],
                  ))
              : CircleAvatar(
                  backgroundColor: themeProvider.isDarkMode
                      ? containerdarkColor
                      : whiteColor,
                  radius: MediaQuery.of(context).size.height /
                      54.13333333333333, //12
                  backgroundImage: NetworkImage(UserData.getCountryImage())),
          SizedBox(
            width: MediaQuery.of(context).size.width / 75, //5,
          ),
          SmallText(
            text: data == "" ? countrCode : UserData.getCountryCode(),
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
                  onPressedFunction: addEMployeeMethed,
                  btnColor: mainAppColor,
                  btnStyle: TextStyle(color: blackColor),
                  horizontalMargin: 0,
                  verticalMargin: 0,
                  lightBorderColor: mainAppColor,
                  darkBorderColor: mainAppColor,
                  addtionalWidgit: false,
                  child: Center(
                    child: SmallText(
                      text: AppLocalizations.of(context)!.translate("save"),
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

  addEMployeeMethed() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final storError = Provider.of<StoreError>(context, listen: false);

    final serverError = Provider.of<ServerError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });
      String? fileName =
          imageChoosen == 1 ? imageSend!.path.split('/').last : "";

      FormData formData = FormData.fromMap({
        "name": _userName.text,
        "email": _userEmail.text,
        "country_id": UserData.getCountryId(),
        "phone": _userPhoneNumber.text,
        "password": _userPassward.text,
        "password_confirmation": _ConfirmUserPassward.text,
        "image": imageChoosen == 1
            ? await MultipartFile.fromFile(imageSend!.path, filename: fileName)
            : null,
        "role_id": UserData.getPermissionsId(),
      });

      final response = await Dio().post(
        Urls.ADDEMPLOYEE_URL,
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
          //(كل حاجه خاصه بالدول بفضيها)
          UserData.setCountryId(0);

          UserData.setCountryName('');

          UserData.setCountryCode('');

          UserData.setCountryImage('');

          //(كل حاجه خاصه بالصلاحيات بفضيها)
          UserData.setPermissionsGuardName("");

          UserData.setPermissionsId(0);

          UserData.setPermissionsName("");
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => EmployeeMangementScreen()));

          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: successOperation(
                      operationName: "create employee successfully"),
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
        setState(() {
          storError.storeError422(context, response.data);
          _isLoading = false;
        });
      } else if (response.statusCode == 403) {
        setState(() {
          erro403.error403(context, response.statusCode!);
          _isLoading = false;
        });
      } else {
        setState(() {
          serverError.serverError(context, response.statusCode!);
          _isLoading = false;
        });
      }
    }
  }
}
