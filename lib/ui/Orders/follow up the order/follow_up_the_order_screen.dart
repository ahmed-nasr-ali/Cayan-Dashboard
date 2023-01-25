// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, must_be_immutable, prefer_const_constructors_in_immutables, prefer_final_fields, use_build_context_synchronously, prefer_adjacent_string_concatenation

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
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'customer data screen/customer_data_screen.dart';
import 'follow up the order details screen/follow_up_the_order_details_screen.dart';
import 'package:http/http.dart' as http;

class FollowUpTheOrderScreen extends StatefulWidget {
  int orderId;
  FollowUpTheOrderScreen({
    required this.orderId,
    Key? key,
  }) : super(key: key);

  @override
  State<FollowUpTheOrderScreen> createState() => _FollowUpTheOrderScreenState();
}

class _FollowUpTheOrderScreenState extends State<FollowUpTheOrderScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> _orderInformation = {};

  http.Client clientApi = http.Client();

  List<dynamic> _orderHistory = [];

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
      Uri.parse("${Urls.GET_SHOW_ORDER_URL}${widget.orderId}"),
      headers: <String, String>{
        'Accept': 'application/json',
        "Accept-Language": UserData.getUSerLang(),
        'Content-Type': 'application/json',
        "Authorization": "Bearer ${UserData.getUserApiToken()}"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      _orderInformation = map["data"] ?? []; //todo check
      _orderHistory = map["data"]["histories"] ?? []; //todo check

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
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NetworkIndicator(
      child: PageContainer(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor:
                themeProvider.isDarkMode ? containerdarkColor : whiteColor,
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    backgroundColor: themeProvider.isDarkMode
                        ? containerdarkColor
                        : whiteColor,
                    elevation: 0,
                    centerTitle: true,
                    leading: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        "assets/images/arrow_simple_chock.png",
                        color:
                            themeProvider.isDarkMode ? whiteColor : blackColor,
                      ),
                    ),
                    title: SmallText(
                      color: themeProvider.isDarkMode ? whiteColor : blackColor,
                      size: MediaQuery.of(context).size.height / 50.75, //16
                      typeOfFontWieght: 1,
                      text: AppLocalizations.of(context)!
                          .translate("Follow Up The Order"),
                    ),
                    bottom: TabBar(
                      indicatorWeight: 3,
                      indicatorColor: mainAppColor,
                      indicatorPadding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width / 12.5 //30
                          ),
                      labelColor: mainAppColor,
                      unselectedLabelColor:
                          themeProvider.isDarkMode ? whiteColor : blackColor,
                      labelStyle: TextStyle(
                        fontFamily: 'RB',
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height / 58, //14
                        overflow: TextOverflow.ellipsis,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontFamily: 'RB',
                        fontWeight: FontWeight.normal,
                        fontSize: MediaQuery.of(context).size.height / 58, //14
                        overflow: TextOverflow.ellipsis,
                      ),
                      tabs: [
                        Tab(
                          text: AppLocalizations.of(context)!
                              .translate("Follow Up The Order"),
                        ),
                        Tab(
                          text: AppLocalizations.of(context)!
                              .translate("Customer data"),
                        )
                      ],
                    ),
                  ),
                )
              ],
              body: TabBarView(
                children: [
                  _isLoading
                      ? Padding(
                          padding: EdgeInsets.only(
                              top:
                                  MediaQuery.of(context).size.height / 11.6 //70
                              ),
                          child: ShimmerListView(
                            hight:
                                MediaQuery.of(context).size.height / 7.25, //112
                          ),
                        )
                      : FollowUpTheOrderDetailsScreen(
                          orderInformation: _orderInformation,
                          orderHistory: _orderHistory,
                          orderId: widget.orderId,
                        ),
                  _isLoading
                      ? Padding(
                          padding: EdgeInsets.only(
                              top:
                                  MediaQuery.of(context).size.height / 11.6 //70
                              ),
                          child: ShimmerListView(
                            itemLength: 1,
                            hight: MediaQuery.of(context).size.height /
                                2.706666666666667, //112
                          ),
                        )
                      : CustomerDataScreen(
                          orderInformation: _orderInformation,
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
