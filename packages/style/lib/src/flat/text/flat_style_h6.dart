import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_h6.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/components/text/styled_text_builder.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleH6Renderer with IsTextStyleRenderer<StyledH6> {
  @override
  StyledTextBuilder<StyledH6> get baseTextBuilder => StyledText.h6;

  @override
  TextStyle getTextStyle(BuildContext context, StyledText text) {
    return TextStyle(
      fontSize: 18,
      color: text.isError
          ? context.colorPalette().error.regular
          : text.color ?? context.colorPalette().foreground.getByEmphasis(text.emphasis),
      fontStyle: text.fontStyle,
      fontWeight: text.fontWeight,
      overflow: TextOverflow.fade,
    );
  }

  @override
  String get textName => 'H6';
}
