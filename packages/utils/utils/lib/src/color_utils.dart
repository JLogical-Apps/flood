import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  operator -(Color color) {
    return (red - color.red).abs() + (green - color.green).abs() + (blue - color.blue).abs();
  }
}
