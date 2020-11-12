import 'dark.dart';
import 'light.dart';

enum AppTheme {
  Light,
  Dark,
}

String enumName(AppTheme anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appThemeData = {
  AppTheme.Light: buildLightTheme(),
  AppTheme.Dark: buildDarkTheme(),
};
