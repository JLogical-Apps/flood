import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_h3.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/components/text/styled_text_builder.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleH3Renderer with IsTextStyleRenderer<StyledH3> {
  @override
  StyledTextBuilder<StyledH3> get baseTextBuilder => StyledText.h3;

  @override
  TextStyle getTextStyle(BuildContext context, StyledText text) {
    return TextStyle(
      fontSize: 26,
      color: text.isError
          ? context.colorPalette().error.regular
          : text.color ?? context.colorPalette().foreground.getByEmphasis(text.emphasis),
      fontStyle: text.fontStyle,
    );
  }

  @override
  String get textName => 'H3';
}
