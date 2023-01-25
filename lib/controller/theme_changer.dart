import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThemeChanger extends ChangeNotifier {
  var _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool radiovalue = false;
  void checkTheme(value) {
    print("call theme mode");
    radiovalue = value;

    _themeMode = value ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}
