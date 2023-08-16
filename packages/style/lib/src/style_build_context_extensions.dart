import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:style/src/color_palette.dart';
import 'package:style/src/components/dialog/styled_dialog.dart';
import 'package:style/src/components/message/styled_message.dart';
import 'package:style/src/style.dart';

extension StyleBuildContextExtensions on BuildContext {
  Style style() {
    return Provider.of<Style>(this, listen: false);
  }

  ColorPalette colorPalette() {
    return Provider.of<ColorPalette>(this, listen: false);
  }

  Future<T?> showStyledDialog<T>(StyledDialog<T> dialog) async {
    return await style().showDialog(this, dialog);
  }

  Future<void> showStyledMessage(StyledMessage message) async {
    return await style().showMessage(this, message);
  }
}
