import 'package:flutter/material.dart';

class StyleContext {
  final Color backgroundColor;
  final Color backgroundColorSoft;

  final Color foregroundColor;
  final Color foregroundColorSoft;

  final Color primaryColor;
  final Color primaryColorSoft;

  final Color accentColor;
  final Color accentColorSoft;

  const StyleContext({
    required this.backgroundColor,
    required this.backgroundColorSoft,
    required this.foregroundColor,
    required this.foregroundColorSoft,
    required this.primaryColor,
    required this.primaryColorSoft,
    required this.accentColor,
    required this.accentColorSoft,
  });

  bool get isDarkBackground => backgroundColor.computeLuminance() < 0.66;
}
