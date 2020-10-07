import 'dark.dart';
import 'light.dart';
import 'shrine.dart';

enum AppTheme {
  Light,
  Dark,
  Shrine,
}

String enumName(AppTheme anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appThemeData = {
  AppTheme.Light: lightTheme,
  AppTheme.Dark: darkTheme,
  AppTheme.Shrine: buildShrineTheme(),
};
