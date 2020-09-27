import 'package:flutter/material.dart';
import 'package:iut_lr_app/constants.dart';

ThemeData get lightTheme => ThemeData.light().copyWith(
      primaryColor: kIUTLaRochelleColor,
      backgroundColor: kBackgroundColor,
      appBarTheme: AppBarTheme(
        color: kAppBarColor,
      ),
      cardColor: kCardColor,
      textTheme: lightTextTheme,
      indicatorColor: kIUTLaRochelleColor,
    );

ThemeData get darkTheme => ThemeData.dark().copyWith(
      primaryColor: kIUTLaRochelleColor,
      backgroundColor: kDarkBackgroundColor,
      appBarTheme: AppBarTheme(
        color: kDarkCardColor,
      ),
      cardColor: kDarkAppBarColor,
      textTheme: darkTextTheme,
      indicatorColor: kIUTLaRochelleColor,
    );

TextTheme get lightTextTheme => ThemeData.light().textTheme.copyWith(
      headline6: ThemeData.light().textTheme.headline6.copyWith(
            fontWeight: FontWeight.w700,
          ),
      headline4: ThemeData.light().textTheme.headline4.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
    );

TextTheme get darkTextTheme => lightTextTheme.copyWith(
      headline6: lightTextTheme.headline6.copyWith(
        color: Colors.white,
      ),
      headline4: lightTextTheme.headline4.copyWith(
        color: Colors.white,
      ),
      subtitle1: lightTextTheme.subtitle1.copyWith(
        color: kDarkPrimaryLabelColor,
      ),
      bodyText1: lightTextTheme.bodyText1.copyWith(
        color: kDarkPrimaryLabelColor,
      ),
    );
