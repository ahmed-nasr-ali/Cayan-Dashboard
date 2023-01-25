// ignore_for_file: must_be_immutable

import 'package:cayan/providers/theme_provider.dart';
import 'package:cayan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BigText extends StatelessWidget {
  final String text;
  Color? color;
  double size;
  TextOverflow? overflow;
  int? typeOfFontWieght;
  TextAlign align;
  FontWeight fontWeight;

  BigText({
    Key? key,
    required this.text,
    this.color = const Color(0xFF000000),
    this.size = 0,
    this.overflow = TextOverflow.ellipsis,
    this.typeOfFontWieght = 0,
    this.align = TextAlign.center,
    this.fontWeight = FontWeight.w400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      textAlign: align,
      // ignore: prefer_const_constructors
      style: TextStyle(
        color: color == const Color(0xFF000000)
            ? (themeProvider.isDarkMode ? whiteColor : blackColor)
            : color,
        fontSize: size == 0
            ? MediaQuery.of(context).size.height / 47.76470588235294
            : size, //17
        fontWeight: typeOfFontWieght == 0 ? fontWeight : FontWeight.bold,
        fontFamily: 'RB',
      ),
    );
  }
}

// class CustomTextFormField extends StatefulWidget {
//   final double hasHorizontalMargin;
//   final double hasVerticalMargin;
//   final bool readOnly;
//   final bool enaled;
//   final int maxline;
//   final TextEditingController controller;
//   final String? labelText;
//   final String? hintText;
//   // final String errorText;
//   final TextInputType inputData;
//   final VoidCallback? ontap;
//   final FormFieldValidator<String>? validationFunc;
//   final ValueChanged<String>? onChangedFunc;
//   Widget? suffix;
//   final bool? isPassward;

//   final bool? isImage;
//   final String? suffixIconImagePath;
//   Widget? prefix;
//   bool obsecureText;

//   final Widget? prefixIcon;
//   final bool? prefixIconIsImage;
//   final String? prefixIconImagePath;
//   final bool isprefix;
//   final bool isSuffix;

//   CustomTextFormField({
//     super.key,
//     required this.hasHorizontalMargin,
//     this.ontap,
//     required this.hasVerticalMargin,
//     required this.readOnly,
//     required this.enaled,
//     required this.maxline,
//     required this.controller,
//     this.labelText,
//     this.hintText,
//     // required this.errorText,
//     required this.inputData,
//     this.validationFunc,
//     this.onChangedFunc,
//     required this.isSuffix,
//     this.suffix,
//     this.isPassward = false,
//     this.isImage = false,
//     this.suffixIconImagePath,
//     this.prefix,
//     required this.obsecureText,
//     required this.isprefix,
//     this.prefixIcon,
//     this.prefixIconIsImage,
//     this.prefixIconImagePath,
//   });

//   @override
//   State<CustomTextFormField> createState() => _CustomTextFormFieldState();
// }

// class _CustomTextFormFieldState extends State<CustomTextFormField> {
//   late FocusNode _focusNode;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//   }

//   @override
//   void dispose() {
//     // Clean up the focus node when the Form is disposed.
//     _focusNode.dispose();

//     super.dispose();
//   }

//   Widget _buildTextFormField(ThemeProvider themeProvider) {
//     return TextFormField(
//       readOnly: widget.readOnly,
//       enabled: widget.enaled,
//       maxLines: widget.maxline,
//       controller: widget.controller,
//       focusNode: _focusNode, //todo check
//       style: TextStyle(
//           color: themeProvider.isDarkMode ? whiteColor : blackColor,
//           fontSize: MediaQuery.of(context).size.height / 62.46153846153846, //13
//           fontWeight: FontWeight.bold),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: themeProvider.isDarkMode ? containerdarkColor : whiteColor,
//         labelText: widget.labelText,
//         labelStyle: TextStyle(
//           color: _focusNode.hasFocus ? mainAppColor : hintColor,
//           fontSize: MediaQuery.of(context).size.height / 62.46153846153846, //13
//           fontWeight: FontWeight.w400,
//         ),

//         /// border color
//         enabledBorder: OutlineInputBorder(
//           borderRadius:
//               BorderRadius.circular(MediaQuery.of(context).size.height / 81.2),
//           borderSide: BorderSide(
//               color: themeProvider.isDarkMode
//                   ? containerdarkColor
//                   : containerColor),
//         ),
//         focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(
//                 MediaQuery.of(context).size.height / 81.2),
//             borderSide: BorderSide(color: mainAppColor)),
//         // errorStyle: TextStyle(
//         //   fontSize: 11.0,
//         //   fontWeight: FontWeight.w400,
//         // ),
//         // errorBorder: OutlineInputBorder(
//         //   borderRadius: BorderRadius.circular(10),
//         //   borderSide: BorderSide(color: Colors.red),
//         // ),
//         // errorText: widget.errorText,
//         focusColor: mainAppColor,
//         contentPadding: EdgeInsets.symmetric(
//             horizontal: MediaQuery.of(context).size.width / 37.5,
//             vertical: MediaQuery.of(context).size.height / 81.2),

//         ///========================================================================
//         ///end border color

//         hintText: widget.hintText,
//         hintStyle: TextStyle(
//             color: _focusNode.hasFocus ? blackColor : hintColor,
//             fontSize:
//                 MediaQuery.of(context).size.height / 62.46153846153846, //13
//             fontWeight:
//                 _focusNode.hasFocus ? FontWeight.bold : FontWeight.w400),

//         ///sufix part
//         ///if passward true  or false u needed to input ismage
//         suffix: widget.suffix,
//         suffixIcon: widget.isSuffix
//             ? widget.isPassward!
//                 ? InkWell(
//                     onTap: () {
//                       setState(() {});
//                       widget.obsecureText = !widget.obsecureText;
//                     },
//                     child: Image.asset(
//                       "assets/images/show.png",
//                       color:
//                           _focusNode.hasFocus ? mainAppColor : containerColor,
//                     ),
//                   )
//                 : widget.isImage!
//                     ? _focusNode.hasFocus
//                         ? InkWell(
//                             child: Image.asset(
//                               widget.suffixIconImagePath!,
//                               color: mainAppColor,
//                               height: 25,
//                               width: 25,
//                             ),
//                           )
//                         : InkWell(
//                             child: Image.asset(
//                               widget.suffixIconImagePath!,
//                               color: hintColor,
//                               height: 25,
//                               width: 25,
//                             ),
//                           )
//                     : Container()
//             : Container(),

//         ///suffix part end
//         ///=================================================================
//         ///
//         ///is isprefix true u needed to add prefixIconIsImage, prefixIcon , prefixIconImagePath
//         prefix: widget.prefix,
//         prefixIcon: widget.isprefix
//             ? !widget.prefixIconIsImage!
//                 ? widget.prefixIcon
//                 : _focusNode.hasFocus
//                     ? Image.asset(
//                         widget.prefixIconImagePath!,
//                         color: mainAppColor,
//                         height: 25,
//                         width: 25,
//                       )
//                     : Image.asset(
//                         widget.prefixIconImagePath!,
//                         color: hintColor,
//                         height: 25,
//                         width: 25,
//                       )
//             : Container(),
//       ),
//       obscureText: widget.obsecureText,
//       keyboardType: widget.inputData,
//       validator: widget.validationFunc,
//       onChanged: widget.onChangedFunc,
//       onTap: widget.ontap,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return LayoutBuilder(builder: (context, constraints) {
//       return Container(
//           margin: EdgeInsets.symmetric(
//             horizontal: widget.hasHorizontalMargin,
//             vertical: widget.hasVerticalMargin,
//           ),
//           child: _buildTextFormField(themeProvider));
//     });
//   }
// }

