import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'themes/light.dart';

enum AppTheme {
  Light,
  Dark,
}

String enumName(AppTheme anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appThemeData = {
  AppTheme.Light: lightTheme,
  AppTheme.Dark: darkTheme,
};

class SettingsStore extends InheritedWidget {
  final ValueNotifier<ThemeData> theme =
      ValueNotifier(appThemeData[AppTheme.Light]);
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final String _kThemePreference = 'theme_preference';

  SettingsStore({@required Widget child}) : super(child: child) {
    _loadTheme();
  }

  static SettingsStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SettingsStore>();

  void _loadTheme() async {
    final SharedPreferences prefs = await _prefs;
    int theme = prefs.getInt(_kThemePreference) ?? 0;
    updateTheme(AppTheme.values[theme]);
  }

  void updateTheme(AppTheme theme) async {
    this.theme.value = appThemeData[theme];
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(_kThemePreference, AppTheme.values.indexOf(theme));
  }

  @override
  bool updateShouldNotify(SettingsStore oldWidget) =>
      oldWidget.theme != this.theme;
}
