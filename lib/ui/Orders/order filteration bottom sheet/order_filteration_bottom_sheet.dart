// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_final_fields, unused_field, unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/navigation_bar_screen.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/order%20user%20data/order_user_data.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/edit%20navigation%20bar/edit_navigation_bar.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrderFilterationBottomSheet extends StatefulWidget {
  const OrderFilterationBottomSheet({Key? key}) : super(key: key);

  @override
  State<OrderFilterationBottomSheet> createState() =>
      _OrderFilterationBottomSheetState();
}

class _OrderFilterationBottomSheetState
    extends State<OrderFilterationBottomSheet> {
  http.Client clientApi = http.Client();

  List<dynamic> _allUsers = [];

  bool _isLoading = false;

  int? _id;
  String selectItem = "";

  int? newNumber;
  int? followNumber;
  int? paidNumber;
  int? failNumber;
  int? allNumber;
  String showNo = "";

  Future fetchCategoryList() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    final serverError = Provider.of<HomeServerError>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    final response = await clientApi.get(
      Uri.parse(Urls.GET_ORDER_STATUS_URL),
      headers: <String, String>{
        'Accept': 'application/json',
        "Accept-Language": UserData.getUSerLang(),
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${UserData.getUserApiToken()}"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      _allUsers = map["data"];
      newNumber = _allUsers[0]["orders_count"] ?? 0;
      followNumber = _allUsers[1]["orders_count"] ?? 0;
      paidNumber = _allUsers[2]["orders_count"] ?? 0;
      failNumber = _allUsers[3]["orders_count"] ?? 0;
      allNumber = newNumber! + followNumber! + paidNumber! + failNumber!;

      setState(() {
        _isLoading = false;
      });
    } else if (response.statusCode == 401) {
      unauthorizedError.unauthorizedErrors401(context);
      setState(() {
        _isLoading = false;
      });
    } else if (response.statusCode == 422) {
      Navigator.pop(context);
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
    } else if (response.statusCode == 403) {
      setState(() {
        erro403.error403(context, response.statusCode);
        _isLoading = false;
      });
    } else {
      setState(() {
        serverError.serverError(context, response.statusCode);
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fetchCategoryList();

    _id = OrderUserData.getOrderStatusIdForSearch();
  }

  @override
  void dispose() {
    super.dispose();
    clientApi.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final navigatonBarScreen =
        Provider.of<NavigationBarScreen>(context, listen: false);

    return NetworkIndicator(
      child: DraggableScrollableSheet(
        initialChildSize: 0.7019704433497537, //644
        maxChildSize: 0.7019704433497537, //644 584
        minChildSize: 0.5,
        builder: (context, scrollController) => GestureDetector(
          child: Container(
            height:
                MediaQuery.of(context).size.height / 1.241590214067278, //654
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      MediaQuery.of(context).size.height / 81.2),
                  topRight: Radius.circular(
                      MediaQuery.of(context).size.height / 81.2)),
              color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
            ),
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
                                  .translate("Filter the orders"),
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
                                "You can filter the requests of the system",
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
                      height: MediaQuery.of(context).size.height / 50.75, //20
                    ),
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
                        : filterationContainer(
                            themeProvider,
                            0,
                            "assets/images/element.png",
                            UserData.getUSerLang() == "en" ? "all" : "الكل",
                            allNumber.toString(),
                            cardColor),
                    SizedBox(
                      height: MediaQuery.of(context).size.height /
                          54.13333333333333, //15
                    ),
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
                        : filterationContainer(
                            themeProvider,
                            1,
                            "assets/images/box.png",
                            _allUsers[0]["name"],
                            newNumber.toString(),
                            Color(0xFFE5F0FF),
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height /
                          54.13333333333333, //15
                    ),
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
                        : filterationContainer(
                            themeProvider,
                            2,
                            "assets/images/timermaincolor.png",
                            _allUsers[1]["name"],
                            followNumber.toString(),
                            Color(0xFFFFF6E5),
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height /
                          54.13333333333333, //15
                    ),
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
                        : filterationContainer(
                            themeProvider,
                            3,
                            "assets/images/card_tickgreen.png",
                            _allUsers[2]["name"],
                            paidNumber.toString(),
                            Color(0xFFE9F6E7),
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height /
                          54.13333333333333, //15
                    ),
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
                        : filterationContainer(
                            themeProvider,
                            4,
                            "assets/images/close_circlered.png",
                            _allUsers[3]["name"],
                            failNumber.toString(),
                            Color(0xFFFBE9E9),
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height /
                          18.04444444444444, //45
                    ),
                    _saveAndCancledButton(themeProvider, navigatonBarScreen),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 40.6,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget filterationContainer(ThemeProvider themeProvider, int idValue,
      String imageUrl, String rigthText, String leftText, Color itemColor) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 23.4375,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _id = idValue;
            selectItem = rigthText;
            showNo = idValue == 0
                ? allNumber.toString()
                : _allUsers[idValue - 1]["orders_count"].toString();
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 16.24, //50
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.height / 81.2, //10
            ),
            color: themeProvider.isDarkMode
                ? _id == idValue
                    ? mainAppColor
                    : Color(0xff292828)
                : _id == idValue
                    ? mainAppColor
                    : itemColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 23.4375,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(imageUrl),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 75,
                    ),
                    SmallText(
                      text: rigthText,
                      size: MediaQuery.of(context).size.height / 58, //12
                      color: themeProvider.isDarkMode
                          ? _id == idValue
                              ? blackColor
                              : whiteColor
                          : _id == idValue
                              ? blackColor
                              : blackColor,
                    ),
                  ],
                ),
                SmallText(
                  text: leftText,
                  color: themeProvider.isDarkMode
                      ? _id == idValue
                          ? blackColor
                          : whiteColor
                      : blackColor,
                  typeOfFontWieght: 1,
                  size: MediaQuery.of(context).size.height / 40.6,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveAndCancledButton(
      ThemeProvider themeProvider, NavigationBarScreen navigatonBarScreen) {
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
                  onPressedFunction: () {
                    setState(() {
                      _id == 0
                          ? OrderUserData.setOrderStatusIdForSearch(0)
                          : OrderUserData.setOrderStatusIdForSearch(_id!);

                      _id == 0
                          ? OrderUserData.setOrderStatusNameForSearch("")
                          : OrderUserData.setOrderStatusNameForSearch(
                              selectItem);

                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditNavigationBar()));
                      navigatonBarScreen.updateNavigationIndex(2);
                    });
                  },
                  btnColor: mainAppColor,
                  btnStyle: TextStyle(color: blackColor),
                  horizontalMargin: 0,
                  verticalMargin: 0,
                  lightBorderColor: mainAppColor,
                  darkBorderColor: mainAppColor,
                  addtionalWidgit: false,
                  child: Center(
                    child: SmallText(
                      text: AppLocalizations.of(context)!
                              .translate("filter results") +
                          (showNo == ""
                              ? " (${allNumber.toString()})"
                              : "( $showNo)"),
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
}
