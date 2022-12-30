import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_h5.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/components/text/styled_text_builder.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleH5Renderer with IsTextStyleRenderer<StyledH5> {
  @override
  StyledTextBuilder<StyledH5> get baseTextBuilder => StyledText.h5;

  @override
  TextStyle getTextStyle(BuildContext context, StyledText text) {
    return TextStyle(
      fontSize: 22,
      color: text.color ?? context.colorPalette().foreground.getByEmphasis(text.emphasis),
      fontStyle: text.fontStyle,
    );
  }

  @override
  String get textName => 'H5';
}
