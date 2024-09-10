import 'package:flutter/material.dart';
import 'package:style/src/color_palette.dart';
import 'package:style/src/components/dialog/styled_dialog.dart';
import 'package:style/src/components/message/styled_message.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_component.dart';
import 'package:style/src/styleguide.dart';

abstract class Style {
  Widget render(BuildContext context, StyleComponent component);

  Styleguide getStyleguide();

  ColorPalette get colorPalette;

  ColorPalette getColorPaletteFromBackground(Color backgroundColor);

  TextStyle getTextStyle(BuildContext context, StyledText text);

  Future<T?> showDialog<T>(BuildContext context, StyledDialog<T> dialog);

  Future<void> showMessage(BuildContext context, StyledMessage message);
}

mixin IsStyle implements Style {}

abstract class StyleWrapper implements Style {
  Style get style;
}

mixin IsStyleWrapper implements StyleWrapper {
  @override
  Widget render(BuildContext context, StyleComponent component) => style.render(context, component);

  @override
  Styleguide getStyleguide() => style.getStyleguide();

  @override
  ColorPalette get colorPalette => style.colorPalette;

  @override
  ColorPalette getColorPaletteFromBackground(Color backgroundColor) =>
      style.getColorPaletteFromBackground(backgroundColor);

  @override
  TextStyle getTextStyle(BuildContext context, StyledText text) => style.getTextStyle(context, text);

  @override
  Future<T?> showDialog<T>(BuildContext context, StyledDialog<T> dialog) => style.showDialog(context, dialog);

  @override
  Future<void> showMessage(BuildContext context, StyledMessage message) => style.showMessage(context, message);
}
