import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<bool> setUserLang(String language) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("lang", language);
  }

  static Future<String> getUserLang() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("lang") ?? 'ar';
  }

  static Future<bool> setIsFirstTime(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("first_time", value);
  }

  static Future<bool> checkIsFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("first_time") ?? true;
  }

  static Future<bool> setlangbool(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("langbool", value);
  }

  static Future<bool> getlangbool() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("langbool") ?? true;
  }
  // static read(String? key) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString(key!) != null) {
  //     return json.decode(prefs.getString(key).toString());
  //   } else {
  //     return null;
  //   }
  // }

  // static save(String key, value) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(key, json.encode(value));
  // }

  // static remove(String key) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove(key);
  // }

  /// save value "first_time" to show intro of the app or not

  ///-----------------
  ///Save boolean values
  ///------------------

  // static Future<bool?> getBoolean(String key) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.containsKey(key) ? prefs.getBool(key) : false;
  // }

  // static Future<bool> saveBoolean(
  //     String key, bool value, SharedPreferences prefs) {
  //   return prefs.setBool(key, value);
  // }

  // static Future<bool> setUserToken(String token) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString("token", token);
  // }

  // static Future<String?> getUsersetUserToken() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString("token");
  // }
}
