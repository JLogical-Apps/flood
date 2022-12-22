import 'package:flutter/material.dart';
import 'package:style/src/color_palette.dart';
import 'package:style/src/style_component.dart';
import 'package:style/src/styleguide.dart';

abstract class Style {
  Widget render(BuildContext context, StyleComponent component);

  Styleguide getStyleguide();

  ColorPalette get colorPalette;
}

mixin IsStyle implements Style {}
