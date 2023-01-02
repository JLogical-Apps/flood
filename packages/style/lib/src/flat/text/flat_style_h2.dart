import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_h2.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/components/text/styled_text_builder.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleH2Renderer with IsTextStyleRenderer<StyledH2> {
  @override
  StyledTextBuilder<StyledH2> get baseTextBuilder => StyledText.h2;

  @override
  TextStyle getTextStyle(BuildContext context, StyledText text) {
    return TextStyle(
      fontSize: 30,
      color: text.isError
          ? context.colorPalette().error.regular
          : text.color ?? context.colorPalette().foreground.getByEmphasis(text.emphasis),
      fontStyle: text.fontStyle,
    );
  }

  @override
  String get textName => 'H2';
}
