import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_body_text.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/components/text/styled_text_builder.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleBodyTextRenderer with IsTextStyleRenderer<StyledBodyText> {
  @override
  StyledTextBuilder<StyledText> get baseTextBuilder => StyledText.body;

  @override
  TextStyle getTextStyle(BuildContext context, StyledText text) {
    return TextStyle(
      fontSize: 13,
      color: text.isError
          ? context.colorPalette().error.regular
          : text.color ?? context.colorPalette().foreground.getByEmphasis(text.emphasis),
      fontStyle: text.fontStyle,
    );
  }

  @override
  String get textName => 'Body';
}
