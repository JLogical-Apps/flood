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
