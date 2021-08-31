import 'package:flutter/material.dart';

class StyleContext {
  final Color backgroundColor;
  final Color backgroundColorSoft;

  final Color foregroundColor;
  final Color foregroundColorSoft;

  final Color emphasisColor;
  final Color emphasisColorSoft;

  final StyleContext Function() getSoftened;

  const StyleContext({
    required this.backgroundColor,
    required this.backgroundColorSoft,
    required this.foregroundColor,
    required this.foregroundColorSoft,
    required this.emphasisColor,
    required this.emphasisColorSoft,
    required this.getSoftened,
  });

  bool get isDarkBackground => backgroundColor.computeLuminance() < 0.66;

  StyleContext copyWith({
    Color? backgroundColor,
    Color? backgroundColorSoft,
    Color? foregroundColor,
    Color? foregroundColorSoft,
    Color? emphasisColor,
    Color? emphasisColorSoft,
  }) {
    return StyleContext(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundColorSoft: backgroundColorSoft ?? this.backgroundColorSoft,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      foregroundColorSoft: foregroundColorSoft ?? this.foregroundColorSoft,
      emphasisColor: emphasisColor ?? this.emphasisColor,
      emphasisColorSoft: emphasisColorSoft ?? this.emphasisColorSoft,
      getSoftened: getSoftened,
    );
  }
}
