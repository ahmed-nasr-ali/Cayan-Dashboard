import 'package:shared_preferences/shared_preferences.dart';

class ServicesUserData {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///Category id
  static setCategoryId(int id) async =>
      await _preferences!.setInt("_CategoryId", id);

  static getCategoryId() {
    return _preferences!.getInt("_CategoryId") ?? 0;
  }

  ///===========================================================================
  ///Category Name
  static setCategoryName(String name) async =>
      await _preferences!.setString("_CategoryName", name);

  static getCategoryName() {
    return _preferences!.getString("_CategoryName") ?? "";
  }

  ///user Category id
  static setEditCategoryId(int id) async =>
      await _preferences!.setInt("_EditCategoryId", id);

  static getEditCategoryId() {
    return _preferences!.getInt("_EditCategoryId") ?? 0;
  }
}
