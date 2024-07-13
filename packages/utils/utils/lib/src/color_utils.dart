import 'dart:math';

import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  operator -(Color color) {
    return pow((red - color.red).abs(), 2) + pow((green - color.green).abs(), 2) + pow((blue - color.blue).abs(), 2);
  }

  String toHex({bool leadingHashSign = true, bool includeAlpha = true}) => [
        if (leadingHashSign) '#',
        if (includeAlpha) alpha.toRadixString(16).padLeft(2, '0'),
        red.toRadixString(16).padLeft(2, '0'),
        green.toRadixString(16).padLeft(2, '0'),
        blue.toRadixString(16).padLeft(2, '0'),
      ].join('');
}
