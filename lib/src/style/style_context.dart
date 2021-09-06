import 'package:flutter/material.dart';

/// Contains information for how a [Style] should render a [StyledWidget].
/// Each of the colors have a soft variant, which is a color similar to the main color with some slight contrast.
class StyleContext {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color emphasisColor;

  /// Whether the styled widgets should compose themselves in a dense format.
  final bool isDense;

  Color get backgroundColorSoft => getSoftened(backgroundColor);

  Color get foregroundColorSoft => getSoftened(foregroundColor);

  Color get emphasisColorSoft => getSoftened(emphasisColor);

  /// Function to convert a [color] to a softened version of that color.
  final Color Function(Color color) getSoftened;

  bool get isDarkBackground => backgroundColor.computeLuminance() < 0.66;

  const StyleContext({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.emphasisColor,
    required this.getSoftened,
    this.isDense: false,
  });

  StyleContext copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? emphasisColor,
    bool? isDense,
  }) {
    return StyleContext(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      emphasisColor: emphasisColor ?? this.emphasisColor,
      getSoftened: getSoftened,
      isDense: isDense ?? this.isDense,
    );
  }
}
