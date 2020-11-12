import 'package:flutter/material.dart';

class CustomColor {
  static const MaterialColor darkBlue =
      MaterialColor(_darkBluePrimaryValue, <int, Color>{
    50: Color(0xFFE3E4E6),
    100: Color(0xFFB9BCBF),
    200: Color(0xFF8A9095),
    300: Color(0xFF5B636B),
    400: Color(0xFF38414B),
    500: Color(_darkBluePrimaryValue),
    600: Color(0xFF121C26),
    700: Color(0xFF0F1820),
    800: Color(0xFF0C131A),
    900: Color(0xFF060B10),
  });
  static const int _darkBluePrimaryValue = 0xFF15202B;

  static const MaterialColor darkBlueAccent =
      MaterialColor(_darkBlueAccentValue, <int, Color>{
    100: Color(0xFF53A7FF),
    200: Color(_darkBlueAccentValue),
    400: Color(0xFF0073EC),
    700: Color(0xFF0066D3),
  });
  static const int _darkBlueAccentValue = 0xFF208CFF;
}
