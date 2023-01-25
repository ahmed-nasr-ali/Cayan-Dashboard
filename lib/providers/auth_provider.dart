// ignore_for_file: unused_element, unused_local_variable, avoid_print, use_build_context_synchronously, prefer_const_constructors

// import 'dart:convert';

// import 'package:cayan/ui/Home/home_screen.dart';
// import 'package:cayan/utils/urls.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';

// class AuthProvider extends ChangeNotifier {
//   ///set user Emaill
//   String? _userEmail;

//   void setUserEmail(String userEmail) {
//     _userEmail = userEmail;
//     notifyListeners();
//   }

//   String get userEmail => _userEmail!;

//   ///=================================================

//   ///set user passward
//   String? _userPassward;

//   void setUserPassward(String userPassward) {
//     _userPassward = userPassward;
//     notifyListeners();
//   }

//   String get userPassward => _userPassward!;

//   ///=================================================

//   userLogIn(dynamic body, BuildContext context) async {
//     print('come here');
//     final response = await post(
//       Uri.parse(
//         Urls.LOGIN_URL_,
//       ),
//       headers: <String, String>{
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(body),
//     );
//     if (response.statusCode == 200) {
//       print(response.body);
//       var body = jsonDecode(response.body);
//       print('777777777777777777777777777777777777777');
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomeScreen(),
//         ),
//       );
//     } else if (response.statusCode == 422) {
//       var body = jsonDecode(response.body);
//       print('66666666666666666666666666666666666');
//       print(body);
//     }
//     notifyListeners();
//   }
// }
