import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  // 這是 ViewModel
  // brightness 用來切換主題是Model
  Brightness _brightness = Brightness.light;
  Brightness get brightness => _brightness;

  void toggleTheme() {
    _brightness =
        _brightness == Brightness.light ? Brightness.dark : Brightness.light;
    notifyListeners();
  }
}
