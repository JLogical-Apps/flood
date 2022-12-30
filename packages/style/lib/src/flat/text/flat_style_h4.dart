import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_h4.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/components/text/styled_text_builder.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleH4Renderer with IsTextStyleRenderer<StyledH4> {
  @override
  StyledTextBuilder<StyledH4> get baseTextBuilder => StyledText.h4;

  @override
  TextStyle getTextStyle(BuildContext context, StyledText text) {
    return TextStyle(
      fontSize: 22,
      color: text.color ?? context.colorPalette().foreground.getByEmphasis(text.emphasis),
      fontStyle: text.fontStyle,
    );
  }

  @override
  String get textName => 'H4';
}
