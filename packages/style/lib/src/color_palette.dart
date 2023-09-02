import 'package:flutter/material.dart';
import 'package:style/src/emphasis.dart';

class ColorPalette extends Color {
  final Color baseBackground;
  final ColorPalette Function() strongForegroundColorPaletteGetter;
  final ColorPalette Function() regularForegroundColorPaletteGetter;
  final ColorPalette Function() subtleForegroundColorPaletteGetter;
  final ColorPalette Function() strongBackgroundColorPaletteGetter;
  final ColorPalette Function() regularBackgroundColorPaletteGetter;
  final ColorPalette Function() subtleBackgroundColorPaletteGetter;
  final ColorPalette Function() strongErrorColorPaletteGetter;
  final ColorPalette Function() regularErrorColorPaletteGetter;
  final ColorPalette Function() subtleErrorColorPaletteGetter;

  ColorPalette({
    required this.baseBackground,
    required this.strongForegroundColorPaletteGetter,
    required this.regularForegroundColorPaletteGetter,
    required this.subtleForegroundColorPaletteGetter,
    required this.strongBackgroundColorPaletteGetter,
    required this.regularBackgroundColorPaletteGetter,
    required this.subtleBackgroundColorPaletteGetter,
    required this.strongErrorColorPaletteGetter,
    required this.regularErrorColorPaletteGetter,
    required this.subtleErrorColorPaletteGetter,
  }) : super(baseBackground.value);

  ColorPaletteContext get background => ColorPaletteContext(
        strongColorPaletteGetter: strongBackgroundColorPaletteGetter,
        regularColorPaletteGetter: regularBackgroundColorPaletteGetter,
        subtleColorPaletteGetter: subtleBackgroundColorPaletteGetter,
      );

  ColorPaletteContext get foreground => ColorPaletteContext(
        strongColorPaletteGetter: strongForegroundColorPaletteGetter,
        regularColorPaletteGetter: regularForegroundColorPaletteGetter,
        subtleColorPaletteGetter: subtleForegroundColorPaletteGetter,
      );

  ColorPaletteContext get error => ColorPaletteContext(
        strongColorPaletteGetter: strongErrorColorPaletteGetter,
        regularColorPaletteGetter: regularErrorColorPaletteGetter,
        subtleColorPaletteGetter: subtleErrorColorPaletteGetter,
      );
}

class ColorPaletteContext {
  final ColorPalette Function() strongColorPaletteGetter;
  final ColorPalette Function() regularColorPaletteGetter;
  final ColorPalette Function() subtleColorPaletteGetter;

  ColorPaletteContext({
    required this.strongColorPaletteGetter,
    required this.regularColorPaletteGetter,
    required this.subtleColorPaletteGetter,
  });

  ColorPalette get strong => strongColorPaletteGetter();

  ColorPalette get regular => regularColorPaletteGetter();

  ColorPalette get subtle => subtleColorPaletteGetter();

  ColorPalette getByEmphasis(Emphasis emphasis) {
    switch (emphasis) {
      case Emphasis.strong:
        return strong;
      case Emphasis.regular:
        return regular;
      case Emphasis.subtle:
        return subtle;
    }
  }
}
