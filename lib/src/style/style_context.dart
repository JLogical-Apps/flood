import 'package:flutter/material.dart';

class StyleContext {
  final Color backgroundColor;

  const StyleContext({required this.backgroundColor});

  bool get isDarkBackground => backgroundColor.computeLuminance() < 0.5;

  StyleContext copyWith({Color? backgroundColor}) {
    return StyleContext(backgroundColor: backgroundColor ?? this.backgroundColor);
  }
}
