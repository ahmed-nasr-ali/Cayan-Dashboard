import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///===========================================================================

  ///set user lang
  static setUserLang(String userLang) async {
    await _preferences!.setString("userlang", userLang);
  }

  static String getUSerLang() {
    return _preferences!.getString("userlang") ?? "";
  }

  ///===========================================================================
  /// is grid
  static setIsGridOrNot(bool isGrid) async {
    await _preferences!.setBool("_IsGrid", isGrid);
  }

  static bool getIsGridOrNot() {
    return _preferences!.getBool("_IsGrid") ?? false;
  }

  ///current mode
  static setUserMode(String userMode) async =>
      await _preferences!.setString('_UserMode', userMode);

  static String getUserMode() {
    return _preferences!.getString('_UserMode') ?? "";
  }

  ///api token
  static setUserApiToken(String userToken) async =>
      await _preferences!.setString('_userApiToken', userToken);

  static String getUserApiToken() {
    return _preferences!.getString('_userApiToken') ?? "";
  }

  ///api token
  static setUserId(int userId) async =>
      await _preferences!.setInt('_userId', userId);

  static getUserId() {
    return _preferences!.getInt('_userId');
  }

  ///permissions
  ///===========================================================================
  ///permissions id
  static setPermissionsId(int id) async =>
      await _preferences!.setInt("_permissionsId", id);

  static getPermissionsId() {
    return _preferences!.getInt("_permissionsId") ?? 0;
  }

  //====================================

  ///permissions name
  static setPermissionsName(String name) async =>
      await _preferences!.setString("_permissionsName", name);

  static getPermissionsName() {
    return _preferences!.getString("_permissionsName") ?? "";
  }

  //====================================

  ///permissions guard_name
  static setPermissionsGuardName(String guardName) async =>
      await _preferences!.setString("_permissionsGuardName", guardName);

  static getPermissionsGuardName() {
    return _preferences!.getString("_permissionsGuardName") ?? "";
  }

  ///country data
  ///===========================================================================
  ///country id
  static setCountryId(int id) async =>
      await _preferences!.setInt("_countryID", id);

  static getCountryId() {
    return _preferences!.getInt("_countryID") ?? 0;
  }

  //====================================

  ///country name
  static setCountryName(String name) async =>
      await _preferences!.setString("_countryName", name);

  static getCountryName() {
    return _preferences!.getString("_countryName") ?? "";
  }

  //====================================

  ///country code
  static setCountryCode(String code) async =>
      await _preferences!.setString("_countryCode", code);

  static getCountryCode() {
    return _preferences!.getString("_countryCode") ?? "";
  }

  //====================================

  ///country image
  static setCountryImage(String image) async =>
      await _preferences!.setString("_countryImage", image);

  static getCountryImage() {
    return _preferences!.getString("_countryImage") ?? "";
  }

  ///edit employee country data
  ///===========================================================================
  ///country id
  static setEditEmloyeeCountryId(int id) async =>
      await _preferences!.setInt("_editEmloyeecountryID", id);

  static getEditEmloyeeCountryId() {
    return _preferences!.getInt("_editEmloyeecountryID") ?? 0;
  }

  //====================================

  ///country name
  static setEditEmloyeeCountryName(String name) async =>
      await _preferences!.setString("_editEmloyeecountryName", name);

  static getEditEmloyeeCountryName() {
    return _preferences!.getString("_editEmloyeecountryName") ?? "";
  }

  //====================================

  ///country code
  static setEditEmloyeeCountryCode(String code) async =>
      await _preferences!.setString("_editEmloyeecountryCode", code);

  static getEditEmloyeeCountryCode() {
    return _preferences!.getString("_editEmloyeecountryCode") ?? "";
  }

  //====================================

  ///country image
  static setEditEmloyeeCountryImage(String image) async =>
      await _preferences!.setString("_editEmloyeecountryImage", image);

  static getEditEmloyeeCountryImage() {
    return _preferences!.getString("_editEmloyeecountryImage") ?? "";
  }

  ///edit employee permissions
  ///===========================================================================
  ///permissions id
  static setEditEmployeePermissionsId(int id) async =>
      await _preferences!.setInt("_EditEmployeePermissionsId", id);

  static getEditEmployeePermissionsId() {
    return _preferences!.getInt("_EditEmployeePermissionsId") ?? 0;
  }

  //====================================

  ///permissions name
  static setEditEmployeePermissionsName(String name) async =>
      await _preferences!.setString("_EditEmployeePermissionsName", name);

  static getEditEmployeePermissionsName() {
    return _preferences!.getString("_EditEmployeePermissionsName") ?? "";
  }

  //====================================

  ///permissions guard_name
  static setEditEmployeePermissionsGuardName(String guardName) async =>
      await _preferences!
          .setString("_EditEmployeePermissionsGuardName", guardName);

  static getEditEmployeePermissionsGuardName() {
    return _preferences!.getString("_EditEmployeePermissionsGuardName") ?? "";
  }
}
