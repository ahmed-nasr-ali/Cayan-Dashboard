// ignore_for_file: must_be_immutable, prefer_final_fields, unused_field, avoid_print, prefer_const_constructors, unused_local_variable, use_build_context_synchronously

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Categories/categories%20screen/category_screem.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class DeleteCategory extends StatefulWidget {
  int userId;
  DeleteCategory({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<DeleteCategory> createState() => _DeleteCategoryState();
}

class _DeleteCategoryState extends State<DeleteCategory> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    print("delete category");
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NetworkIndicator(
      child: Container(
        width: MediaQuery.of(context).size.width, //width
        height: MediaQuery.of(context).size.height / 2.849122807017544, //80
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft:
                  Radius.circular(MediaQuery.of(context).size.height / 81.2),
              topRight:
                  Radius.circular(MediaQuery.of(context).size.height / 81.2)),
          color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 23.4375), //16
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
              SizedBox(height: MediaQuery.of(context).size.height / 23.2), //35
              _isLoading
                  ? Center(
                      child: ShimmerWidget.circular(
                          hight: MediaQuery.of(context).size.height /
                              9.552941176470588,
                          //85
                          width: MediaQuery.of(context).size.width /
                              4.411764705882353 //85
                          ),
                    )
                  : Center(
                      child: themeProvider.isDarkMode
                          ? Image.asset("assets/images/exitpopdark.png")
                          : Image.asset("assets/images/exitpop.png"),
                    ),
              SizedBox(
                  height: MediaQuery.of(context).size.height /
                      27.06666666666667), //30

              //are you sure for exsit employee
              _isLoading
                  ? Center(
                      child: ShimmerWidget.circular(
                        width: MediaQuery.of(context).size.width /
                            1.785714285714286, //210
                        hight: MediaQuery.of(context).size.height / 40.6, //20
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height / 162.4 //5
                                )),
                      ),
                    )
                  : Center(
                      child: SmallText(
                        text: AppLocalizations.of(context)!
                            .translate("Are you sure form deleting category"),
                        size: MediaQuery.of(context).size.height / 50.75, //16
                        typeOfFontWieght: 1,
                        color:
                            themeProvider.isDarkMode ? whiteColor : blackColor,
                      ),
                    ),
              SizedBox(
                  height: MediaQuery.of(context).size.height /
                      27.06666666666667), //30
              _saveAndCancledButton(themeProvider)
            ],
          ),
        ),
      ),
    );
  }

  _saveAndCancledButton(ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _isLoading
            ? ShimmerWidget.circular(
                hight:
                    MediaQuery.of(context).size.height / 18.04444444444444, //45
                width:
                    MediaQuery.of(context).size.width / 2.272727272727273, //165
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              )
            : CustomButton(
                height:
                    MediaQuery.of(context).size.height / 18.04444444444444, //45
                width:
                    MediaQuery.of(context).size.width / 2.272727272727273, //165
                btnLbl: "موافق",
                onPressedFunction: deleteCategoryMethed,

                btnColor: mainAppColor,
                btnStyle: TextStyle(color: blackColor),
                horizontalMargin: 0,
                verticalMargin: 0,
                lightBorderColor: mainAppColor,
                darkBorderColor: mainAppColor,
                addtionalWidgit: false,
                child: Center(
                  child: SmallText(
                    text: AppLocalizations.of(context)!.translate("agree"),
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
                hight:
                    MediaQuery.of(context).size.height / 18.04444444444444, //45
                width:
                    MediaQuery.of(context).size.width / 2.272727272727273, //165
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              )
            : CustomButton(
                height:
                    MediaQuery.of(context).size.height / 18.04444444444444, //45
                width:
                    MediaQuery.of(context).size.width / 2.272727272727273, //165
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
    );
  }

  deleteCategoryMethed() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final erro403 = Provider.of<Error403>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    print("requset");
    print("${Urls.DELETE_Category_URL}${widget.userId}");
    final response = await delete(
      Uri.parse("${Urls.DELETE_Category_URL}${widget.userId}"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "Accept-Language": "en",
        "Authorization": "Bearer ${UserData.getUserApiToken()}"
      },
    );
    print("==================================");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.statusCode);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

      Navigator.push(
          context, MaterialPageRoute(builder: (_) => CategoryScreen()));
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: successOperation(
                  operationName: "delete category successfully"),
            );
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
      Navigator.pop(context);
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
                text: AppLocalizations.of(context)!
                    .translate("can not delete this category"),
                typeOfFontWieght: 1,
              ),
            );
          });
      setState(() {
        _isLoading = false;
      });
    } else if (response.statusCode == 403) {
      print(response.statusCode);
      setState(() {
        erro403.error403(context, response.statusCode);
        _isLoading = false;
      });
    } else {
      print(response.statusCode);
      print(response.body);
      setState(() {
        homeServerError.serverError(context, response.statusCode);
        _isLoading = false;
      });
    }
  }
}
