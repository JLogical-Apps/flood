import 'package:flutter/material.dart';

extension NavigatorExtensions on NavigatorState {
  String? get currentPath {
    String? currentPath;
    popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    return currentPath;
  }
}
