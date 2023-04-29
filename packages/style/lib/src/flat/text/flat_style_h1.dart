import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_h1.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/components/text/styled_text_builder.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleH1Renderer with IsTextStyleRenderer<StyledH1> {
  @override
  StyledTextBuilder<StyledH1> get baseTextBuilder => StyledText.h1;

  @override
  TextStyle getTextStyle(BuildContext context, StyledText text) {
    return TextStyle(
      fontSize: 36,
      color: text.isError
          ? context.colorPalette().error.regular
          : text.color ?? context.colorPalette().foreground.getByEmphasis(text.emphasis),
      fontStyle: text.fontStyle,
      fontWeight: text.fontWeight,
      overflow: TextOverflow.fade,
    );
  }

  @override
  String get textName => 'H1';
}
