// ignore_for_file: prefer_final_fields, unused_field, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_print, curly_braces_in_flow_control_structures, prefer_adjacent_string_concatenation

import 'package:flutter/foundation.dart';

class AddRolesAndPerimissionsProvider extends ChangeNotifier {
  List<int> _categoryId = [];

  addRolesAndPerimssionId(int id) {
    _categoryId.contains(id)
        ? _categoryId.removeWhere((item) => item == id)
        : _categoryId.add(id);
  }

  List get categoryID => _categoryId;
}
