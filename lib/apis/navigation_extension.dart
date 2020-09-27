import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  navigateTo(Widget destination) {
    Navigator.of(this).push(
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
