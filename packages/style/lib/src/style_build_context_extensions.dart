import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:style/src/color_palette.dart';
import 'package:style/src/style.dart';

extension StyleBuildContextExtensions on BuildContext {
  Style style() {
    return Provider.of<Style>(this, listen: false);
  }

  ColorPalette colorPalette() {
    return Provider.of<ColorPalette>(this, listen: false);
  }
}
