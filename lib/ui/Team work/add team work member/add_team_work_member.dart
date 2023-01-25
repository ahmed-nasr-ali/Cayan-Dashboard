// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_if_null_operators, sized_box_for_whitespace, avoid_print, unused_local_variable, use_build_context_synchronously, prefer_final_fields, unused_field, unnecessary_string_interpolations, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:io';

import 'package:cayan/custom_widgets/TextStyle/big_text.dart';
import 'package:cayan/custom_widgets/TextStyle/small_text.dart';
import 'package:cayan/custom_widgets/connectivity/network_indicator.dart';
import 'package:cayan/custom_widgets/custom_button/custom_button.dart';
import 'package:cayan/custom_widgets/customtextformfield/custom_text_form_feild.dart';
import 'package:cayan/custom_widgets/open%20image/open_image.dart';
import 'package:cayan/custom_widgets/shimmer%20effect/shimmer/shimmer.dart';
import 'package:cayan/locale/app_localizations.dart';
import 'package:cayan/network/api_errors/403errors/error_403.dart';
import 'package:cayan/network/api_errors/home%20server%20error/home_server_error.dart';
import 'package:cayan/network/api_errors/team%20work%20store%20error/team_work_store_error.dart';
import 'package:cayan/network/api_errors/unauthorized/unauthorized_error.dart';
import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/ui/Team%20work/team%20work%20screen/team_work_screen.dart';
import 'package:cayan/ui/succes%20operation%20bottom%20sheet/succes_operation.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:cayan/utils/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddTeamWorkMember extends StatefulWidget {
  const AddTeamWorkMember({Key? key}) : super(key: key);

  @override
  State<AddTeamWorkMember> createState() => _AddTeamWorkMemberState();
}

class _AddTeamWorkMemberState extends State<AddTeamWorkMember> {
  File? imageSend;

  int imageChoosen = 0;

  late FocusNode _userFouceName;
  late FocusNode _specializationFouce;

  bool isSelected = false;

  bool isValidate = false;

  bool _isLoading = false;

  TextEditingController _userName = TextEditingController();
  TextEditingController _specialization = TextEditingController();

  @override
  void initState() {
    super.initState();

    _userFouceName = FocusNode();
    _specializationFouce = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _userFouceName.dispose();
    _specializationFouce.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return NetworkIndicator(
      child: DraggableScrollableSheet(
        initialChildSize:
            isValidate ? 0.7931034482758621 : 0.7192118226600985, //644 584
        maxChildSize:
            isValidate ? 0.7931034482758621 : 0.7192118226600985, //644 584
        minChildSize: 0.5,
        builder: (context, scrollController) => GestureDetector(
          onTap: () {
            setState(() {
              _userFouceName.unfocus();
              _specializationFouce.unfocus();
            });
          },
          child: Container(
            height: isValidate
                ? MediaQuery.of(context).size.height / 1.335526315789474
                : MediaQuery.of(context).size.height /
                    1.404844290657439, //578 548
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
                                    .translate("create new person"),
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
                                  "Fill in the following data to create a new person",
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
                        height: MediaQuery.of(context).size.height / 40.6, //20
                      ),
                      _isLoading
                          ? Column(
                              children: [
                                Center(
                                  child: ShimmerWidget.circular(
                                      hight:
                                          MediaQuery.of(context).size.height /
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
                          : _addPersonPhoto(themeProvider),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50.75, //16
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
                          : _dimenssion(themeProvider, "name"),
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
                                    setState(() {
                                      isValidate = true;
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
                          : _dimenssion(themeProvider, "Specialization"),
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
                                focusNode: _specializationFouce,
                                controller: _specialization,
                                textStyleDarkColor: whiteColor,
                                textStyleLightColor: blackColor,
                                isFontBold: true,
                                fillDarkColor: Color(0xff292828),
                                fillLightColor: whiteColor,
                                labelText: '',
                                ispreffix: true,
                                ispreffixImage: true,
                                preffixImageUrl: "assets/images/bag.png",
                                isSuffix: false,
                                isSuffixImage: false,
                                hintText: AppLocalizations.of(context)!
                                    .translate("Specialization"),
                                inputData: TextInputType.name,
                                validationFunc: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      isValidate = true;
                                    });
                                    return AppLocalizations.of(context)!
                                        .translate(
                                            "Specialization is required");
                                  }
                                  return null;
                                },
                                onTap: () {
                                  setState(() {
                                    _specializationFouce.hasFocus == true;
                                  });
                                },
                                onEditingComplete: () =>
                                    _specializationFouce.unfocus(),
                                onFieldSubmitted: (_) =>
                                    _specializationFouce.unfocus(),
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            27.06666666666667, //30
                      ),
                      _saveAndCancledButton(themeProvider),
                      _isLoading
                          ? Container()
                          : SizedBox(
                              height: MediaQuery.of(context).size.height / 40.6,
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

  void openGallery() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OpenImage(
              imageSend: imageSend != null ? imageSend : null,
              userImage: "https://dev.medical.cayan.co/images/doctor.png"),
        ),
      );
  _addPersonPhoto(ThemeProvider themeProvider) {
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
                        "https://dev.medical.cayan.co/images/doctor.png",
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
          print("add photo");
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

        print('*************************************');
        print(imageSend);
      });
    } on PlatformException catch (e) {
      print("failed to pich image $e");
    }
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
                  onPressedFunction: addPersonMethod,
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

  addPersonMethod() async {
    final unauthorizedError =
        Provider.of<UnauthorizedError>(context, listen: false);

    final storError = Provider.of<TeamWorkStoreError>(context, listen: false);

    final homeServerError =
        Provider.of<HomeServerError>(context, listen: false);

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
        "specialization": _specialization.text,
        "image": imageChoosen == 1
            ? await MultipartFile.fromFile(imageSend!.path, filename: fileName)
            : null,
      });

      final response = await Dio().post(
        Urls.ADD_TEAM_WORK_MEMBER_URL,
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
        print("9999999999999999999999999999999999999999999999999999");
        setState(() {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => TeamWorkScreen()));
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: successOperation(
                      operationName: "add new member successfully"),
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
        print("6666666666666666666666666666666666");
        setState(() {
          storError.teamWorkStoreError442(context, response.data);
          _isLoading = false;
        });
      } else if (response.statusCode == 403) {
        print(response.statusCode);
        setState(() {
          erro403.error403(context, response.statusCode!);
          _isLoading = false;
        });
      } else {
        print(response.statusCode);
        print(response.data);
        setState(() {
          homeServerError.serverError(context, response.statusCode!);
          _isLoading = false;
        });
      }
    }
  }
}
