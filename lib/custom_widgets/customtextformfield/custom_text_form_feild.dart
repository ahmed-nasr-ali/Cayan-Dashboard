// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, must_be_immutable

import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/shared_preferences/user_information_data.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatefulWidget {
  final Color cursorColor;
  final bool readOnly;
  final bool enabled;
  final int maxLine;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Color textStyleDarkColor;
  final Color textStyleLightColor;
  final bool isFontBold;
  final Color fillDarkColor;
  final Color fillLightColor;
  final String labelText;
  final bool ispreffix;
  final bool ispreffixImage;
  final String? preffixImageUrl;
  final Widget? preffixWidget;
  final bool isSuffix;
  final bool isSuffixImage;
  final String? suffixImageUrl;
  final Widget? suffixWidget;
  final String hintText;
  final TextInputType? inputData;
  final FormFieldValidator<String>? validationFunc;
  final ValueChanged<String>? onChangedFunc;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  double? contentPadding;

  CustomTextField({
    super.key,
    required this.cursorColor,
    required this.readOnly,
    required this.enabled,
    required this.maxLine,
    required this.focusNode,
    required this.controller,
    required this.textStyleDarkColor,
    required this.textStyleLightColor,
    required this.isFontBold,
    required this.fillDarkColor,
    required this.fillLightColor,
    required this.labelText,
    required this.ispreffix,
    required this.ispreffixImage,
    this.preffixImageUrl,
    this.preffixWidget,
    required this.isSuffix,
    required this.isSuffixImage,
    this.suffixImageUrl,
    this.suffixWidget,
    required this.hintText,
    this.inputData,
    this.validationFunc,
    this.onChangedFunc,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.contentPadding = 0,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextFormField(
      textDirection: UserData.getUSerLang() == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      cursorColor: widget.cursorColor,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: widget.maxLine,
      focusNode: widget.focusNode,
      controller: widget.controller,
      style: TextStyle(
        color: themeProvider.isDarkMode
            ? widget.textStyleDarkColor
            : widget.textStyleLightColor,
        fontSize: MediaQuery.of(context).size.height / 62.46153846153846, //13
        fontWeight: widget.isFontBold ? FontWeight.bold : FontWeight.w400,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: themeProvider.isDarkMode
            ? widget.fillDarkColor
            : widget.fillLightColor,
        // labelText: widget.labelText,
        labelStyle: TextStyle(
          color: widget.focusNode.hasFocus ? mainAppColor : hintColor,
          fontSize: MediaQuery.of(context).size.height / 62.46153846153846, //13
          fontWeight: FontWeight.w400,
        ),

        /// border dimenssion
        /// ====================================================================
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.height / 81.2), //10
          borderSide: BorderSide(
              color: themeProvider.isDarkMode
                  ? containerdarkColor
                  : containerColor),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.height / 81.2),
          borderSide: BorderSide(color: mainAppColor),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.height / 81.2),
          borderSide: BorderSide(color: Colors.red),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.height / 81.2),
          borderSide: BorderSide(color: Colors.red),
        ),

        focusColor: mainAppColor,

        ///prefix widget
        ///=====================================================================
        prefixIcon: widget.ispreffix
            ? widget.ispreffixImage
                ? Image.asset(
                    widget.preffixImageUrl!,
                    color: widget.focusNode.hasFocus
                        ? themeProvider.isDarkMode
                            ? mainAppColor
                            : mainAppColor
                        : hintColor,
                  )
                : widget.preffixWidget
            : null,

        // /suffix widget
        // /=====================================================================
        suffixIcon: widget.isSuffix
            ? widget.isSuffixImage
                ? Image.asset(
                    widget.suffixImageUrl!,
                    color: widget.focusNode.hasFocus
                        ? themeProvider.isDarkMode
                            ? mainAppColor
                            : mainAppColor
                        : hintColor,
                  )
                : widget.suffixWidget
            : null,

        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.contentPadding == 0 ? 5 : widget.contentPadding!,
          vertical: MediaQuery.of(context).size.height / 81.2,
        ),

        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: widget.focusNode.hasFocus
                ? themeProvider.isDarkMode
                    ? whiteColor
                    : blackColor
                : hintColor,
            fontSize:
                MediaQuery.of(context).size.height / 62.46153846153846, //13
            fontWeight:
                widget.focusNode.hasFocus ? FontWeight.bold : FontWeight.w400),
      ),
      keyboardType: widget.inputData,
      obscureText: false,
      validator: widget.validationFunc,
      onChanged: widget.onChangedFunc,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
