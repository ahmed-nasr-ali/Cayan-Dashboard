// // ignore_for_file: prefer_final_fields, unused_field, unused_local_variable, prefer_const_literals_to_create_immutables, prefer_const_constructors

// import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
// import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
// import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
// import 'package:cayan/locale/app_localizations.dart';
// import 'package:cayan/providers/theme_provider.dart';
// import 'package:cayan/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class DeleteRolesAndPermissions extends StatefulWidget {
//   const DeleteRolesAndPermissions({Key? key}) : super(key: key);

//   @override
//   State<DeleteRolesAndPermissions> createState() =>
//       _DeleteRolesAndPermissionsState();
// }

// class _DeleteRolesAndPermissionsState extends State<DeleteRolesAndPermissions> {
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return Container(
//       width: MediaQuery.of(context).size.width, //width
//       height: MediaQuery.of(context).size.height / 2.849122807017544, //80
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(MediaQuery.of(context).size.height / 81.2),
//             topRight:
//                 Radius.circular(MediaQuery.of(context).size.height / 81.2)),
//         color: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//             horizontal: MediaQuery.of(context).size.width / 23.4375), //16
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height:
//                   MediaQuery.of(context).size.height / 54.13333333333333, //15
//             ),
//             Center(
//               child: Container(
//                 // margin: EdgeInsets.symmetric(horizontal: 0),
//                 width: MediaQuery.of(context).size.width / 9.375, //40
//                 height: MediaQuery.of(context).size.height / 162.4, //5
//                 decoration: BoxDecoration(
//                     color: themeProvider.isDarkMode
//                         ? dividerDarkColor
//                         : containerColor,
//                     borderRadius: BorderRadius.circular(
//                         MediaQuery.of(context).size.height / 162.4)), //5
//               ),
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height / 23.2), //35
//             _isLoading
//                 ? Center(
//                     child: ShimmerWidget.circular(
//                         hight: MediaQuery.of(context).size.height /
//                             9.552941176470588,
//                         //85
//                         width: MediaQuery.of(context).size.width /
//                             4.411764705882353 //85
//                         ),
//                   )
//                 : Center(
//                     child: themeProvider.isDarkMode
//                         ? Image.asset("assets/images/exitpopdark.png")
//                         : Image.asset("assets/images/exitpop.png"),
//                   ),
//             SizedBox(
//                 height: MediaQuery.of(context).size.height /
//                     27.06666666666667), //30

//             _isLoading
//                 ? Center(
//                     child: ShimmerWidget.circular(
//                       width: MediaQuery.of(context).size.width /
//                           1.785714285714286, //210
//                       hight: MediaQuery.of(context).size.height / 40.6, //20
//                       shapeBorder: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(
//                               MediaQuery.of(context).size.height / 162.4 //5
//                               )),
//                     ),
//                   )
//                 : Center(
//                     child: SmallText(
//                       text: AppLocalizations.of(context)!
//                           .translate("Are you sure form deleting permission"),
//                       size: MediaQuery.of(context).size.height / 50.75, //16
//                       typeOfFontWieght: 1,
//                       color: themeProvider.isDarkMode ? whiteColor : blackColor,
//                     ),
//                   ),
//             SizedBox(
//                 height: MediaQuery.of(context).size.height /
//                     27.06666666666667), //30
//             _saveAndCancledButton(themeProvider)
//           ],
//         ),
//       ),
//     );
//   }

//   _saveAndCancledButton(ThemeProvider themeProvider) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _isLoading
//             ? ShimmerWidget.circular(
//                 hight:
//                     MediaQuery.of(context).size.height / 18.04444444444444, //45
//                 width:
//                     MediaQuery.of(context).size.width / 2.272727272727273, //165
//                 shapeBorder: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5)),
//               )
//             : CustomButton(
//                 height:
//                     MediaQuery.of(context).size.height / 18.04444444444444, //45
//                 width:
//                     MediaQuery.of(context).size.width / 2.272727272727273, //165
//                 btnLbl: "موافق",
//                 onPressedFunction: () {},
//                 btnColor: mainAppColor,
//                 btnStyle: TextStyle(color: blackColor),
//                 horizontalMargin: 0,
//                 verticalMargin: 0,
//                 lightBorderColor: mainAppColor,
//                 darkBorderColor: mainAppColor,
//                 addtionalWidgit: false,
//                 child: Center(
//                   child: SmallText(
//                     text: AppLocalizations.of(context)!.translate("agree"),
//                     color: themeProvider.isDarkMode ? blackColor : blackColor,
//                     typeOfFontWieght: 1,
//                   ),
//                 ),
//               ),
//         SizedBox(
//           width: MediaQuery.of(context).size.width / 37.5, //10,
//         ),
//         _isLoading
//             ? ShimmerWidget.circular(
//                 hight:
//                     MediaQuery.of(context).size.height / 18.04444444444444, //45
//                 width:
//                     MediaQuery.of(context).size.width / 2.272727272727273, //165
//                 shapeBorder: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5)),
//               )
//             : CustomButton(
//                 height:
//                     MediaQuery.of(context).size.height / 18.04444444444444, //45
//                 width:
//                     MediaQuery.of(context).size.width / 2.272727272727273, //165
//                 btnLbl: "الغاء",
//                 onPressedFunction: () {
//                   Navigator.pop(context);
//                 },
//                 btnColor:
//                     themeProvider.isDarkMode ? Color(0xff292828) : whiteColor,
//                 btnStyle: TextStyle(color: blackColor),
//                 horizontalMargin: 0,
//                 verticalMargin: 0,
//                 lightBorderColor: blackColor,
//                 darkBorderColor: Color(0xff292828),
//                 addtionalWidgit: false,
//                 child: Center(
//                   child: SmallText(
//                     text: AppLocalizations.of(context)!.translate("cancel"),
//                     color: themeProvider.isDarkMode ? whiteColor : blackColor,
//                     typeOfFontWieght: 1,
//                   ),
//                 ),
//               ),
//       ],
//     );
//   }
// }
