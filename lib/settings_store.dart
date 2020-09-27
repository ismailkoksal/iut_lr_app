import 'package:flutter/material.dart';

import 'themes/light.dart';

class SettingsStore extends InheritedWidget {
  final ValueNotifier<ThemeData> theme = ValueNotifier(darkTheme);

  SettingsStore({@required Widget child}) : super(child: child);

  static SettingsStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SettingsStore>();

  void updateTheme(ThemeData theme) => this.theme.value = theme;

  @override
  bool updateShouldNotify(SettingsStore oldWidget) =>
      oldWidget.theme != this.theme;
}
