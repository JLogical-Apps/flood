import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

extension BuildContextPondExtensions on BuildContext {
  T find<T>() {
    return appPondContext.find<T>();
  }

  T? findOrNull<T>() {
    return appPondContext.findOrNull<T>();
  }
}
