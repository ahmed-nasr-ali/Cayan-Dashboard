import 'package:shared_preferences/shared_preferences.dart';

class UserInformation {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///===========================================================================
  static setUserCountryId(int id) async =>
      await _preferences!.setInt("_UserCountryId", id);

  static getUserCountryId() {
    return _preferences!.getInt("_UserCountryId") ?? 0;
  }

  //====================================

  ///country name
  static setUsercountryName(String name) async =>
      await _preferences!.setString("_UsercountryName", name);

  static getUsercountryName() {
    return _preferences!.getString("_UsercountryName") ?? "";
  }

  //====================================

  ///country code
  static setUsercountryCode(String code) async =>
      await _preferences!.setString("_UsercountryCode", code);

  static getUsercountryCode() {
    return _preferences!.getString("_UsercountryCode") ?? "";
  }

  //====================================

  ///country image
  static setUsercountryImage(String image) async =>
      await _preferences!.setString("_UsercountryImage", image);

  static getUsercountryImage() {
    return _preferences!.getString("_UsercountryImage") ?? "";
  }
}
