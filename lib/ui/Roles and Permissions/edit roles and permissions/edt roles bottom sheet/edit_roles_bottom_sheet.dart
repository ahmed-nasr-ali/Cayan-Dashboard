// ignore_for_file: must_be_immutable, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, prefer_final_fields, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, avoid_print, non_constant_identifier_names

import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer%20list%20view/shimmer_list_view.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/providers/add_roles_and_perimisson_provider.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../custom_widgets/TextStyle/small_text.dart';
import '../../../../custom_widgets/shimmer effect/shimmer/shimmer.dart';

class EditRolesBottomSheet extends StatefulWidget {
  List<dynamic> profilesdata;
  String catogryName;

  EditRolesBottomSheet(
      {Key? key, required this.catogryName, required this.profilesdata})
      : super(key: key);

  @override
  State<EditRolesBottomSheet> createState() => _EditRolesBottomSheetState();
}

class _EditRolesBottomSheetState extends State<EditRolesBottomSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final _addRolesAndPerimissonsProvider =
        Provider.of<AddRolesAndPerimissionsProvider>(context);

    return NetworkIndicator(
      child: Container(
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
              height:
                  MediaQuery.of(context).size.height / 54.13333333333333, //15
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
                      text: widget.catogryName,
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
                      text:
                          "${AppLocalizations.of(context)!.translate("choose_from_follwing")}" +
                              " ${widget.catogryName} " +
                              (UserData.getUSerLang() == "ar" ? "التالية" : ""),
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
                      itemCount: widget.profilesdata.length,
                      itemBuilder: (context, index) {
                        return ProfileList(index, themeProvider,
                            _addRolesAndPerimissonsProvider);
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Widget ProfileList(int index, ThemeProvider themeProvider,
      AddRolesAndPerimissionsProvider _addRolesAndPerimissonsProvider) {
    return InkWell(
      onTap: () {
        setState(() {
          _addRolesAndPerimissonsProvider
              .addRolesAndPerimssionId(widget.profilesdata[index]["id"]);
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 18.75), //20
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 40.6, //20
            ),
            Row(
              children: [
                SmallText(
                  text: widget.profilesdata[index]["name"] ?? "",
                  size: MediaQuery.of(context).size.height / 50.75, //14
                  typeOfFontWieght: _addRolesAndPerimissonsProvider.categoryID
                          .contains(widget.profilesdata[index]["id"] ?? "")
                      ? 1
                      : 0,
                  color: themeProvider.isDarkMode ? whiteColor : blackColor,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                          visible: _addRolesAndPerimissonsProvider.categoryID
                                  .contains(
                                      widget.profilesdata[index]["id"] ?? "")
                              ? true
                              : false,
                          child: Image.asset("assets/images/check.png")),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 40.6, //20
            ),
            Divider(
              color:
                  themeProvider.isDarkMode ? dividerDarkColor : containerColor,
              height: 0,
            )
          ],
        ),
      ),
    );
  }
}
