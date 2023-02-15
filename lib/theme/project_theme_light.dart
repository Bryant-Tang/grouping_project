import 'package:flutter/material.dart';
import './color.dart';
class LightThemeData{
  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    primaryColorLight: ThemeColor.primary,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 20.0,
        color: ThemeColor.titleText,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}