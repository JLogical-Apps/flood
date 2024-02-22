import 'dart:math';

import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  operator -(Color color) {
    return pow((red - color.red).abs(), 2) + pow((green - color.green).abs(), 2) + pow((blue - color.blue).abs(), 2);
  }
}
