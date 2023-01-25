// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_final_fields, , prefer_adjacent_string_concatenation, unused_field, prefer_const_constructors_in_immutables, body_might_complete_normally_nullable, sized_box_for_whitespace, must_be_immutable, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unnecessary_string_interpolations, prefer_if_null_operators, unused_catch_clause, empty_catches

import 'dart:io';
import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/custom_container/custom_container.dart';
import 'package:cayan/custom_widgets/customtextformfield/custom_text_form_feild.dart';
import 'package:cayan/custom_widgets/open%20image/open_image.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/edit%20employee%20error/edit_empolyee_error.dart';
import 'package:cayan/network/api_errors/server%20error/server_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/choosecountry.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Employee%20Mangment/edit%20employees/edit%20employee%20choose%20country/edit_employee_choose_country.dart';
import 'package:cayan/ui/Employee%20Mangment/edit%20employees/edit%20employee%20perimission/edit_employee_permissions.dart';
import 'package:cayan/ui/Employee%20Mangment/employee%20mangement%20screen/employee_mangement_screen.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditEmployee extends StatefulWidget {
  int userId;
  String userName;
  String userEmail;
  String userPhone;
  String userImage;
  int userCountryID;
  String userCountryCode;
  String userCountryImage;
  int userPerimission;
  EditEmployee({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userImage,
    required this.userCountryID,
    required this.userCountryCode,
    required this.userCountryImage,
    required this.userPerimission,
    Key? key,
  }) : super(key: key);

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  File? imageSend;
  int imageChoosen = 0;

  late FocusNode _userFouceName;
  late FocusNode _userFocusEmail;
  late FocusNode _userFoucePhone;

  bool isSelected = false;
  bool _isMale = true;
  bool _isFmale = false;
  bool _isLoading = false;

  TextEditingController _userName = TextEditingController();
  TextEditingController _userEmail = TextEditingController();
  TextEditingController _userPhoneNumber = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _userEmail.text = widget.userEmail;
    _userName.text = widget.userName;
    _userPhoneNumber.text = widget.userPhone;

    setState(() {
      UserData.getCountryImage();
    });

    _userFouceName = FocusNode();
    _userFocusEmail = FocusNode();
    _userFoucePhone = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    _userFouceName.dispose();
    _userFocusEmail.dispose();
    _userFoucePhone.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final countryProvider = Provider.of<ChooseCountryData>(context);

    setState(() {
      UserData.getEditEmloyeeCountryImage();
      UserData.getEditEmloyeeCountryCode();
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
                                  .translate("edit employee"),
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
                                "Edit the employee and change his data",
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
                              hintText: widget.userName,
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
                              hintText: widget.userEmail,
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
                              preffixWidget: _chooseCountry(
                                themeProvider,
                              ),
                              isSuffix: false,
                              isSuffixImage: false,
                              hintText: widget.userPhone,
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
                                    child: EditEmployeePermissions(),
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
                                    text: UserData
                                                .getEditEmployeePermissionsName() ==
                                            ""
                                        ? AppLocalizations.of(context)!
                                            .translate("permissions")
                                        : UserData
                                            .getEditEmployeePermissionsName(),
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
                                                color: hintColor,
                                              )
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

                    // _dimenssion(themeProvider, "gender"),

                    // _chooseGender(themeProvider),

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

  void openGallery() => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => OpenImage(
            imageSend: imageSend != null ? imageSend : null,
            userImage: widget.userImage,
          )));

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
                        widget.userImage,
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
                  child: EditEmployeeChooseCountry(),
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
          CircleAvatar(
              backgroundColor:
                  themeProvider.isDarkMode ? containerdarkColor : whiteColor,
              radius:
                  MediaQuery.of(context).size.height / 54.13333333333333, //12
              backgroundImage:
                  NetworkImage(UserData.getEditEmloyeeCountryImage())),
          SizedBox(
            width: MediaQuery.of(context).size.width / 75, //5,
          ),
          SmallText(
            text: UserData.getEditEmloyeeCountryCode(),
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
                  onPressedFunction: editEmployeeMethed,
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

  editEmployeeMethed() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final editEmployeeError =
        Provider.of<EditEmployeeError>(context, listen: false);

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
        "phone": _userPhoneNumber.text,
        "password": "Ahmed123@",
        "password_confirmation": "Ahmed123@",
        "image": imageChoosen == 1
            ? await MultipartFile.fromFile(imageSend!.path, filename: fileName)
            : null,
        "country_id": UserData.getEditEmloyeeCountryId(),
        "role_id": UserData.getEditEmployeePermissionsId(),
      });

      final response = await Dio().post(
        ("${Urls.EDITEMPLOYEE_URL}${widget.userId}"),
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
              MaterialPageRoute(
                  builder: (context) => EmployeeMangementScreen()),
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
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        unauthorizedError.unauthorizedErrors401(context);
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 422) {
        setState(() {
          editEmployeeError.editEmployeeError422(context, response.data);
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
