import 'package:flutter/material.dart';
import 'package:iut_lr_app/themes/colors.dart';

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: CustomColor.darkBlue[800],
    cardColor: CustomColor.darkBlue[500],
    appBarTheme: AppBarTheme(
      color: CustomColor.darkBlue[600],
    ),
    indicatorColor: CustomColor.darkBlueAccent[200],
  );
}
