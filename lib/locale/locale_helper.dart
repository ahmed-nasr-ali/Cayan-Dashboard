// ignore_for_file: prefer_generic_function_type_aliases, unnecessary_new

import 'package:flutter/material.dart';

typedef void LocaleChangeCallback(Locale locale);

class LocaleHelper extends ChangeNotifier {
  late LocaleChangeCallback onLocaleChanged;

  static final LocaleHelper _helper = new LocaleHelper._internal();
  factory LocaleHelper() {
    return _helper;
  }

  LocaleHelper._internal();
}

LocaleHelper helper = new LocaleHelper();
