import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThemeManager with ChangeNotifier {
  // 這是 ViewModel
  // brightness 用來切換主題是Model
  Brightness _brightness = Brightness.light;
  Brightness get brightness => _brightness;
  IconData themeIcon = Icons.wb_sunny;
  IconData get icon => themeIcon;
  Widget coverLogo = SvgPicture.asset(
    "assets/images/logo_light.svg",
    semanticsLabel: 'Grouping Logo',
  );
  Widget get logo => coverLogo;
  void toggleTheme() {
    themeIcon =
        _brightness == Brightness.light ? Icons.nightlight_round : Icons.wb_sunny;
    coverLogo =
       _brightness == Brightness.light ? SvgPicture.asset(
        "assets/images/logo_dark.svg",
        semanticsLabel: 'Grouping Logo',
      ) : SvgPicture.asset(
        "assets/images/logo_light.svg",
        semanticsLabel: 'Grouping Logo',
      );
    _brightness =
        _brightness == Brightness.light ? Brightness.dark : Brightness.light;
    notifyListeners();
  }
}
