import 'package:flutter/material.dart';

import '../constants.dart';
import 'light.dart';

ThemeData get darkTheme => ThemeData.dark().copyWith(
      primaryColor: kIUTLaRochelleColor,
      backgroundColor: kDarkBackgroundColor,
      appBarTheme: AppBarTheme(
        color: kDarkAppBarColor,
      ),
      cardColor: kDarkCardColor,
      textTheme: darkTextTheme,
      indicatorColor: Color(0xFF1da1f2),
    );
