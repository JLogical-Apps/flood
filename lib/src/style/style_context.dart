import 'package:flutter/material.dart';

class StyleContext {
  final Color backgroundColor;
  final Color backgroundColorSoft;

  final Color foregroundColor;
  final Color foregroundColorSoft;

  final Color emphasisColor;
  final Color emphasisColorSoft;

  const StyleContext({
    required this.backgroundColor,
    required this.backgroundColorSoft,
    required this.foregroundColor,
    required this.foregroundColorSoft,
    required this.emphasisColor,
    required this.emphasisColorSoft,
  });

  bool get isDarkBackground => backgroundColor.computeLuminance() < 0.66;
}
