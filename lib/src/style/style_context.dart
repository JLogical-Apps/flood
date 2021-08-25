import 'package:flutter/material.dart';

import '../../jlogical_utils.dart';

class StyleContext {
  final Color backgroundColor;
  final Emphasis emphasis;

  const StyleContext({required this.backgroundColor, required this.emphasis});

  bool get isDarkBackground => backgroundColor.computeLuminance() < 0.5;

  StyleContext copyWith({Color? backgroundColor, Emphasis? emphasis}) {
    return StyleContext(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      emphasis: emphasis ?? this.emphasis,
    );
  }
}
