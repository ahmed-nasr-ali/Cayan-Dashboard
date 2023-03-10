// ignore_for_file: use_build_context_synchronously, unused_field, unused_local_variable, prefer_const_literals_to_create_immutables, non_constant_identifier_names, sized_box_for_whitespace

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

class OrderStatusBottomSheet extends StatefulWidget {
  const OrderStatusBottomSheet({Key? key}) : super(key: key);

  @override
  State<OrderStatusBottomSheet> createState() => _OrderStatusBottomSheetState();
}

class _OrderStatusBottomSheetState extends State<OrderStatusBottomSheet> {
  List<dynamic> _allUsers = [];

  http.Client clientApi = http.Client();

  bool _isLoading = false;

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
  }

  @override
  void dispose() {
    super.dispose();
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
                      text: AppLocalizations.of(context)!
                          .translate("Order status"),
                      color: themeProvider.isDarkMode ? whiteColor : blackColor,
                      size: MediaQuery.of(context).size.height / 50.75, //16
                      typeOfFontWieght: 1,
                    ),
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
                      itemCount: _allUsers.length,
                      itemBuilder: (context, index) {
                        return CategoryList(index, themeProvider);
                      }),
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
            onTap: () {},
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.875,
                  child: SmallText(
                    align: TextAlign.start,
                    text: _allUsers[index]["name"] ?? "",
                    size: MediaQuery.of(context).size.height / 50.75, //14
                    typeOfFontWieght: OrderUserData.getOrderStatusId() ==
                            _allUsers[index]["id"]
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
                          visible: OrderUserData.getOrderStatusId() ==
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
