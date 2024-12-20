import 'dart:math';

import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  operator -(Color color) {
    return pow((r.toRgbValue - color.r.toRgbValue).abs(), 2) +
        pow((g.toRgbValue - color.g.toRgbValue).abs(), 2) +
        pow((b.toRgbValue - color.b.toRgbValue).abs(), 2);
  }

  String toHex({bool leadingHashSign = true, bool includeAlpha = true}) => [
        if (leadingHashSign) '#',
        if (includeAlpha) a.toRgbValue.toRadixString(16).padLeft(2, '0'),
        r.toRgbValue.toRadixString(16).padLeft(2, '0'),
        g.toRgbValue.toRadixString(16).padLeft(2, '0'),
        b.toRgbValue.toRadixString(16).padLeft(2, '0'),
      ].join('');

  static int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }

  int get toInt32 {
    return _floatToInt8(a) << 24 | _floatToInt8(r) << 16 | _floatToInt8(g) << 8 | _floatToInt8(b) << 0;
  }
}

extension on double {
  int get toRgbValue {
    return (this * 255).toInt();
  }
}
